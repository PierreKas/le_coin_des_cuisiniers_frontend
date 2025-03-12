import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';

class MyTextHeader extends StatelessWidget {
  final String content;
  const MyTextHeader({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(content,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: chocolateColor,
        ));
  }
}
