import 'package:css_website/header/title_survey_logo.dart';
import 'package:css_website/questionaire/questionnaire.dart';

import 'package:flutter/material.dart';

class HomeSurvey extends StatelessWidget {
  const HomeSurvey({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF07326A), Color(0xFF063F87)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleSurveyLogo(),
                  ],
                ),
                SizedBox(height: 20),
                Questionnaire(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "© University of Rizal System - Customer Satisfaction Survey System",
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
