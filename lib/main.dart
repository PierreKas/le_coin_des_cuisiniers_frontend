import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/configurations/routes.dart';
import 'package:le_coin_des_cuisiniers_app/controller/transactions_controller.dart';
import 'package:le_coin_des_cuisiniers_app/controller/users_controller.dart';
import 'package:le_coin_des_cuisiniers_app/services/aut_token.dart';
import 'package:le_coin_des_cuisiniers_app/views/home_page.dart';
import 'package:le_coin_des_cuisiniers_app/views/login.dart';
//import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';

void main() async {
  // final token = AuthToken.getToken();
  // final role = AuthToken.getUserRole();

  // if (token != null && role != null) {
  //   UsersController.userRole = role; // Set the role from localStorage
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final token = AuthToken.getToken();
    // final initialPage = token != null ? const HomePage() : const LoginPage();

    return ChangeNotifierProvider(
      create: (context) => TransactionsController(),
      child: MaterialApp.router(
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: chocolateColor.withOpacity(0.7),
            // cursorColor: chocolateColor,
          ),
        ),
        routerConfig: Routes().router,
        //  home: initialPage, //const LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
