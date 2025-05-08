import 'package:flutter/material.dart';

class RequiredButton extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final int initialRequired;
  final String title;

  const RequiredButton({
    super.key,
    required this.onChanged,
    required this.initialRequired,
    required this.title,
  });

  @override
  RequiredButtonState createState() => RequiredButtonState();
}

class RequiredButtonState extends State<RequiredButton> {
  late int isRequired;

  @override
  void initState() {
    super.initState();
    isRequired = widget.initialRequired;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: Color(0xFF48494A),
            ),
          ),
          backgroundColor: const Color(0xFFF1F7F9),
        ),
        onPressed: () {
          setState(() {
            isRequired = isRequired == 0 ? 1 : 0;
            widget.onChanged(isRequired);
          });
        },
        child: Row(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Color(0xFF48494A),
              ),
            ),
            const SizedBox(width: 3),
            Transform.scale(
              scale: 0.7,
              child: Switch(
                value: isRequired == 1,
                onChanged: (value) {
                  setState(() {
                    isRequired = value ? 1 : 0;
                    widget.onChanged(isRequired);
                  });
                },
                activeColor: Color(0xFF064089),
                inactiveThumbColor: Color(0xFFF1F7F9),
                inactiveTrackColor: Color(0xFFC5C9CA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
