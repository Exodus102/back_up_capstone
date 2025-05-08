import 'package:flutter/material.dart';

class ChoicesButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const ChoicesButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Color(0xFF48494A),
            ),
          ),
          backgroundColor: Color(0xFFF1F7F9),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Color(0xFF48494A))),
      ),
    );
  }
}
