import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataTableWidget extends StatefulWidget {
  final String? selectedDivision;
  final String? selectedCollege;
  final String? campus;

  const DataTableWidget({
    super.key,
    this.selectedDivision,
    this.selectedCollege,
    this.campus,
  });

  @override
  DataTableWidgetState createState() => DataTableWidgetState();
}

class DataTableWidgetState extends State<DataTableWidget> {
  List<Map<String, dynamic>> data = [];
  int maxResponses = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String url = "http://192.168.1.104/database/response/get_responses.php";

    // Add campus filter if a campus is provided
    if (widget.campus != null && widget.campus!.isNotEmpty) {
      url += "?campus_name=${widget.campus}";
    }

    print("Campus on Data Responses: ${widget.campus}");

    final response = await http.get(Uri.parse(url));
    print("Response body on data responses: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      final parsed =
          jsonData.map((item) => item as Map<String, dynamic>).toList();

      int max = 0;
      for (var item in parsed) {
        final responses = (item['responses'] as String)
            .split(',')
            .map((r) => r.trim())
            .toList();
        if (responses.length > max) max = responses.length;
        item['responseList'] = responses; // Save parsed list to reuse later
      }

      setState(() {
        data = parsed;
        maxResponses = max;
      });
    }
  }

  Color getAnalysisColor(String value) {
    switch (value.toLowerCase()) {
      case "positive":
        return const Color(0xFF29AB87);
      case "negative":
        return const Color(0xFFEE6B6E);
      case "neutral":
        return const Color(0xFFFF9D5C);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController vertical = ScrollController();
    final ScrollController horizontal = ScrollController();

    return Scrollbar(
      controller: horizontal,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: horizontal,
        child: Scrollbar(
          controller: vertical,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: vertical,
            child: DataTable(
              border: TableBorder.all(color: const Color(0xFF7B8186), width: 1),
              headingRowColor: WidgetStateProperty.all(const Color(0xFF064089)),
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    List<DataColumn> columns = [
      const DataColumn(
          label: Text("ID", style: TextStyle(color: Colors.white))),
    ];

    for (int i = 0; i < maxResponses; i++) {
      columns.add(
        DataColumn(
            label: Text("Response ${i + 1}",
                style: TextStyle(color: Colors.white))),
      );
    }

    columns.addAll([
      const DataColumn(
          label: Text("Comment", style: TextStyle(color: Colors.white))),
      const DataColumn(
          label: Text("Analysis", style: TextStyle(color: Colors.white))),
    ]);

    return columns;
  }

  List<DataRow> _buildRows() {
    return List<DataRow>.generate(data.length, (index) {
      final row = data[index];
      final responses = List<String>.from(row['responseList']);

      while (responses.length < maxResponses) {
        responses.add('');
      }

      final Color rowColor = index % 2 == 0
          ? const Color(0xFFF1F7F9) // Light Blue
          : const Color(0xFFCFD8E5); // Darker Blue

      return DataRow(
        color: WidgetStateProperty.all(rowColor),
        cells: [
          DataCell(Text(row['response_id'].toString())),
          ...responses.map((r) => DataCell(Text(r))),
          DataCell(Text(row['comment'] ?? '')),
          DataCell(
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: getAnalysisColor(row['analysis'] ?? ''),
                  borderRadius: BorderRadius.circular(60),
                ),
                padding: const EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    row['analysis'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
