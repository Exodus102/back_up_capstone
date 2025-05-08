import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:css_website_access/widgets/custom_button_data_table_report.dart';
import 'package:css_website_access/widgets/custom_text_data_table_report.dart';

class ReportPageDataTable extends StatefulWidget {
  final String? campus;
  final double width;
  final String? selectedYear;
  final Function(String? quarter) onViewReportPressed;

  const ReportPageDataTable({
    super.key,
    required this.width,
    this.selectedYear,
    required this.onViewReportPressed,
    this.campus,
  });

  @override
  ReportPageDataTableState createState() => ReportPageDataTableState();
}

class ReportPageDataTableState extends State<ReportPageDataTable> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant ReportPageDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedYear != widget.selectedYear) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    String selectedYear = widget.selectedYear ?? DateTime.now().year.toString();

    if (selectedYear.isEmpty || selectedYear == "No Data") {
      setState(() {
        isLoading = false;
        errorMessage = "Invalid year selected.";
      });

      return;
    }

    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.104/database/date/get_report.php?year=$selectedYear&campus=${widget.campus}'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          if (jsonData.isNotEmpty) {
            data = jsonData.map((item) {
              return {
                'quarter': item['quarter_report'],
                'status': item['status'],
              };
            }).toList();
          } else {
            errorMessage = "No reports found for year: $selectedYear";
          }
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to fetch data: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching data: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController vertical = ScrollController();
    final ScrollController horizontal = ScrollController();

    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Color(0xFF064089),
          ))
        : errorMessage.isNotEmpty
            ? Center(
                child: Text(errorMessage, style: TextStyle(color: Colors.red)))
            : Scrollbar(
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
                            border: Border.all(
                                color: const Color(0xFF7B8186), width: 1),
                          ),
                          child: DataTable(
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                  color: Color(0xFF7B8186), width: 1),
                              verticalInside: BorderSide(
                                  color: Color(0xFF7B8186), width: 1),
                            ),
                            headingRowColor:
                                WidgetStateProperty.resolveWith<Color?>(
                                    (states) => const Color(0xFF064089)),
                            columns: [
                              DataColumn(
                                label: SizedBox(
                                  width: widget.width * 0.7,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Quarterly Reports',
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
                                .map(
                                  (index, row) {
                                    Color rowColor = index.isEven
                                        ? Color(0xFFF1F7F9)
                                        : Color(0xFFCFD8E5);

                                    return MapEntry(
                                      index,
                                      DataRow(
                                        color:
                                            WidgetStateProperty.all(rowColor),
                                        cells: [
                                          DataCell(
                                            Text(
                                              row['quarter'] ?? 'No Quarter',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          DataCell(Center(
                                              child:
                                                  CustomButtonDataTableReport(
                                                      onPressed: () {
                                                        widget
                                                            .onViewReportPressed(
                                                                row['quarter']);
                                                      },
                                                      backgroundColor:
                                                          rowColor))),
                                          DataCell(Center(
                                              child: CustomTextDataTableReport(
                                                  text: row['status'] ??
                                                      'No Status')))
                                        ],
                                      ),
                                    );
                                  },
                                )
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
