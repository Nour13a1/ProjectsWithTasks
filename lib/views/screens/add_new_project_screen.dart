import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:untitled8/models/app_user.dart';
import 'package:untitled8/viewmodels/projects_vm.dart';
import 'package:untitled8/viewmodels/users_states.dart';
import 'package:untitled8/viewmodels/users_vm.dart';

import '../components/app_users_list.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';

class AddNewProjectScreen extends StatefulWidget {
  const AddNewProjectScreen({super.key});

  @override
  State<AddNewProjectScreen> createState() => _AddNewProjectScreenState();
}

class _AddNewProjectScreenState extends State<AddNewProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startAtController = TextEditingController();
  final TextEditingController _endAtController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _progressController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  // ✅ Simulated user list from model (replace with actual data)
 /* final List<String> availableUsers = [
    'Alice Johnson',
    'Bob Smith',
    'Charlie Adams',
    'Diana Ross',
    'Ethan Clark',
  ];
*/
  List<AppUser> _selectedUsers = [];
  UserVM userVM = UserVM();
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) controller.text = _dateFormat.format(picked);
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final projectData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'users': _selectedUsers,
        'startAt': _startAtController.text,
        'endAt': _endAtController.text,
        'status': _statusController.text,
        'progress': double.tryParse(_progressController.text),
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Project created successfully!')),
      );

      debugPrint('Project Data: $projectData');
    }
  }
  ProjectVm projectVm = ProjectVm();
  @override
  Widget build(BuildContext context) {
    /*final items = availableUsers
        .map((user) => MultiSelectItem<String>(user, user))
        .toList();*/

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(label: 'Title', controller: _titleController),
              CustomTextField(label: 'Description', controller: _descriptionController),

              const SizedBox(height: 8),

              Text('Assign Users',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),

              const SizedBox(height: 6),
              BlocBuilder<UserVM, UsersStates>(builder: (ctx, state) {
                if (state is EmptyUsers) {
                  return Center(
                    child: ElevatedButton(
                        onPressed: () {
                          context.read<UserVM>().loadUserFromFirebase();
                        },
                        child: Text("Load users")
                    ),
                  );
                } else if (state is loadingUsers) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is loadedUsers) {
                  // Check if we have valid users with names
                  final validUsers = state.users.where((user) => user.name != null && user.name!.isNotEmpty).toList();

                  if (validUsers.isEmpty) {
                    return Column(
                      children: [
                        Text('No users with names found'),
                        ElevatedButton(
                          onPressed: () {
                            context.read<UserVM>().loadUserFromFirebase();
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    );
                  }

                  return AppUsersList(users: validUsers);
                } else {
                  return Container();
                }
              }),
             /* BlocBuilder<UserVM, UsersStates>(builder: (ctx,state){
                if(state is EmptyUsers)
                  return Center(child:
                  ElevatedButton(onPressed: ()async{
                    //  await ProjectVm.saveProjectTofirebase();
                    context.read<UserVM>().loadUserFromFirebase();
                  }, child: Text("load users")),);

                else if (state is loadingUsers) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is loadedUsers) {
                  return AppUsersList(users: state.users);
                } else {
                  return Container();
                }
              }),*/
/*
            FutureBuilder(future: userVM.loadUserFromFirebase(), builder: (ctx,snapshot){
              if(snapshot.connectionState == ConnectionState.done){
               return
                 MultiSelectDialogField<AppUser>(
                  items: userVM.users.map((user)=>MultiSelectItem(user, user.name!)).toList(),
                  title: const Text('Select Users'),
                  buttonText: const Text('Select Users'),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.white,
                  ),
                  searchable: true,
                  initialValue: _selectedUsers,
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    setState(() => _selectedUsers = values);
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    onTap: (value) {
                      setState(() => _selectedUsers.remove(value));
                    },
                  ),
                );
              }else
                return Center(child: CircularProgressIndicator(),);
            }),
*/

              const SizedBox(height: 12),

              // --- Date Pickers ---
              GestureDetector(
                onTap: () => _selectDate(context, _startAtController),
                child: AbsorbPointer(
                  child:
                  CustomTextField(label: 'Start Date', controller: _startAtController),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context, _endAtController),
                child: AbsorbPointer(
                  child:
                  CustomTextField(label: 'End Date', controller: _endAtController),
                ),
              ),

              CustomTextField(label: 'Status', controller: _statusController),
              CustomTextField(label: 'Progress (%)', controller: _progressController),

              const SizedBox(height: 24),

              ElevatedButton(onPressed: () {
                 ProjectVm.saveProjectTofirebase(title: _titleController.text, description: _descriptionController.text, users: [], endAt: _endAtController.text, createdAt: _startAtController.text, status: _statusController.text, progress: 0.0);
                //authVm.createaccountbygoogle();
                 Navigator.pushReplacementNamed(context, '/home');
              }
                , child: Text('Save Project',),
              ),
            ],
          ),
        ),
      ),
    );
  }
}