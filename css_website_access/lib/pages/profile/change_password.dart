import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  final bool? isChange;
  final bool? isShown;
  final TextEditingController controller;
  const ChangePassword({
    super.key,
    this.isChange,
    this.isShown,
    required this.controller,
  });

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            "Password",
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
              obscureText: widget.isShown ?? true,
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
