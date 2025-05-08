import 'package:flutter/material.dart';

class DropdownAddAccount extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final double? width;

  const DropdownAddAccount({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: width,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF064089),
              width: 2,
            ),
          ),
        ),
        value: selectedValue,
        hint: Text(
          hintText, // Display hint when no value is selected
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF878A8B),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF464647),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        icon: const Icon(
          Icons.keyboard_arrow_down_sharp,
          size: 20,
        ),
        dropdownColor: Colors.white,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
