import 'package:flutter/material.dart';

class EditQuestionTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const EditQuestionTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      cursorColor: const Color(0xFF07326A),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: "Edit Question",
        labelStyle: TextStyle(color: Color(0xFF07326A)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF07326A)),
        ),
      ),
      onEditingComplete: () {},
    );
  }
}
