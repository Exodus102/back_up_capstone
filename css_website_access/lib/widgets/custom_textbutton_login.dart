import 'package:flutter/material.dart';

class CustomTextbuttonLogin extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const CustomTextbuttonLogin({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Color(0xFF064089),
        ),
      ),
    );
  }
}

class CustomeTextButtonLoginPassword extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomeTextButtonLoginPassword({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Text(
        "not you?",
        style: TextStyle(
          color: Color(0xFF48494A),
          fontSize: 17,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
