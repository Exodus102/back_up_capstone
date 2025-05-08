import 'package:flutter/material.dart';

class CustomTextSurveyP1 extends StatelessWidget {
  final String text;
  const CustomTextSurveyP1({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF1E1E1E),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
