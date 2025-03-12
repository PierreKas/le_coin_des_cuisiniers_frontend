import 'package:flutter/material.dart';

class MyAppBarText extends StatelessWidget {
  final String content;
  const MyAppBarText({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(content,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ));
  }
}
