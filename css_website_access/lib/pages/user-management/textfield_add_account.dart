import 'package:flutter/material.dart';

class TextfieldAddAccount extends StatelessWidget {
  final double width;
  final String hintText;
  final TextEditingController controller;
  final bool enabled;

  const TextfieldAddAccount({
    super.key,
    required this.hintText,
    required this.width,
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30, // Apply height
      width: width,
      child: TextField(
        enabled: enabled,
        controller: controller,
        cursorColor: Color(0xFF064089),
        cursorHeight: 18,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFF878A8B),
          ),
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF464748),
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF064089),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
