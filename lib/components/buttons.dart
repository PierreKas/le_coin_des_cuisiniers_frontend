import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';

class MyButtons extends StatefulWidget {
  final void Function()? onPressed;
  final String text;
  const MyButtons({super.key, required this.onPressed, required this.text});

  @override
  State<MyButtons> createState() => _MyButtonsState();
}

class _MyButtonsState extends State<MyButtons> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: chocolateColor),
      child: Text(
        widget.text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

// setState(() {
//                           isLoading = true;
//                         });
//                         Future.delayed(const Duration(seconds: 5), () {
//                           setState(() {
//                             isLoading = false;
//                           });
//                         });