import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final bool hasError;

  const CustomTextField({
    super.key,
    this.onChanged,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : const Color(0xFF064089),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
