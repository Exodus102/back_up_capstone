import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ProfileService {
  static const String _uploadUrl =
      "http://192.168.1.104/database/update-profile/update_dp.php";

  static Future<bool> uploadProfileImage(String email, Uint8List image) async {
    try {
      String base64Image = base64Encode(image);

      var response = await http.post(
        Uri.parse(_uploadUrl),
        body: {
          "email": email,
          "image": base64Image,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
