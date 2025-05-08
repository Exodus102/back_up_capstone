import 'package:flutter/material.dart';

class TrendAnalysis extends StatelessWidget {
  final double height;
  const TrendAnalysis({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Trend Analysis",
            style: TextStyle(
              color: Color(0xFF064089),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFCFD8E5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
