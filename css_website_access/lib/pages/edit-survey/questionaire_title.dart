import 'package:flutter/material.dart';

class QuestionaireTitle extends StatelessWidget {
  const QuestionaireTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Questionnaires",
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF064089),
      ),
    );
  }
}
