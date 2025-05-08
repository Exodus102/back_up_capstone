import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final bool isChecked;
  const CustomCheckbox({
    super.key,
    required this.onChanged,
    this.isChecked = false,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.isChecked;
  }

  void toggleCheckbox(bool? value) {
    setState(() {
      checked = value ?? false;
    });
    widget.onChanged(checked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            side: BorderSide(color: Color(0xFF474849), width: 1),
            checkColor: Color(0xFF474849),
            fillColor: WidgetStateProperty.all(Color(0xFFF1F7F9)),
            value: checked,
            onChanged: toggleCheckbox,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "Show Password",
          style: TextStyle(
            color: Color(0xFF474849),
          ),
        )
      ],
    );
  }
}
