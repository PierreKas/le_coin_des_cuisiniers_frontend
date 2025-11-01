import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/loading.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_hearder.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/responsive/dimensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: chocolateColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: chocolateColor.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/logo.PNG',
                fit: BoxFit.cover,
                width: 180,
                height: 180,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: (constraints.maxWidth > tabletWidth)
                              ? 550
                              : (constraints.maxWidth <= tabletWidth &&
                                      constraints.maxWidth > mobileWidth)
                                  ? 300
                                  : 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const MyTextHeader(
                            content: 'Le coin des cuisiniers',
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            thickness: 4,
                            endIndent: 90,
                            indent: 90,
                            color: chocolateColor,
                          ),
                          const SizedBox(height: 30),
                          MyTextField(
                            controller: _phoneController,
                            enabled: true,
                            hintText: 'Phone number',
                            obscureText: false,
                            prefixIcon: Icons.phone_android,
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: _passwordController,
                            enabled: true,
                            hintText: 'Password',
                            obscureText: true,
                            prefixIcon: Icons.lock,
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 25),
                          MyButtons(
                            height: 50,
                            width: double.infinity,
                            onPressed: () async {
                              showLoadingDialog(
                                  context, 'Connexion en cours...');

                              try {
                                await UsersController().login(
                                    _phoneController.text,
                                    _passwordController.text,
                                    context);
                                Navigator.of(context).pop();
                              } catch (e, stackTrace) {
                                print('error: $e');
                                Navigator.of(context).pop();
                                log('Login error');
                              }
                              _passwordController.clear();
                              _phoneController.clear();
                            },
                            text: 'Login',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
