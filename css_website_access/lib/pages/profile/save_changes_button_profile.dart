import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SaveChangesButtonProfile extends StatelessWidget {
  final VoidCallback onPressed;
  const SaveChangesButtonProfile({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        backgroundColor: Color(0xFF07326A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        spacing: 10,
        children: [
          SvgPicture.asset(
            "svg/icons/floppy-disk.svg",
            color: Colors.white,
            width: 16,
            height: 16,
          ),
          Text(
            "Save Changes",
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
