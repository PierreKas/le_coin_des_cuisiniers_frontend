import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';

class MySnackBar {
  static void showSuccessMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 200,
        content: Text(message),
        backgroundColor: chocolateColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showErrorMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 200,
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void checked(Widget checkIcon, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        width: 50,
        content: Icon(
          Icons.check,
          color: chocolateColor,
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
      ),
    );
  }
}
