import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/loading.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_hearder.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/logo.PNG',
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MyTextHeader(content: 'Le Coin des Cuisiniers'),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: _phoneController,
                    enabled: true,
                    hintText: 'Numéro de téléphone',
                    obscureText: false,
                    prefixIcon: Icons.phone_android,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: _passwordController,
                    enabled: true,
                    hintText: 'Mot de passe',
                    obscureText: true,
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 20),
                  MyButtons(
                    onPressed: () async {
                      showLoadingDialog(context);

                      try {
                        await UsersController().login(_phoneController.text,
                            _passwordController.text, context);
                      } catch (e, stackTrace) {
                        log('Login error: $e',
                            error: e, stackTrace: stackTrace);
                      }
                    },
                    text: 'Login',
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
