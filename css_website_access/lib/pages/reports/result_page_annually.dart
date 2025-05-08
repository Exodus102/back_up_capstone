import 'package:css_website_access/pages/reports/download_button_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultPageAnnually extends StatefulWidget {
  final String? campus;
  final String? selectedYear;
  final String? selectedDivision;
  final double width;
  const ResultPageAnnually({
    super.key,
    this.campus,
    this.selectedYear,
    this.selectedDivision,
    required this.width,
  });

  @override
  State<ResultPageAnnually> createState() => _ResultPageAnnuallyState();
}

class _ResultPageAnnuallyState extends State<ResultPageAnnually> {
  List<Map<String, String>> data = []; // List to store office data dynamically
  List<String> offices = []; // List to store office names dynamically
  bool isLoading = true;

  // Function to fetch offices from PHP script
  Future<void> fetchOffices() async {
    try {
      setState(() {
        isLoading = true; // Start loading
      });

      final response = await http.get(
        Uri.parse(
          'http://192.168.1.104/database/office/get_office_result_page.php?campus=${widget.campus}&division=${widget.selectedDivision ?? ""}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['offices'] != null) {
          offices = List<String>.from(jsonData['offices']);
          await fetchOfficeData(); // Fetch monthly data
        } else {
          offices = [];
        }
      } else {
        throw Exception('Failed to load offices');
      }
    } catch (e) {
      print("Error fetching offices: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  // Function to fetch monthly data for each office
  // Function to fetch monthly data for each office
  Future<void> fetchOfficeData() async {
    List<Map<String, String>> officeData = [];

    // Define month names for reference
    List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    for (String office in offices) {
      final response = await http.get(
        Uri.parse(
          'http://192.168.1.104/database/results-page-count/get_office_count_by_annually.php?office=$office&year=${widget.selectedYear}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> officeResponse = json.decode(response.body);

        // Initialize the map to hold office data
        Map<String, String> officeMonthData = {'Office': office};

        // Check if the data key exists and contains the expected months
        if (officeResponse['data'] != null) {
          for (int i = 1; i <= 12; i++) {
            String monthName = monthNames[i - 1];
            var monthData = officeResponse['data'][i.toString()];

            // Safely parse month data (default to 0 if not found or is null)
            officeMonthData[monthName] =
                monthData != null ? monthData.toString() : '0';
          }
        } else {
          // If no data is found for the months, set default values
          for (String month in monthNames) {
            officeMonthData[month] = '0';
          }
        }

        officeData.add(officeMonthData);
      } else {
        // Handle failure
      }
    }

    setState(() {
      data = officeData; // Update the dynamic data
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch the offices when the widget is initialized
    fetchOffices();
  }

  @override
  void didUpdateWidget(covariant ResultPageAnnually oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if campus, division, or year changed
    if (oldWidget.campus != widget.campus ||
        oldWidget.selectedDivision != widget.selectedDivision ||
        oldWidget.selectedYear != widget.selectedYear) {
      fetchOffices();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController vertical = ScrollController();
    final ScrollController horizontal = ScrollController();

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF064089),
        ),
      );
    }

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
              headingRowColor: MaterialStateProperty.resolveWith<Color?>((
                states,
              ) =>
                  const Color(0xFF064089)),
              columns: [
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
                    "Jan",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Feb",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Mar",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Apr",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "May",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Jun",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Jul",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Aug",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Sep",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Oct",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Nov",
                    style: TextStyle(color: Color(0xFFF1F7F9)),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Text(
                    "Dec",
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
                    List<String> months = [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec'
                    ];

                    double average = months
                            .map((m) => int.tryParse(row[m] ?? '0') ?? 0)
                            .reduce((a, b) => a + b) /
                        months.length;

                    if (average >= 9) {
                      analysisText = 'Good';
                    } else if (average <= 3) {
                      analysisText = 'Bad';
                    } else {
                      analysisText = 'Neutral';
                    }

                    // Add all month data and other columns dynamically
                    List<DataCell> cells = [
                      DataCell(Text(row['Office'] ?? '')),
                      // Dynamically add month data cells
                      ...months.map((month) {
                        return DataCell(Center(child: Text(row[month] ?? '0')));
                      }).toList(),
                      // Actions cell
                    ];

                    // Ensure that the number of cells matches the number of columns
                    while (cells.length < 13) {
                      cells.add(DataCell(Text('')));
                    }

                    return MapEntry(
                      index,
                      DataRow(
                        color: MaterialStateProperty.all(rowColor),
                        cells: cells,
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
