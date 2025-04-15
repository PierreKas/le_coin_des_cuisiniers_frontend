import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/components/buttons.dart';
import 'package:le_coin_des_cuisiniers_app/components/loading.dart';
import 'package:le_coin_des_cuisiniers_app/components/text_hearder.dart';
import 'package:le_coin_des_cuisiniers_app/components/textfields.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Center(
//             child: Opacity(
//               opacity: 0.2,
//               child: Image.asset(
//                 'assets/logo.PNG',
//                 fit: BoxFit.cover,
//                 width: 120,
//                 height: 120,
//               ),
//             ),
//           ),
//           Center(
//             child: SizedBox(
//               width: 300,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const MyTextHeader(content: 'Le Coin des Cuisiniers'),
//                   const SizedBox(height: 20),
//                   MyTextField(
//                     controller: _phoneController,
//                     enabled: true,
//                     hintText: 'Numéro de téléphone',
//                     obscureText: false,
//                     prefixIcon: Icons.phone_android,
//                   ),
//                   const SizedBox(height: 20),
//                   MyTextField(
//                     controller: _passwordController,
//                     enabled: true,
//                     hintText: 'Mot de passe',
//                     obscureText: true,
//                     prefixIcon: Icons.lock,
//                   ),
//                   const SizedBox(height: 20),
//                   MyButtons(
//                     onPressed: () async {
//                       showLoadingDialog(context, 'Connexion en cours...');

//                       try {
//                         await UsersController().login(_phoneController.text,
//                             _passwordController.text, context);
//                         Navigator.of(context).pop();
//                       } catch (e, stackTrace) {
//                         print('error: $e');
//                         Navigator.of(context).pop();
//                         log('Login error');
//                       }
//                       _passwordController.clear();
//                       _phoneController.clear();
//                     },
//                     text: 'Login',
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//}
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
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 380),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius:
                            10, //The more I add this value, the more the shadow increase the size outside the container
                        offset: const Offset(0,
                            5), //Reduce the power of shadow on the top of the container
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
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {},
                      //     style: TextButton.styleFrom(
                      //       foregroundColor: Colors.black.withOpacity(0.7),
                      //       //padding: EdgeInsets.zero,
                      //       //minimumSize: const Size(30, 0),
                      //     ),
                      //     child: const Text(
                      //       'Forget password?',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 12,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 25),
                      MyButtons(
                        height: 50,
                        width: double.infinity,
                        onPressed: () async {
                          showLoadingDialog(context, 'Connexion en cours...');

                          try {
                            await UsersController().login(_phoneController.text,
                                _passwordController.text, context);
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
                      // MyButtons(
                      //   height: 50,
                      //   width: double.infinity,
                      //   onPressed: () async {
                      //     print("LOGIN BUTTON PRESSED");
                      //     showLoadingDialog(context);
                      //     print("LOADING DIALOG SHOWN");

                      //     try {
                      //       print("ATTEMPTING LOGIN");
                      //       final success = await MembershipController().login(
                      //         _phoneController.text,
                      //         _passwordController.text,
                      //         context,
                      //       );
                      //       print("LOGIN RETURNED: $success");

                      //       print("DISMISSING LOADING DIALOG");
                      //       Navigator.of(context).pop(); // Dismiss dialog
                      //       print("LOADING DIALOG DISMISSED");

                      //       if (success) {
                      //         print("SUCCESSFUL LOGIN - NAVIGATING TO HOME");
                      //         // Use pushReplacement instead of push
                      //         Navigator.pushReplacement(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => const HomePages()));
                      //         print(
                      //             "NAVIGATION PUSHED"); // This might not print if navigation works
                      //       } else {
                      //         print("LOGIN FAILED - SHOWING ERROR");
                      //         MySnackBar.showErrorMessage(
                      //             'Login failed', context);
                      //       }
                      //     } catch (e, stackTrace) {
                      //       print("LOGIN EXCEPTION: $e");
                      //       Navigator.of(context).pop(); // Dismiss dialog
                      //       log('Login error: $e',
                      //           error: e, stackTrace: stackTrace);
                      //       MySnackBar.showErrorMessage(
                      //           'Login error: ${e.toString()}', context);
                      //     }

                      //     print("CLEARING TEXT FIELDS");
                      //     _passwordController.clear();
                      //     _phoneController.clear();
                      //   },
                      //   text: 'Login',
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
