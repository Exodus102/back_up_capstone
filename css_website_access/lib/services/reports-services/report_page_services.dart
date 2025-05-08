import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportPageService {
  static Future<List<Map<String, String>>> fetchReports(String year) async {
    String url =
        "http://192.168.1.104/database/office/get_quarterly_report.php?year=$year";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((item) {
        return {
          '1st_quarter_report': item['1st_quarter_report']?.toString() ?? "N/A",
          '2nd_quarter_report': item['2nd_quarter_report']?.toString() ?? "N/A",
          '3rd_quarter_report': item['3rd_quarter_report']?.toString() ?? "N/A",
          '4th_quarter_report': item['4th_quarter_report']?.toString() ?? "N/A",
        };
      }).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }
}
