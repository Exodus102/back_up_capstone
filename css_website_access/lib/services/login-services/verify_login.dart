import 'dart:convert';
import 'package:http/http.dart' as http;

class VerifyLogin {
  Future<bool> verifyCredentials(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.104/database/login/check_credentials.php'),
      body: {
        'email': email,
        'password': password,
      },
    );
    print("this is the response to the email and password" + response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'];
    }
    return false;
  }
}
