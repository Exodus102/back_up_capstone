import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  const TextTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Data Management",
      style: TextStyle(
        color: Color(0xFF064089),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
