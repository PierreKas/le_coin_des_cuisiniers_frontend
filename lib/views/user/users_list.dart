import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_hearder.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/users.dart';
import 'package:le_coin_des_cuisiniers_app/views/user/add_user.dart';
import 'package:le_coin_des_cuisiniers_app/views/user/update_user.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<User> usersList = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final users = await UsersController().getUsers(context);
    setState(() {
      usersList = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 1050.0),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUser()),
              ),
            ),
          ),
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
                          Row(
                            children: [
                              const Text('Email'),
                              const SizedBox(
                                width: 85,
                              ),
                              Text(user.email),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Adresse'),
                              const SizedBox(
                                width: 70,
                              ),
                              Text(user.address),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Phone'),
                              const SizedBox(
                                width: 78,
                              ),
                              Text(user.phoneNumber),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Mot de passe'),
                              const SizedBox(
                                width: 32,
                              ),
                              Text(
                                user.password!,
                                style: const TextStyle(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Etat de compte'),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                user.userStatus,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Role'),
                              const SizedBox(
                                width: 90,
                              ),
                              Text(
                                user.role,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateUser(user: user),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmer la suppression'),
                                  content: Text(
                                    'Voulez-vous vraiment supprimer l\'utilisateur ${user.fullName} ?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Annuler'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        UsersController()
                                            .deleteUser(user.id!, context);
                                        Navigator.pop(context);
                                        _fetchUsers();
                                      },
                                      child: const Text('Supprimer'),
                                    ),
                                  ],
                                ),
                              );
                            },
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
