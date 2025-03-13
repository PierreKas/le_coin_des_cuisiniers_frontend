import 'dart:async';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/appbar_text.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_hearder.dart';
import 'package:le_coin_des_cuisiniers_app/services/user_service.dart';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/models/users.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<User> usersList = [];
  final UserService _userService = UserService();
  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  Future<void> _fetchAllUsers() async {
    final users = await _userService.getAllUsers();
    setState(() {
      usersList = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: chocolateColor,
        title: const MyAppBarText(
          content: 'Le coin des cuisiniers',
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: usersList.length,
              itemBuilder: (context, index) {
                final user = usersList[index];
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: MyTextHeader(
                        content: user.fullName,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email),
                          Text(user.address),
                          Text(user.phoneNumber),
                          Text(user.password!),
                          Text(
                            user.userStatus,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.role,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
