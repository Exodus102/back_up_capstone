import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg package

class CustomListTile extends StatelessWidget {
  final VoidCallback onTapCallback;
  final String text;
  final String svgPath;
  final Color color;
  final TextStyle textStyle;
  const CustomListTile({
    super.key,
    required this.onTapCallback,
    required this.text,
    required this.svgPath,
    this.color = const Color(0xFF064089),
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListTile(
        leading: SvgPicture.asset(
          svgPath, // Use the dynamic SVG path
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
        ),
        title: Text(
          text,
          style: textStyle,
        ),
        onTap: onTapCallback,
      ),
    );
  }
}
