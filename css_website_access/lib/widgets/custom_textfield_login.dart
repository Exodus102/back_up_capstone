import 'package:flutter/material.dart';

class CustomTextfieldLogin extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool isObscure;
  final bool? color;
  final Function(String)? onSubmitted;
  const CustomTextfieldLogin({
    super.key,
    required this.label,
    this.controller,
    this.isObscure = false,
    this.color,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = color == true ? Colors.red : const Color(0xFF064089);

    return SizedBox(
      child: TextField(
        onSubmitted: onSubmitted,
        obscureText: isObscure,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: const Color(0xFF064089),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: borderColor,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: borderColor,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
