import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/viewmodels/tasks_vm.dart';

import '../../viewmodels/projects_vm.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';

class AddEditTaskScreen extends StatefulWidget {
  final String projectId;
  const AddEditTaskScreen({super.key, required this.projectId});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? startDate; // Changed to nullable
  DateTime? deadline; // Changed to nullable
  List<dynamic> users = [];
  List<String> projectMembers = [];
  String selectedAssignee = "Unassigned";
  bool isLoadingMembers = true;
  String? projectId; // Changed to nullable
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getProjectId();
  }
  @override
  void initState() {
    super.initState();
    _loadUsersFromFirestore();
    _loadProjectMembers();
  }


  void _getProjectId() {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null) {
      setState(() {
        projectId = arguments as String;
      });
    }
  }
  void _loadProjectMembers() async {
    try {
      setState(() { isLoadingMembers = true; });

      // Use widget.projectId instead of projectId
      print('=== DEBUG: Trying to load project with ID: "${widget.projectId}"');
      print('=== DEBUG: Project ID length: ${widget.projectId.length}');
      print('=== DEBUG: Project ID trimmed: "${widget.projectId.trim()}"');

      final projectDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId.trim()) // Use widget.projectId
          .get();

      print('=== DEBUG: Project document exists: ${projectDoc.exists}');

      if (!projectDoc.exists) {
        print('=== DEBUG: ❌ PROJECT NOT FOUND IN FIRESTORE!');
        print('=== DEBUG: The ID "${widget.projectId}" does not exist');

        // List all projects to see what's available
        final allProjects = await FirebaseFirestore.instance
            .collection('projects')
            .get();

        print('=== DEBUG: Available project IDs:');
        for (var doc in allProjects.docs) {
          print('=== DEBUG: - ${doc.id}');

          // Check if there's a similar ID
          if (doc.id.toLowerCase().contains(widget.projectId.toLowerCase()) ||
              widget.projectId.toLowerCase().contains(doc.id.toLowerCase())) {
            print('=== DEBUG:   🔍 Similar to your ID: "${widget.projectId}"');
          }
        }
      } else {
        // Project found! Now load members
        final data = projectDoc.data()!;
        print('=== DEBUG: ✅ Project found! Title: ${data['title']}');

        final members = data['users'] as List<dynamic>? ?? [];
        print('=== DEBUG: Members found: $members');

        setState(() {
          projectMembers = members.map((e) => e.toString()).toList();
        });
      }

    } catch (e) {
      print("=== DEBUG: Error: $e");
    } finally {
      setState(() { isLoadingMembers = false; });
    }
  }
  // Alternative: Load members directly from Firestore
  void _loadProjectMembersFromFirestore() async {
    try {
      setState(() {
        isLoadingMembers = true;
      });

      final projectDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId!)
          .get();

      if (projectDoc.exists) {
        final data = projectDoc.data();
        final members = data?['users'] as List<dynamic>?;

        setState(() {
          projectMembers = members?.map((e) => e.toString()).toList() ?? [];
        });
      }

    } catch (e) {
      print("Error loading project members: $e");
    } finally {
      setState(() {
        isLoadingMembers = false;
      });
    }
  }



  void _loadUsersFromFirestore() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      final userList = querySnapshot.docs
          .map((doc) => doc.data()['email'] ?? doc.id)
          .toList();

      setState(() {
        users = userList;
      });
    } catch (e) {
      print("Error loading users: $e");
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate ?? now : deadline ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          deadline = picked;
        }
      });
    }
  }

  void _saveTask() async {
    // Check if projectId is available
    if (projectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project ID is missing')),
      );
      return;
    }

    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    if (startDate == null || deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start date and deadline')),
      );
      return;
    }

    try {
      await TaskVm.saveTaskTofirebase(
        projectId: projectId!,
        title: titleController.text,
        description: descriptionController.text,
        startDate: startDate!,
        deadline: deadline!,
        assignee: selectedAssignee,
        imagePath: "imagePath",
        isCompleted: false, // Changed to boolean
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      //Navigator.pushReplacementNamed(context, '/taskList');
      Navigator.pushNamed(
        context,
        '/taskList',
        arguments: projectId, // Pass project ID as argument
      );


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(label: "Task Title", controller: titleController),
              CustomTextField(
                label: "Description",
                controller: descriptionController,
              ),
              const SizedBox(height: 12),

              // Date pickers
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickDate(context, true),
                      icon: const Icon(Icons.calendar_today_outlined, size: 18),
                      label: Text(
                          startDate == null ? "Start Date" : dateFormat.format(startDate!)
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickDate(context, false),
                      icon: const Icon(Icons.flag_outlined, size: 18),
                      label: Text(
                          deadline == null ? "Deadline" : dateFormat.format(deadline!)
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Assignee dropdown - Now shows project members
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Assign to", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  isLoadingMembers
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<String>(
                    value: selectedAssignee,
                    items: [
                      const DropdownMenuItem(
                        value: "Unassigned",
                        child: Text("Unassigned"),
                      ),
                      ...projectMembers.map((member) => DropdownMenuItem(
                        value: member,
                        child: Text(member),
                      )).toList(),
                    ],
                    onChanged: (val) {
                      setState(() {
                        selectedAssignee = val!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Image picker placeholder
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.image_outlined),
                label: const Text("Attach Image (optional)"),
              ),
              const SizedBox(height: 30),

              CustomButton(
                text: "Save Task",
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}