import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:css_website_access/pages/reports/download_button_result.dart';
import 'package:flutter/material.dart';

class ResultPageQuarterly extends StatefulWidget {
  final String? campus;
  final String? selectedQuarter;
  final String? selectedYear;
  final String? selectedDivision;
  final double width;

  const ResultPageQuarterly({
    super.key,
    this.campus,
    this.selectedQuarter,
    this.selectedYear,
    this.selectedDivision,
    required this.width,
  });

  @override
  State<ResultPageQuarterly> createState() => _ResultPageQuarterlyState();
}

class _ResultPageQuarterlyState extends State<ResultPageQuarterly> {
  List<Map<String, String>> data = [];
  bool isLoading = true;

  final Map<String, List<String>> quarterMonths = {
    '1st Quarter': ['January', 'February', 'March'],
    '2nd Quarter': ['April', 'May', 'June'],
    '3rd Quarter': ['July', 'August', 'September'],
    '4th Quarter': ['October', 'November', 'December'],
  };

  @override
  void initState() {
    super.initState();
    fetchOfficeResults();
  }

  Future<void> fetchOfficeResults() async {
    final Uri uri = widget.selectedDivision != null
        ? Uri.parse(
            'http://192.168.1.104/database/office/get_office_result_page.php?campus=${widget.campus}&division=${widget.selectedDivision}')
        : Uri.parse(
            'http://192.168.1.104/database/office/get_office_result_page.php?campus=${widget.campus}');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        final List<dynamic> officesList = responseJson['offices'];
        final selectedQuarter = widget.selectedQuarter ?? getCurrentQuarter();
        final months = quarterMonths[selectedQuarter] ?? [];

        List<Map<String, String>> newData = [];

        for (final officeName in officesList) {
          Map<String, String> officeData = {
            'Office': officeName.toString(),
          };

          List<Future<void>> monthFetches = [];
          for (final month in months) {
            monthFetches.add(
                fetchMonthCount(office: officeName.toString(), month: month)
                    .then((count) {
              officeData[month] = count.toString();
            }));
          }

          // Wait for all month counts to be fetched
          await Future.wait(monthFetches);

          // Calculate total and determine Analysis
          List<int> counts = months
              .map((m) => int.tryParse(officeData[m] ?? '0') ?? 0)
              .toList();

          bool allZero = counts.every((count) => count == 0);
          bool allAboveOrEqualTen = counts.every((count) => count >= 10);
          bool hasAtLeastOne = counts.any((count) => count > 0);

          String analysis;
          if (allZero) {
            analysis = 'Bad';
          } else if (allAboveOrEqualTen) {
            analysis = 'Good';
          } else if (hasAtLeastOne) {
            analysis = 'Neutral';
          } else {
            analysis = 'Bad';
          }

          newData.add(officeData);
        }

        setState(() {
          data = newData;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<int> fetchMonthCount({
    required String office,
    required String month,
  }) async {
    // Convert the month name to the corresponding numeric month
    final monthNumber = getMonthNumber(month);

    final Uri countUri = Uri.parse(
      'http://192.168.1.104/database/results-page-count/get_office_count_by_quarter.php'
      '?campus=${widget.campus}'
      '&office=$office'
      '&year=${widget.selectedYear ?? DateTime.now().year}'
      '&month=$monthNumber', // Use numeric month
    );

    try {
      final res = await http.get(countUri);

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);

        // Use the numeric month returned in the API response
        final monthData = jsonData['data'];
        final count = monthData[monthNumber.toString()] ?? 0;
        return count;
      } else {}
    } catch (e) {}
    return 0;
  }

// Custom function to convert month name to numeric month (e.g., "April" -> 4)
  int getMonthNumber(String month) {
    const monthMap = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    return monthMap[month] ?? 0; // Return 0 if month name is invalid
  }

  @override
  void didUpdateWidget(covariant ResultPageQuarterly oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedQuarter != widget.selectedQuarter ||
        oldWidget.selectedDivision != widget.selectedDivision) {
      setState(() {
        isLoading = true;
      });
      fetchOfficeResults();
    }
  }

  String getCurrentQuarter() {
    final month = DateTime.now().month;
    if (month >= 1 && month <= 3) return '1st Quarter';
    if (month >= 4 && month <= 6) return '2nd Quarter';
    if (month >= 7 && month <= 9) return '3rd Quarter';
    return '4th Quarter';
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController vertical = ScrollController();
    final ScrollController horizontal = ScrollController();
    final selectedQuarter = widget.selectedQuarter ?? getCurrentQuarter();
    final months =
        quarterMonths[selectedQuarter] ?? ['Month 1', 'Month 2', 'Month 3'];

    if (isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: Color(0xFF064089),
      ));
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
                color: const Color(0xFF7B8186),
                width: 1,
              ),
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (states) => const Color(0xFF064089),
              ),
              columns: [
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.56,
                    child: const Text(
                      'Office',
                      style: TextStyle(color: Color(0xFFF1F7F9)),
                    ),
                  ),
                ),
                ...months.map((month) {
                  return DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text(
                      month,
                      style: const TextStyle(color: Color(0xFFF1F7F9)),
                    ),
                  );
                }).toList(),
              ],
              rows: data
                  .asMap()
                  .map((index, row) {
                    final rowColor = index.isEven
                        ? const Color(0xFFF1F7F9)
                        : const Color(0xFFD8E5EF);
                    final analysisText = row['Analysis'] ?? 'Neutral';

                    return MapEntry(
                      index,
                      DataRow(
                        color: MaterialStateProperty.all(rowColor),
                        cells: [
                          DataCell(Text(row['Office'] ?? '')),
                          ...months.map((month) {
                            final count = int.tryParse(row[month] ?? '0') ?? 0;

                            return DataCell(
                              Center(
                                child: Text(
                                  '$count',
                                ),
                              ),
                            );
                          }),
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
