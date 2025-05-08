import 'dart:convert';
import 'package:css_website_access/pages/edit-survey/show_dialog_success.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<void> updateSurveyStatus(
    BuildContext context, String surveyTitle) async {
  final url =
      'http://192.168.1.104/database/questionaire/update_survey_form.php';

  print("surveyTitle: $surveyTitle");

  final response = await http.post(
    Uri.parse(url),
    body: {
      'survey_title': surveyTitle,
    },
  );

  print("Response: ${response.body}");

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      showDialogSuccessEditSurvey(
          context, "The survey has been used successfully.");
    } else {
      print('Failed to update survey status: ${data['message']}');
    }
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}
