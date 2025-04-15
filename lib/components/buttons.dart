import 'package:flutter/material.dart';
import 'package:le_coin_des_cuisiniers_app/colors/colors.dart';

// class MyButtons extends StatefulWidget {
//   final void Function()? onPressed;
//   final String text;
//   final double? width;
//   final double? height;
//   const MyButtons(
//       {super.key,
//       required this.onPressed,
//       required this.text,
//       this.width,
//       this.height});

//   @override
//   State<MyButtons> createState() => _MyButtonsState();
// }

// class _MyButtonsState extends State<MyButtons> {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: widget.onPressed,
//       style: ElevatedButton.styleFrom(backgroundColor: chocolateColor),
//       child: Text(
//         widget.text,
//         style: const TextStyle(
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
class MyButtons extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final double? width;
  final double? height;
  const MyButtons(
      {super.key,
      required this.onPressed,
      required this.text,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [chocolateColor, chocolateColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: chocolateColor.withOpacity(0.3),
            blurRadius: 8,
            //offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
