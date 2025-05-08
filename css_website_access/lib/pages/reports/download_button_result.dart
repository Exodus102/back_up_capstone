import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DownloadButtonResult extends StatelessWidget {
  final VoidCallback onPressed;
  const DownloadButtonResult({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC0D0E0),
          foregroundColor: const Color(0xFF064089),
          side: const BorderSide(color: Color(0xFF064089), width: 2), // Border
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'svg/icons/download-bottom.svg',
              color: const Color(0xFF064089),
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              "Download",
              style: TextStyle(
                color: Color(0xFF064089),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
