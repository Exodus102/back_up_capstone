import 'package:flutter/material.dart';

class EditableDataCellCss extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final Function() onUpdate;
  final Function() onCancel;

  const EditableDataCellCss({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onUpdate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            cursorColor: Color(0xFF064089),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF064089),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: onUpdate,
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: onCancel,
        ),
      ],
    );
  }
}
