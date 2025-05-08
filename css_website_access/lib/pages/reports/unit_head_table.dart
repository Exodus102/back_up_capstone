import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:css_website_access/widgets/custom_button_data_table_report.dart';
import 'package:css_website_access/widgets/custom_text_data_table_report.dart';

class NcarPageDataTableDirector extends StatefulWidget {
  final double width;
  final String? selectedYear;
  final Function(String? office, String? filePath) onViewReportPressed;
  final String? campus;
  final String? selectedQuarter;
  final String? office;
  const NcarPageDataTableDirector({
    super.key,
    required this.width,
    this.selectedYear,
    required this.onViewReportPressed,
    this.campus,
    this.selectedQuarter,
    this.office,
  });

  @override
  NcarPageDataTableState createState() => NcarPageDataTableState();
}

class NcarPageDataTableState extends State<NcarPageDataTableDirector> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchOffices();
  }

  @override
  void didUpdateWidget(NcarPageDataTableDirector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedYear != oldWidget.selectedYear ||
        widget.selectedQuarter != oldWidget.selectedQuarter) {
      fetchOffices();
    }
  }

  // Fetch data from the PHP backend
  Future<void> fetchOffices() async {
    final String? campus = widget.campus;
    final String? year = widget.selectedYear;
    final String? quarter = widget.selectedQuarter;
    final String? office = widget.office;
    print("Office on UnitHead: $office");
    String url =
        'http://192.168.1.104/database/files/get_office_ncar_director.php?campus=$campus&year=$year&quarter=$quarter&office=$office';

    // Append office if it's not null or empty
    if (office != null && office.isNotEmpty) {
      url += '&office=$office';
    }

    try {
      final response = await http.get(Uri.parse(url));
      print("Response from PHP script director: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> fetchedData = json.decode(response.body);

        setState(() {
          data = fetchedData.map((officeData) {
            return {
              "Office": officeData['office'],
              "Actions": "View",
              "Appeal": "Appeal",
              "Status": officeData['Status'],
              "File Path": officeData['file_path'],
              "File Name": officeData['file_name'],
              "Verify": officeData['verify'],
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
                      label: SizedBox(
                        width: widget.width * 0.7,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Office',
                          style: TextStyle(color: Color(0xFFF1F7F9)),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: widget.width * 0.08,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Actions',
                          style: TextStyle(color: Color(0xFFF1F7F9)),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: widget.width * 0.08,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Status',
                          style: TextStyle(color: Color(0xFFF1F7F9)),
                        ),
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
                                  row['Office']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  spacing: 10,
                                  children: [
                                    CustomButtonDataTableReport(
                                      onPressed: () {
                                        widget.onViewReportPressed(
                                            row['Office'], row['File Path']);
                                      },
                                      backgroundColor: rowColor,
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: CustomTextDataTableReport(
                                    text: row['Status'],
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
