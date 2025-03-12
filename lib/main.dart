import 'dart:io';
import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';
import 'package:le_coin_des_cuisiniers_app/controller/transactions_controller.dart';
import 'package:le_coin_des_cuisiniers_app/views/home_page.dart';
import 'package:le_coin_des_cuisiniers_app/views/login.dart';
//import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider(
  //     create: (context) => TransactionsController(),
  //     child: MaterialApp(
  //       theme: ThemeData(
  //           textSelectionTheme: TextSelectionThemeData(
  //         selectionColor: chocolateColor.withOpacity(0.7),
  //         // cursorColor: chocolateColor,
  //       )),
  //       home: const HomePage(),
  //       debugShowCheckedModeBanner: false,
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
        selectionColor: chocolateColor.withOpacity(0.7),
        // cursorColor: chocolateColor,
      )),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
