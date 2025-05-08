import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonForUse extends StatelessWidget {
  final String label;
  final String svgPath;
  final VoidCallback onPressed;
  final String status;

  const ButtonForUse({
    super.key,
    required this.label,
    required this.svgPath,
    required this.onPressed,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor = status == "1" ? Color(0xFF064089) : Colors.transparent;
    Color textColor = status == "1" ? Colors.white : Color(0xFF064089);
    String buttonText = status == "1" ? "In Use" : "Use";
    return SizedBox(
      width: 100,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: Color(0xFF064089)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            SvgPicture.asset(
              svgPath,
              color: textColor,
              width: 18,
              height: 18,
            ),
            Text(
              buttonText,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
