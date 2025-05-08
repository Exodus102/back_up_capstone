import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShowButton extends StatelessWidget {
  final String label;

  final VoidCallback onPressed;
  final String svgPath;
  const ShowButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Color(0xFF064089),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          SvgPicture.asset(
            svgPath,
            colorFilter: ColorFilter.mode(
              Color(0xFFF1F7F9),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFFF1F7F9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
