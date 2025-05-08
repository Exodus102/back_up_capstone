import 'package:flutter/material.dart';

class CustomTextDataTableReport extends StatelessWidget {
  final String text;
  const CustomTextDataTableReport({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;

    switch (text) {
      case "Approved":
      case "Resolved":
        bgColor = Color(0xFF29AB87);
        break;
      case "Pending":
      case "Unresolved":
        bgColor = const Color(0xFFEE6B6E);
        break;
      default:
        bgColor = Colors.grey;
        break;
    }

    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Text(
        textAlign: TextAlign.center,
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
