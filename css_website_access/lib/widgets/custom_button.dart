import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final String svgPath;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.svgPath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Color(0xFF064089),
          ),
        ),
        backgroundColor: Color(0xFFCFD8E5),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgPath,
            colorFilter: ColorFilter.mode(
              Color(0xFF064089),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF064089),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
