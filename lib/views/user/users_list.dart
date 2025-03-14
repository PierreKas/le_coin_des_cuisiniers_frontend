// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:le_coin_des_cuisiniers_app/components/text_hearder.dart';
// import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
// import 'package:le_coin_des_cuisiniers_app/models/users.dart';
// import 'package:le_coin_des_cuisiniers_app/views/user/add_user.dart';
// import 'package:le_coin_des_cuisiniers_app/views/user/update_user.dart';

// class UsersList extends StatefulWidget {
//   const UsersList({super.key});

//   @override
//   State<UsersList> createState() => _UsersListState();
// }

// class _UsersListState extends State<UsersList> {
//   List<User> usersList = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//   }

//   Future<void> _fetchUsers() async {
//     final users = await UsersController().getUsers(context);
//     setState(() {
//       usersList = users;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 1050.0),
//             child: IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AddUser()),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: usersList.length,
//               itemBuilder: (context, index) {
//                 final user = usersList[index];
//                 return Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Container(
//                     color: Colors.white,
//                     child: ListTile(
//                       title: MyTextHeader(
//                         content: user.fullName,
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Text('Email'),
//                               const SizedBox(
//                                 width: 85,
//                               ),
//                               Text(user.email),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Text('Adresse'),
//                               const SizedBox(
//                                 width: 70,
//                               ),
//                               Text(user.address),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Text('Phone'),
//                               const SizedBox(
//                                 width: 78,
//                               ),
//                               Text(user.phoneNumber),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Text('Mot de passe'),
//                               const SizedBox(
//                                 width: 32,
//                               ),
//                               Text(
//                                 user.password!,
//                                 style: const TextStyle(),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Text('Etat de compte'),
//                               const SizedBox(
//                                 width: 20,
//                               ),
//                               Text(
//                                 user.userStatus,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Text('Role'),
//                               const SizedBox(
//                                 width: 90,
//                               ),
//                               Text(
//                                 user.role,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => UpdateUser(user: user),
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (context) => AlertDialog(
//                                   title: const Text('Confirmer la suppression'),
//                                   content: Text(
//                                     'Voulez-vous vraiment supprimer l\'utilisateur ${user.fullName} ?',
//                                   ),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context),
//                                       child: const Text('Annuler'),
//                                     ),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         UsersController()
//                                             .deleteUser(user.id!, context);
//                                         Navigator.pop(context);
//                                         _fetchUsers();
//                                       },
//                                       child: const Text('Supprimer'),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final users = await UsersController().getUsers(context);

    setState(() {
      usersList = users;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Liste des Utilisateurs',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label:
                  const Text('Ajouter', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: chocolateColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUser()),
              ).then((_) => _fetchUsers()),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: chocolateColor,
            ))
          : usersList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun utilisateur trouvé',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: usersList.length,
                    itemBuilder: (context, index) {
                      final user = usersList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: _getRoleColor(user.role),
                                  radius: 24,
                                  child: Text(
                                    user.fullName.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.fullName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(user.userStatus),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    user.userStatus,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildInfoRow('Email', user.email),
                                  _buildInfoRow('Adresse', user.address),
                                  _buildInfoRow('Téléphone', user.phoneNumber),
                                  _buildInfoRow('Mot de passe', '••••••••'),
                                  _buildInfoRow('Rôle', user.role,
                                      isBold: true),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton.icon(
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Modifier'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                          side: const BorderSide(
                                              color: Colors.blue),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateUser(user: user),
                                          ),
                                        ).then((_) => _fetchUsers()),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.delete),
                                        label: const Text('Supprimer'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Confirmer la suppression'),
                                              content: Text(
                                                'Voulez-vous vraiment supprimer l\'utilisateur ${user.fullName} ?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Annuler'),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    UsersController()
                                                        .deleteUser(
                                                            user.id!, context);
                                                    Navigator.pop(context);
                                                    _fetchUsers();
                                                  },
                                                  child:
                                                      const Text('Supprimer'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: chocolateColor,
        onPressed: _fetchUsers,
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'autorise':
        return Colors.green;
      case 'non autorise':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return chocolateColor;
      default:
        return Colors.black;
    }
  }
}
