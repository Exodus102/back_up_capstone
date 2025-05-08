import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SurveyButton extends StatelessWidget {
  final String svgPath;
  final String text;
  final VoidCallback? onPressed;
  const SurveyButton({
    super.key,
    required this.svgPath,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
      child: Row(
        spacing: 10,
        children: [
          SvgPicture.asset(
            svgPath,
            colorFilter: ColorFilter.mode(
              Color(0xFF48494A),
              BlendMode.srcIn,
            ),
          ),
          Text(text, style: TextStyle(color: Color(0xFF48494A))),
        ],
      ),
    );
  }
}
