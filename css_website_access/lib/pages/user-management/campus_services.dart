import 'dart:convert';
import 'package:http/http.dart' as http;

class CampusServices {
  static Future<List<Map<String, String>>> fetchCampuses() async {
    final url = Uri.parse(
        "http://192.168.1.104/database/filter-account/fetch_campus.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return [
              {"id": "all", "name": "Show All"}
            ] +
            data
                .map((campus) => {
                      "id": campus["id"].toString(),
                      "name": campus["name"].toString()
                    })
                .toList();
      } else {
        throw Exception("Failed to fetch campuses");
      }
    } catch (e) {
      print("Error fetching campuses: $e");
      return [];
    }
  }
}
