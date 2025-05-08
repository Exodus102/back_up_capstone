import 'dart:convert';
import 'package:http/http.dart' as http;

class EditAccountService {
  static Future<Map<String, dynamic>> updateAccount({
    required String email,
    required String password,
    required String fname,
    required String lname,
    required String contact,
    required String campus,
    required String unit,
    required String userRole,
    required int status,
  }) async {
    final url = Uri.parse(
        'http://192.168.1.104/database/update-profile/edit_information.php');

    try {
      print("Sending data to: $url");
      print("Email: $email");
      print("Password: $password");
      print("Fname: $fname");
      print("Lname: $lname");
      print("Contact: $contact");
      print("Campus: $campus");
      print("Unit: $unit");
      print("UserRole: $userRole");
      print("Status: $status");

      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
          'fname': fname,
          'lname': lname,
          'contact': contact,
          'campus': campus,
          'unit': unit,
          'userRole': userRole,
          'status': status.toString(),
        },
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'success': false, 'message': 'Failed to connect to server.'};
      }
    } catch (e) {
      print("Error: $e");
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
