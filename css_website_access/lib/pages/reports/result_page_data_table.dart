import 'dart:convert';
import 'package:css_website_access/pages/reports/download_button_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ResultPageDataTable extends StatefulWidget {
  final String? campus;
  final String? selectedMonth;
  final String? selectedYear;
  final String? selectedDivision;
    final double width;

  const ResultPageDataTable({
    super.key,
    this.campus,
    this.selectedMonth,
    this.selectedYear,
    this.selectedDivision, required this.width,
  });

  @override
  State<ResultPageDataTable> createState() => _ResultPageDataTableState();
}

class _ResultPageDataTableState extends State<ResultPageDataTable> {
  List<Map<String, String>> data = [];
  Map<String, List<String>> officeMonthsMap = {};

  @override
  void initState() {
    super.initState();
    fetchOffices(widget.campus);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchOffices(String? campus) async {
    setState(() {
      officeMonthsMap.clear();
      data.clear();
    });

    final Uri uri = widget.selectedDivision != null
        ? Uri.parse(
            'http://192.168.1.104/database/office/get_office_result_page.php?campus=${widget.campus}&division=${widget.selectedDivision}')
        : Uri.parse(
            'http://192.168.1.104/database/office/get_office_result_page.php?campus=${widget.campus}');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<String> officeList =
          List<String>.from(responseData['offices']);

      // Fetch all months concurrently for each office
      List<Future> fetchMonthRequests = officeList.map((office) {
        return fetchMonths(campus ?? '', office);
      }).toList();

      // Wait for all month fetch requests to complete
      await Future.wait(fetchMonthRequests);

      setState(() {
        data = officeMonthsMap.entries.map((entry) {
          return {
            "Office": entry.key,
            "Month": entry.value.isNotEmpty ? entry.value.first : "None",
            "Analysis": "",
            "Actions": "",
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load offices');
    }
  }

  Future<void> fetchMonths(String campus, String office) async {
    final response = await http.get(Uri.parse(
      'http://192.168.1.104/database/results-page-count/get_office_count_by_month.php?campus=$campus&office=$office&year=${widget.selectedYear}&month=${widget.selectedMonth}',
    ));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final String count = responseData['count'].toString();

      if (count != "0") {
        officeMonthsMap[office] = [count];
      } else {
        officeMonthsMap[office] = ["0"];
      }
    } else {
      officeMonthsMap[office] = ["0"];
    }
  }

  @override
  void didUpdateWidget(ResultPageDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMonth != oldWidget.selectedMonth ||
        widget.selectedYear != oldWidget.selectedYear ||
        widget.selectedDivision != oldWidget.selectedDivision) {
      fetchOffices(widget.campus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController vertical = ScrollController();
    final ScrollController horizontal = ScrollController();

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
            child: DataTable(
              border: TableBorder.all(
                color: Color(0xFF7B8186),
                width: 1,
                style: BorderStyle.solid,
              ),
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (states) => const Color(0xFF064089),
              ),
              columns: [
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.56,
                    child: Text(
                      'Office',
                      style: TextStyle(color: Color(0xFFF1F7F9)),
                    ),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    widget.selectedMonth ?? DateTime.now().month.toString(),
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    'Analysis',
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
              ],
              rows: data
                  .asMap()
                  .map((index, row) {
                    Color rowColor =
                        index.isEven ? Color(0xFFF1F7F9) : Color(0xFFD8E5EF);

                    // Logic for determining the Analysis text
                    String analysisText = 'Neutral'; // Default to Neutral
                    int monthValue = int.tryParse(row['Month'] ?? '0') ?? 0;

                    if (monthValue >= 10) {
                      analysisText = 'Good';
                    } else if (monthValue == 0) {
                      analysisText = 'Bad';
                    }

                    return MapEntry(
                      index,
                      DataRow(
                        color: MaterialStateProperty.all(rowColor),
                        cells: [
                          DataCell(Text(row['Office'] ?? '')),
                          DataCell(
                            Center(
                              child: Text(
                                row['Month'] ?? '',
                                style: TextStyle(
                                  color: monthValue >= 10
                                      ? Color(0xFF29AB87)
                                      : monthValue == 0
                                          ? Color(0xFFEE6B6E)
                                          : Color(0xFFFF9D5C),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              width: 85,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: analysisText == 'Good'
                                    ? Color(0xFF29AB87)
                                    : analysisText == 'Bad'
                                        ? Color(0xFFEE6B6E)
                                        : Color(0xFFFF9D5C), // Neutral
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Text(
                                analysisText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ), // Show analysis text
                        ],
                      ),
                    );
                  })
                  .values
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
