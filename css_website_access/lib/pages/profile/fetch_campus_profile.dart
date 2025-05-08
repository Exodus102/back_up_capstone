import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FetchCampusProfile extends StatelessWidget {
  final String campus;
  const FetchCampusProfile({
    super.key,
    required this.campus,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: campus);
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            "Campus",
            style: TextStyle(
              color: Color(0xFF474849),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 30,
            child: TextField(
              controller: controller,
              enabled: false,
              cursorColor: Color(0xFF064089),
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SvgPicture.asset(
                    "svg/icons/lock.svg",
                    width: 16,
                    height: 16,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: Color(0xFF474849),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: Color(0xFF064089),
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: Color(0xFF474849),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
              ),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              cursorHeight: 16,
            ),
          ),
        ),
      ],
    );
  }
}
