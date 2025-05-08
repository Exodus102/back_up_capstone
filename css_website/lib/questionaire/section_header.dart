import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String sectionName;

  const SectionHeader({super.key, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    switch (sectionName) {
      case "Section 1":
        return const SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Which area is your feedback related to?',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Please select the area your feedback relates to:',
                  style: TextStyle(
                    height: 1,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 30),
              ],
            ));
      case "Section 2":
        return const SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take a second to introduce yourself!',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Please note that some fields are optional.',
                  style: TextStyle(
                    height: 1,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 30),
              ],
            ));
      default:
        return const SizedBox.shrink();
    }
  }
}
