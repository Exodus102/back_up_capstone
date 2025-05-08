import 'package:flutter/material.dart';

class CustomButtonNoIcon extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CustomButtonNoIcon({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Color(0xFF064089),
          ),
        ),
        backgroundColor: Color(0xFFCFD8E5),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Color(0xFF064089),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
