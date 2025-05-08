import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPasswordServices {
  static const url = "http://192.168.1.104/database/login/login_password.php";

  Future<Map<String, dynamic>?> fetchUserData(String email) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'found') {
          return {
            'fname': data['fname'],
            'image': data['image'],
          };
        } else {
          return null;
        }
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      return null;
    }
  }
}
