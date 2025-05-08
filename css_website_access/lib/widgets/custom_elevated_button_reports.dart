import 'package:flutter/material.dart';

class CustomElevatedButtonReports extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;
  const CustomElevatedButtonReports({
    super.key,
    required this.text,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            return active ? Color(0xFF064089) : Color(0xFFCFD8E5);
          },
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: active ? Color(0xFFF1F7F9) : Color(0xFF767B81),
        ),
      ),
    );
  }
}
