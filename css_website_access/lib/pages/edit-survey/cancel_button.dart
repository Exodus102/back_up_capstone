import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CancelButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFEE6B6E)),
        ),
        backgroundColor: const Color(0xFFEDE2E3),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFEE6B6E),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
