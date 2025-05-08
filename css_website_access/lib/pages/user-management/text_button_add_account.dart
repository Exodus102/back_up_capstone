import 'package:flutter/material.dart';

class TextButtonAddAccount extends StatelessWidget {
  final VoidCallback onCancel;
  const TextButtonAddAccount({
    super.key,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onCancel,
      child: const Text(
        'Cancel',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF064089),
        ),
      ),
    );
  }
}
