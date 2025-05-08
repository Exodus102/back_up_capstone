import 'dart:typed_data';
import 'package:css_website_access/pages/edit-survey/questionaire_table.dart';
import 'package:css_website_access/pages/edit-survey/questionaire_title.dart';
import 'package:css_website_access/pages/edit-survey/services_for_survey.dart';
import 'package:css_website_access/pages/edit-survey/survey_mis.dart';
import 'package:css_website_access/widgets/custom_button.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateFormSurvey extends StatefulWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  final VoidCallback onView;
  const CreateFormSurvey({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
    required this.onView,
  });

  @override
  State<CreateFormSurvey> createState() => _CreateFormSurveyState();
}

class _CreateFormSurveyState extends State<CreateFormSurvey> {
  Future<void> createSurvey() async {
    await ServicesForSurvey.createSurvey(context);
    saveLogs();
  }

  bool isShownSurveyMis = false;
  String? selectedSurveyTitle;

  void toggleSurveyMis() {
    setState(() {
      isShownSurveyMis = !isShownSurveyMis;
    });
  }

  Future<void> saveLogs() async {
    final String fullName =
        '${widget.fname ?? ''} ${widget.lname ?? ''}'.trim();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.104/database/logs/audit_logs.php'),
        body: {
          'name': fullName,
          'message': 'Added an survey form.',
        },
      );

      if (response.statusCode == 200) {
        print('Log saved successfully: ${response.body}');
      } else {
        print('Failed to save log: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while saving log: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double headerHeight = 100;
        double paddingHeight = 40;
        double rowHeight = 50;
        double spacingHeight = 10;
        double availableHeight = constraints.maxHeight -
            (headerHeight + paddingHeight + rowHeight + spacingHeight);
        return Column(
          children: [
            CustomHeader(
              label: "Edit Survey",
              fname: widget.fname,
              lname: widget.lname,
              profileImage: widget.profileImage,
              redirectPage: widget.redirectPage,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (!isShownSurveyMis) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuestionaireTitle(),
                        CustomButton(
                          label: "Create New Questionnaire",
                          svgPath: "svg/icons/+.svg",
                          onPressed: createSurvey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    QuestionaireTable(
                      width: constraints.maxWidth - 40,
                      height: availableHeight,
                      onEdit: (String surveyTitle) {
                        setState(() {
                          isShownSurveyMis = true;
                          selectedSurveyTitle = surveyTitle;
                        });
                      },
                      onView: widget.onView,
                    ),
                  ] else ...[
                    SurveyMis(
                      fname: widget.fname,
                      lname: widget.lname,
                      height: availableHeight + 40,
                      questionnaireTitle: selectedSurveyTitle,
                      onBack: toggleSurveyMis,
                    ),
                  ]
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
