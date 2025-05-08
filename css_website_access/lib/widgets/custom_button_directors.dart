import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButtonDirectors extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final String label;
  final String svg;

  const CustomButtonDirectors({
    super.key,
    required this.backgroundColor,
    this.onPressed,
    required this.label,
    required this.svg,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEndorsed = label.toLowerCase() == 'endorsed';
    final bool isDisabled = onPressed == null;

    final Color bgColor = isDisabled
        ? (isEndorsed ? const Color(0xFF064089) : backgroundColor)
        : (isEndorsed ? const Color(0xFF064089) : backgroundColor);

    final Color textColor = isDisabled
        ? (isEndorsed ? Colors.white : const Color(0xFF064089))
        : (isEndorsed ? Colors.white : const Color(0xFF064089));

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        disabledBackgroundColor: bgColor,
        disabledForegroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF064089)),
          borderRadius: BorderRadius.circular(60),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svg,
            color: textColor,
            width: 15,
            height: 15,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isEndorsed ? FontWeight.bold : FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
