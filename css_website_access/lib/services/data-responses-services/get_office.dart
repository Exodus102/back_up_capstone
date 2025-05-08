import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchDataOfficeService {
  final Function(List<String>) updateOffices;

  FetchDataOfficeService({required this.updateOffices});

  Future<void> fetchOffices() async {
    const String url = "http://192.168.1.104/database/office/get_office.php";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        List<String> offices = List<String>.from(jsonData["offices"] ?? []);
        updateOffices(offices);
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
