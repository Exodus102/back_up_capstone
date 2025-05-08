import 'package:flutter/material.dart';

class CustomButtonLogin extends StatelessWidget {
  final String label;
  final double width;
  final VoidCallback onPressed;
  const CustomButtonLogin({
    super.key,
    required this.label,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Color(0xFF064089),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: Color(0xFFF1F7F9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
