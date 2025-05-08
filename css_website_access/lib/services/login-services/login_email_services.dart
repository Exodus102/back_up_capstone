import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> checkEmailRegistered(String email) async {
  final response = await http.get(
    Uri.parse(
        'http://192.168.1.104/database/login/login_email.php?email=$email'),
  );

  print("response : ${response.body}");

  final responseData = json.decode(response.body);
  if (response.statusCode == 200) {
    if (responseData['status'] == 'found') {
      return true;
    } else {
      return false;
    }
  } else {
    throw Exception('Failed to check email');
  }
}
