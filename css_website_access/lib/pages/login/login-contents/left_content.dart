import 'package:flutter/material.dart';

class LeftContent extends StatelessWidget {
  final double width;
  final double height;
  const LeftContent({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "images/login_pic.jpg",
          width: width,
          height: height,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/logo2.png"),
              SizedBox(
                height: 30,
              ),
              Text(
                "UNIVERSITY OF RIZAL SYSTEM",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFFF1F7F9),
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 2.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Customer\nSatisfaction\nSurvey System",
                style: TextStyle(
                  height: 1,
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF1F7F9),
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 2.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "“Nurturing Tomorrow’s Noblest”",
                style: TextStyle(
                  height: 1,
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                  color: Color(0xFFF1F7F9),
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 2.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                "Copyright © 2024 University of Rizal System. All rights reserved.",
                style: TextStyle(
                  height: 1,
                  fontSize: 15,
                  color: Color(0xFFF1F7F9),
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 2.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
