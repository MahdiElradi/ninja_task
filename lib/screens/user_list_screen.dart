// screens/user_list_screen.dart

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../widgets/user_list_item.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? usersJson = prefs.getStringList('users');
    if (usersJson != null) {
      setState(() {
        users =
            usersJson.map((json) => User.fromJson(jsonDecode(json))).toList();
      });
    }
  }

  Future<void> _saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    users.add(user);
    final List<String> usersJson =
        users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('users', usersJson);
    setState(() {
      // Update UI with the new list of users
    });
  }

  User _generateRandomUser() {
    final String name = 'User ${random.nextInt(1000)}';
    final int age = 18 + random.nextInt(50);
    final String email = 'user${random.nextInt(1000)}@example.com';
    return User(name: name, age: age, email: email);
  }

  void _addRandomUser() {
    final User randomUser = _generateRandomUser();
    _saveUser(randomUser);
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
    _updateUsersInPrefs();
  }

  void _archiveUser(int index) {
    // Implement archive functionality here
  }

  void _updateUsersInPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> usersJson =
        users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('users', usersJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Dismissible(
            key: Key(user.email), // Unique key for each user
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20.0),
              child: const Icon(
                Icons.archive,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                _deleteUser(index);
              } else {
                _archiveUser(index);
              }
            },
            child: UserListItem(user: user),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRandomUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
