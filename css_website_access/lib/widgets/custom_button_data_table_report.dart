import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButtonDataTableReport extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final String? label;
  final String? svgPath;

  const CustomButtonDataTableReport({
    super.key,
    required this.backgroundColor,
    this.onPressed,
    this.label,
    this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVerified = label == "Verified";
    final bool isDisabled = onPressed == null;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isVerified ? const Color(0xFF064089) : backgroundColor,
        foregroundColor: isVerified ? Colors.white : const Color(0xFF064089),
        disabledBackgroundColor:
            isVerified ? const Color(0xFF064089) : backgroundColor,
        disabledForegroundColor:
            isVerified ? Colors.white : const Color(0xFF064089),
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
            svgPath ?? 'svg/icons/view-eye.svg',
            color: isVerified ? Colors.white : const Color(0xFF064089),
            width: 15,
            height: 15,
          ),
          const SizedBox(width: 8),
          Text(label ?? "View"),
        ],
      ),
    );
  }
}
