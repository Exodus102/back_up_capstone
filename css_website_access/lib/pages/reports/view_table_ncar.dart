import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:css_website_access/widgets/custom_button_data_table_report.dart';
import 'package:css_website_access/widgets/custom_text_data_table_report.dart';

class ViewTableNcar extends StatefulWidget {
  final String? campus;
  final String? selectedYear;
  final double width;
  final String? selectedQuarter;
  const ViewTableNcar({
    super.key,
    required this.width,
    this.campus,
    this.selectedYear,
    this.selectedQuarter,
  });

  @override
  NcarPageDataTableState createState() => NcarPageDataTableState();
}

class NcarPageDataTableState extends State<ViewTableNcar> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchOffices();
  }

  Future<void> fetchOffices() async {
    final String? campus = widget.campus;
    final String? year = widget.selectedYear;
    print("Year Selected: ${widget.selectedYear}");

    final String? quarter = widget.selectedQuarter;
    final String url =
        'http://192.168.1.104/database/files/get_office_ncar_director.php?campus=$campus&year=$year&quarter=$quarter';

    try {
      final response = await http.get(Uri.parse(url));

      print("Response from PHP script director View Table: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> fetchedData = json.decode(response.body);

        setState(() {
          data = fetchedData.map((officeData) {
            return {
              "Office": officeData['office'],
              "ID": officeData['id'],
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load offices');
      }
    } catch (e) {
      print('Error fetching offices: $e');
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF7B8186), width: 1),
                ),
                child: DataTable(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Color(0xFF7B8186),
                      width: 1,
                    ),
                    verticalInside: BorderSide(
                      color: Color(0xFF7B8186),
                      width: 1,
                    ),
                  ),
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (states) => const Color(0xFF064089),
                  ),
                  columns: [
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'NCAR No.',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Office',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Date Issued',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Non-conformity or Failure Mode',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Root Cause Analysis',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Corrected or Recommendation Action',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Target Date',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Date Verified Implemented',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Date Verified Effective',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Status',
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                  ],
                  rows: data
                      .asMap()
                      .map((index, row) {
                        Color rowColor = index.isEven
                            ? Color(0xFFF1F7F9)
                            : Color(0xFFCFD8E5);

                        return MapEntry(
                          index,
                          DataRow(
                            color: MaterialStateProperty.all(rowColor),
                            cells: [
                              DataCell(
                                Text(
                                  row["Id"],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  row['Office']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "25/11/2024",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "Non-conformity or Failure Mode",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "Root Cause Analysis",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "Recommendation Actions",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "25/11/2025",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "25/11/2025",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "25/11/2025",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "Unresolved",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}
