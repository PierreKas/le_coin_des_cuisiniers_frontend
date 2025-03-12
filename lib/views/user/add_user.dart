import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/label.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/models/users.dart';
import 'package:le_coin_des_cuisiniers_app/views/acceuil.dart';
import 'package:le_coin_des_cuisiniers_app/views/base_layout.dart';
import 'package:le_coin_des_cuisiniers_app/views/product/products_list.dart';
import 'package:le_coin_des_cuisiniers_app/views/transactions/add_transactions.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? selectedRole;
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
                    'Complétez ici les informations du nouveau utilisateur',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 73, 71, 71),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // const Text(
                  //   'Complétez ici les informations du nouveau utilisateur',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(color: Colors.grey),
                  // ),
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
                            const SizedBox(
                              height: 16,
                            ),
                            const MyLabel(labelContent: 'role'),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: selectedRole,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        const BorderSide(color: chocolateColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.work_outline,
                                    color: chocolateColor,
                                  )),
                              items: const [
                                DropdownMenuItem(
                                  value: 'ADMIN',
                                  child: Text('ADMIN'),
                                ),
                                DropdownMenuItem(
                                  value: 'VENDEUR',
                                  child: Text('VENDEUR'),
                                ),
                              ],
                              onChanged: (String? role) {
                                setState(() {
                                  selectedRole = role;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  MyButtons(
                    onPressed: () {
                      User newUser = User(
                        fullName: _fullName.text,
                        email: _email.text,
                        address: _address.text,
                        password: _password.text,
                        phoneNumber: _phoneNumber.text,
                        userStatus: 'NON AUTORISE',
                        role: selectedRole!,
                      );

                      UsersController().addUser(newUser, context);
                    },
                    text: 'Ajouter',
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
