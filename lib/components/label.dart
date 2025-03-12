import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';

class MyLabel extends StatelessWidget {
  final String labelContent; // Marked as final
  const MyLabel({super.key, required this.labelContent});

  @override
  Widget build(BuildContext context) {
    return Text(
      labelContent,
      textAlign: TextAlign.start,
      style:
          const TextStyle(color: chocolateColor, fontWeight: FontWeight.bold),
    );
  }
}
