import 'package:flutter/material.dart';

class CustomButtonTransparentBg extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomButtonTransparentBg({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(
              color: Color(0xFF064089),
              width: 2,
            ),
          ),
        ),
        child: Text(
          "Backup",
          style: TextStyle(
            color: Color(0xFF064089),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
