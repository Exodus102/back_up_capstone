import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonForAction extends StatelessWidget {
  final String label;
  final String svgPath;
  final VoidCallback onPressed;
  const ButtonForAction({
    super.key,
    required this.label,
    required this.svgPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: Color(0xFF064089)),
      ),
      onPressed: onPressed,
      child: Row(
        spacing: 10,
        children: [
          SvgPicture.asset(
            svgPath,
            color: Color(0xFF064089),
            width: 15,
            height: 15,
          ),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF064089), // Text color
            ),
          ),
        ],
      ),
    );
  }
}
