import 'dart:convert';
import 'package:css_website_access/pages/entity-management-css/show_error_dialog_css_update.dart';
import 'package:css_website_access/pages/entity-management-css/show_error_dialog_update_success.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> updateOfficeCss({
  required BuildContext context,
  required String oldOffice,
  required String newOffice,
  required String campus,
}) async {
  final response = await http.post(
    Uri.parse('http://192.168.1.104/database/office/update_office_css.php'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'campus': campus,
      'old_office': oldOffice,
      'new_office': newOffice,
    }),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData['success'] == true) {
      showDialogUpdateSuccess(context);
      return true;
    } else {
      String errorMsg = responseData['message'] ?? 'Update failed';
      showErrorDialogCssUpdate(context, errorMsg);
    }
  } else {
    showErrorDialogCssUpdate(context, 'Server error: ${response.statusCode}');
  }
  return false;
}
