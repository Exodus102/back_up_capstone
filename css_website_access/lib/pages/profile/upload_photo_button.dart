import 'package:flutter/material.dart';

class UploadPhotoButton extends StatelessWidget {
  final VoidCallback onPressed;
  const UploadPhotoButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Color(0xFF064089), width: 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: Text(
        "Upload Photo",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF064089),
        ),
      ),
    );
  }
}
