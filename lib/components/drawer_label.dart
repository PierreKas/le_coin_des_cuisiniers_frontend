import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';

class DrawerLabel extends StatelessWidget {
  final String labelContent;
  const DrawerLabel({super.key, required this.labelContent});

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
