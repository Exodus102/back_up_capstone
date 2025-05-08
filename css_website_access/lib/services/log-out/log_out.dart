import 'package:css_website_access/pages/login/login-contents/splash_screen_logout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class LogoutService {
  static Future<void> logout(BuildContext context) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.104/database/login/log_out.php'),
    );
    print("Log Out Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreenLogout()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}
