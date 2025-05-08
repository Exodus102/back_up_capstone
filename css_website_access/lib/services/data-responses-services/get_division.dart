import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchDataDivisionService {
  final Function(List<String>) updateDivisions;

  FetchDataDivisionService({required this.updateDivisions});

  Future<void> fetchDivisions() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.104/database/division/get_division.php"),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('divisions')) {
          List<String> divisions = List<String>.from(data['divisions']);
          updateDivisions(divisions);
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
