import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditButtonDataTableEntity extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback? onPressed;
  const EditButtonDataTableEntity({
    super.key,
    required this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Color(0xFF064089),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF064089)),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'svg/icons/pencil.svg',
            color: Color(0xFF064089),
            width: 15,
            height: 15,
          ),
          SizedBox(width: 8),
          Text("Edit"),
        ],
      ),
    );
  }
}
