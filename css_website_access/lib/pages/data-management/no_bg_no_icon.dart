import 'package:flutter/material.dart';

class NoBgNoIcon extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const NoBgNoIcon({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color(0xFF064089),
          ),
        ),
        foregroundColor: const Color(0xFF064089),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
