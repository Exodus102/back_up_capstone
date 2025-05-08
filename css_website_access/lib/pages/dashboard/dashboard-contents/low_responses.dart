import 'dart:async';
import 'dart:convert';
import 'package:css_website_access/pages/dashboard/dashboard-contents/barchart.dart';
import 'package:css_website_access/pages/dashboard/dashboard-contents/monthly_responses_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LowResponses extends StatefulWidget {
  final String? campus;
  final double width;
  const LowResponses({
    super.key,
    required this.width,
    this.campus,
  });

  @override
  State<LowResponses> createState() => _LowResponsesState();
}

class _LowResponsesState extends State<LowResponses> {
  final ScrollController _horizontalController = ScrollController();
  List<Map<String, dynamic>> offices = [];
  Timer? _timer;
  String? selectedDivision;
  String? selectedYear;
  String? selectedMonth;

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    fetchOffices();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchOffices();
    });
    print("Selected Division: $selectedDivision");
  }

  Future<void> fetchOffices() async {
    String campus = widget.campus ?? "Binangonan";
    String url =
        'http://192.168.1.104/database/office/get_office_dashboard.php?campus=$campus';

    if (selectedDivision != null) {
      url += '&division=$selectedDivision';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<Map<String, dynamic>> updatedOffices = [];
      for (var office in data) {
        String officeName = office['office'];

        // Base URL for each office count request
        String officeResponseUrl =
            'http://192.168.1.104/database/office/get_count_office.php?campus=$campus&office=$officeName';

        if (selectedYear != null) {
          officeResponseUrl += '&year=$selectedYear';
        }

        if (selectedMonth != null) {
          officeResponseUrl += '&month=$selectedMonth';
        }

        final officeResponse = await http.get(Uri.parse(officeResponseUrl));

        if (officeResponse.statusCode == 200) {
          final Map<String, dynamic> officeData =
              json.decode(officeResponse.body);

          updatedOffices.add({
            'office': officeName,
            'response_count': officeData['response_id_count'] ?? 0,
          });
        } else {
          throw Exception('Failed to load response count for office');
        }
      }

      setState(() {
        offices = updatedOffices;
      });
    } else {
      throw Exception('Failed to load offices');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barData = offices.isNotEmpty
        ? offices.map((office) {
            return BarChartGroupData(
              x: offices.indexOf(office),
              barRods: [
                BarChartRodData(
                  toY: (office['response_count'] ?? 0).toDouble(),
                  color: Color(0xFF064089),
                  borderRadius: BorderRadius.zero,
                  width: 20,
                ),
              ],
            );
          }).toList()
        : [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(toY: 0, color: Colors.grey),
              ],
            )
          ];

    double barWidth = 300;
    double chartWidth = barData.length * barWidth.toDouble();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: SizedBox(
              width: double.infinity,
              child: MonthlyResponsesRow(
                onOfficeChange: (office) {
                  setState(() {
                    selectedDivision = office;
                  });
                  fetchOffices();
                },
                onYearChanged: (year) {
                  setState(() {
                    selectedYear = year;
                  });
                  fetchOffices();
                },
                onMonthChanged: (month) {
                  setState(() {
                    selectedMonth = month;
                  });
                  fetchOffices();
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFCFD8E5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 300,
                    width: chartWidth,
                    child: Barchart(
                      barData: barData,
                      offices: offices
                          .map((office) => office['office'] as String)
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
