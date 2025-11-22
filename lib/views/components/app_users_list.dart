import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:untitled8/models/app_user.dart';

class AppUsersList extends StatefulWidget {
  final List<AppUser> users;

  const AppUsersList({super.key, required this.users});

  @override
  State<AppUsersList> createState() => _AppUsersListState();
}

class _AppUsersListState extends State<AppUsersList> {
  List<AppUser> _selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField<AppUser>(
      items: widget.users
          .where((user) => user.name != null && user.name!.isNotEmpty)
          .map((user) => MultiSelectItem(user, user.name!))
          .toList(),
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
  }
}