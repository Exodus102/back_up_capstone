import 'package:flutter/material.dart';

class ChangeFname extends StatefulWidget {
  final bool? isChange;
  final TextEditingController controller;

  const ChangeFname({
    super.key,
    this.isChange,
    required this.controller,
  });

  @override
  State<ChangeFname> createState() => _ChangeFnameState();
}

class _ChangeFnameState extends State<ChangeFname> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            "First Name",
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
              controller: widget.controller,
              enabled: widget.isChange,
              cursorColor: Color(0xFF064089),
              decoration: InputDecoration(
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
