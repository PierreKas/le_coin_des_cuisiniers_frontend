import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/label.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/users.dart';
import 'package:le_coin_des_cuisiniers_app/views/acceuil.dart';
import 'package:le_coin_des_cuisiniers_app/views/base_layout.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/add_trans.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/add_transactions.dart';
import 'package:le_coin_des_cuisiniers_app/views/user/users_list.dart';

class UpdateUser extends StatefulWidget {
  final User user;
  const UpdateUser({super.key, required this.user});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late TextEditingController _fullName;
  late TextEditingController _phoneNumber;
  late TextEditingController _address;
  late TextEditingController _email;
  late TextEditingController _password;
  late String _userStatus;
  // late String _role;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController(text: widget.user.fullName);
    _phoneNumber = TextEditingController(text: widget.user.phoneNumber);
    _address = TextEditingController(text: widget.user.address);
    _email = TextEditingController(text: widget.user.email);
    _password = TextEditingController(text: widget.user.password);
    _userStatus = widget.user.userStatus;
    // _role = widget.user.role;
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      initialIndex: 2,
      pages: [
        const Acceuil(),
        const ProductsList(),
        Stack(children: [
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/logo.PNG',
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Mettre à jour l\'utilisateur',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 73, 71, 71),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MyLabel(
                                labelContent: 'Nom complet de l\'utilisateur'),
                            const SizedBox(height: 10),
                            MyTextField(
                              enabled: true,
                              obscureText: false,
                              controller: _fullName,
                              hintText: 'Nom complet',
                              prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 16),
                            const MyLabel(labelContent: 'Numero de téléphone'),
                            const SizedBox(height: 10),
                            MyTextField(
                              enabled: true,
                              obscureText: false,
                              controller: _phoneNumber,
                              hintText: 'Numéro de téléphone',
                              prefixIcon: Icons.phone_android,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MyLabel(labelContent: 'Adresse'),
                            const SizedBox(height: 10),
                            MyTextField(
                              enabled: true,
                              obscureText: false,
                              controller: _address,
                              hintText: 'Adresse',
                              prefixIcon: Icons.location_on_outlined,
                            ),
                            const SizedBox(height: 16),
                            const MyLabel(labelContent: 'Password'),
                            const SizedBox(height: 10),
                            MyTextField(
                              enabled: true,
                              controller: _password,
                              hintText: 'Mot de passe',
                              obscureText: true,
                              prefixIcon: Icons.password,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MyLabel(labelContent: 'Adresse email'),
                            const SizedBox(height: 10),
                            MyTextField(
                              enabled: true,
                              obscureText: false,
                              controller: _email,
                              hintText: 'Email',
                              prefixIcon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 16),
                            const MyLabel(labelContent: 'Statut du compte'),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: _userStatus,
                              items: ['NON AUTORISE', 'AUTORISE']
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _userStatus = value!;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.person_pin_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 16),
                            // const MyLabel(labelContent: 'Role'),
                            // const SizedBox(height: 10),
                            // DropdownButtonFormField<String>(
                            //   value: _role,
                            //   items: ['ADMIN', 'VENDEUR']
                            //       .map((role) => DropdownMenuItem(
                            //             value: role,
                            //             child: Text(role),
                            //           ))
                            //       .toList(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       _role = value!;
                            //     });
                            //   },
                            //   decoration: InputDecoration(
                            //     prefixIcon:
                            //         const Icon(Icons.person_pin_outlined),
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  MyButtons(
                    onPressed: () {
                      User updatedUser = User(
                        id: widget.user.id,
                        fullName: _fullName.text,
                        email: _email.text,
                        address: _address.text,
                        password: _password.text,
                        phoneNumber: _phoneNumber.text,
                        userStatus: _userStatus,
                        role: widget.user.role,
                      );

                      UsersController()
                          .updateUser(widget.user.id!, updatedUser, context);

                      //                    Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      //   builder: (context) => BaseLayout(
                      //     initialIndex: 1, // Sales page index
                      //     pages: [
                      //       const Acceuil(), // First page
                      //       if (UsersController.userRole == 'ADMIN') const ProductsList(),
                      //       if (UsersController.userRole == 'ADMIN') const UsersList(),
                      //       const AddTransaction(), // Last page (sales/transactions)
                      //     ],
                      //     initialPage: BillItems(transaction: transactionn),
                      //   ),
                      // ),
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BaseLayout(
                                  initialIndex: 2,
                                  pages: [
                                    const Acceuil(), // First page
                                    if (UsersController.userRole == 'ADMIN')
                                      const ProductsList(),
                                    if (UsersController.userRole == 'ADMIN')
                                      const UsersList(),
                                    const AddTransaction(),
                                  ],
                                  initialPage: const UsersList(),
                                )),
                      );
                    },
                    text: 'Mettre à jour',
                  ),
                ],
              ),
            ),
          ),
        ]),
        const AddTransaction()
      ],
    );
  }
}
