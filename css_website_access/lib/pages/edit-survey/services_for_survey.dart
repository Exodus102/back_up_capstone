import 'package:css_website_access/pages/edit-survey/show_dialog_success.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServicesForSurvey {
  static const String _baseUrl = 'http://192.168.1.104/database/questionaire';

  static Future<void> createSurvey(BuildContext context) async {
    final url = Uri.parse('$_baseUrl/add_survey_and_add_static_question.php');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      showDialogSuccessEditSurvey(context, "Survey created successfully.");
    } else {
      print('Failed to create survey: ${response.statusCode}');
    }
  }
}
