// widgets/user_list_item.dart

import 'package:flutter/material.dart';

import '../models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text('Age: ${user.age}, Email: ${user.email}'),
    );
  }
}
