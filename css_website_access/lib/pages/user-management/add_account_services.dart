import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAccountServices {
  static Future<bool> addAccount({
    required String email,
    required String password,
    required String fname,
    required String lname,
    required String contactNo,
    required String? selectedUserRole,
    required String? selectedCampus,
    required String? selectedUnit,
    required String? selectedDp,
  }) async {
    final url =
        Uri.parse('http://192.168.1.104/database/add-account/add_account.php');

    Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'fname': fname,
      'lname': lname,
      'contact_no': contactNo,
      'user_roles': selectedUserRole ?? '',
      'campus': selectedCampus ?? '',
      'unit': selectedUnit ?? '',
      'dp': selectedDp ?? '',
    };

    print("Sending Data: ${jsonEncode(data)}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          print("Account added successfully");
          return true; // Indicate success
        } else {
          print("Failed to add account: ${jsonResponse['message']}");
          return false; // Indicate failure
        }
      } else {
        print("Server Error: ${response.statusCode}");
        return false; // Indicate failure due to server error
      }
    } catch (e) {
      print("Request failed: $e");
      return false; // Indicate failure due to network or other errors
    }
  }
}
