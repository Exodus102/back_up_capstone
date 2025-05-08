import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiService {
  static Future<void> saveData({
    required String campus,
    required String division,
    required String officeUnit,
    required String customerType,
    required String customerName,
    required String customerContact,
    required String transactionType,
    required String purposeOfVisit,
    required List<int> selectedValues,
    required List<int> selectedValuesPage5,
    required String feedback,
    required BuildContext context,
  }) async {
    final url = Uri.parse(
        'https://plum-hornet-456999.hostingersite.com/questionaire/questionaire.php');
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.9:5000/analyze-sentiment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': feedback}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final sentiment = result['sentiment']['label'];

        final phpresponse = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'campus': campus,
            'division': division,
            'officeUnit': officeUnit,
            'customerType': customerType,
            'name': customerName,
            'contactNumber': customerContact,
            'transactionType': transactionType,
            'purposeOfVisit': purposeOfVisit,
            'selectedValues': selectedValues,
            'selectedValuesPage5': selectedValuesPage5,
            'comments': feedback,
            'sentiment': sentiment,
          }),
        );
        if (phpresponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your response has been submitted')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${result['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
