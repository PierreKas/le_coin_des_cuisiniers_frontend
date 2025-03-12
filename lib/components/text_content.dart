import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';

class MyTextContent extends StatelessWidget {
  final String content;
  const MyTextContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(content,
        style: const TextStyle(
          fontSize: 25,
          color: chocolateColor,
          // color: Colors.white,
          fontWeight: FontWeight.w300,
        ));
  }
}
