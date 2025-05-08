import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuditLogsDataTable extends StatefulWidget {
  const AuditLogsDataTable({super.key});

  @override
  State<AuditLogsDataTable> createState() => _AuditLogsDataTableState();
}

class _AuditLogsDataTableState extends State<AuditLogsDataTable> {
  late Future<List<Map<String, dynamic>>> futureLogs;

  @override
  void initState() {
    super.initState();
    futureLogs = fetchLogs();
  }

  Future<List<Map<String, dynamic>>> fetchLogs() async {
    final response = await http.get(Uri.parse(
        "http://192.168.1.104/database/logs/get_audit_logs.php")); // Use your actual URL

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        List<dynamic> logs = jsonResponse['data'];
        return List<Map<String, dynamic>>.from(logs);
      } else {
        throw Exception("Failed: ${jsonResponse['message']}");
      }
    } else {
      throw Exception("HTTP error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController vertical = ScrollController();
    final ScrollController horizontal = ScrollController();

    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      double tableWidth = constraints.maxWidth;
      double columnWidth = tableWidth / 5;

      return FutureBuilder<List<Map<String, dynamic>>>(
        future: futureLogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data ?? [];

          return Scrollbar(
            trackVisibility: true,
            thumbVisibility: true,
            interactive: true,
            thickness: 8.0,
            controller: horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: horizontal,
              child: Scrollbar(
                trackVisibility: true,
                thumbVisibility: true,
                interactive: true,
                thickness: 8.0,
                controller: vertical,
                child: SingleChildScrollView(
                  controller: vertical,
                  child: SizedBox(
                    width: tableWidth,
                    child: DataTable(
                      border: TableBorder.all(
                        color: const Color(0xFF7B8186),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      headingRowColor:
                          WidgetStateProperty.all(const Color(0xFF064089)),
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: columnWidth,
                            child: const Text(
                              'Time',
                              style: TextStyle(color: Color(0xFFF1F7F9)),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: columnWidth,
                            child: const Text(
                              'User Account',
                              style: TextStyle(color: Color(0xFFF1F7F9)),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: columnWidth,
                            child: const Text(
                              'Action',
                              style: TextStyle(color: Color(0xFFF1F7F9)),
                            ),
                          ),
                        ),
                      ],
                      rows: data.asMap().entries.map((entry) {
                        int index = entry.key;
                        var row = entry.value;
                        Color rowColor = index.isEven
                            ? const Color(0xFFCED7E4)
                            : const Color(0xFFEFF4F6);

                        return DataRow(
                          color: WidgetStateProperty.all(rowColor),
                          cells: [
                            DataCell(Text(row['timestamp'] ?? '')),
                            DataCell(Text(row['name'] ?? '')),
                            DataCell(Text(row['message'] ?? '')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
