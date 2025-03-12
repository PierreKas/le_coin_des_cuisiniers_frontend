import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;
  final bool enabled;

  const MyTextField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.grey,
      enabled: enabled,
      obscureText: obscureText,
      selectionControls: MaterialTextSelectionControls(),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: chocolateColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: chocolateColor,
        ),
      ),
    );
  }
}
