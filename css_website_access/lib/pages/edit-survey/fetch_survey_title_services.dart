import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchSurveyTitleServices {
  static Stream<List<Map<String, dynamic>>> getSurveys() async* {
    while (true) {
      final response = await http.get(Uri.parse(
          'http://192.168.1.104/database/questionaire/fetch_surveys.php'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        List<Map<String, dynamic>> surveys = data.map((survey) {
          return {
            'survey_title': survey['survey_title'],
            'status': survey['status'],
          };
        }).toList();

        yield surveys;
      } else {
        yield [];
      }

      await Future.delayed(Duration(seconds: 2));
    }
  }
}
