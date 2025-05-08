import 'dart:convert';
import 'dart:typed_data';
import 'package:css_website_access/pages/reports/result_page_annually.dart';
import 'package:css_website_access/pages/reports/result_page_data_table.dart';
import 'package:css_website_access/pages/reports/result_page_quarterly.dart';
import 'package:css_website_access/widgets/custom_dropdown.dart';
import 'package:css_website_access/widgets/custom_elevated_button_reports.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultsPage extends StatefulWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  final String? campus;
  const ResultsPage({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
    this.campus,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String? selectedValue;
  String? selectedMonth;
  String? selectedYear;
  String? selectedQuarter;
  String? selectedDivision;
  int activeIndex = 0;
  bool isLoading = true;

  String text = "Results";
  List<String> date = [];
  List<String> divisionItems = [];
  final List<String> quarter = [
    "1st Quarter",
    "2nd Quarter",
    "3rd Quarter",
    "4th Quarter",
  ];
  final List<String> month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    fetchYears();
    fetchDivisions();
    setDefaultMonth();
    setDefaultYear();
    setDefaultQuarter();
  }

  void setDefaultQuarter() {
    final now = DateTime.now();
    final currentMonth = now.month;

    int quarterIndex = (currentMonth - 1) ~/ 3;

    setState(() {
      selectedQuarter = quarter[quarterIndex];
    });
  }

  Future<void> fetchYears() async {
    try {
      final response = await http
          .get(Uri.parse("http://192.168.1.104/database/date/get_year.php"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            date = data.map((e) => e.toString()).toList();
            date.sort();
            if (date.isNotEmpty) {
              selectedYear = date.first;
            }
            isLoading = false;
          });
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> fetchDivisions() async {
    final response = await http.get(Uri.parse(
      'http://192.168.1.104/database/division/get_division_entity_dropdown.php',
    ));

    if (response.statusCode == 200) {
      List<String> fetchedDivisions =
          List<String>.from(json.decode(response.body));
      if (mounted) {
        setState(() {
          divisionItems = fetchedDivisions;
          if (divisionItems.isNotEmpty) {}
        });
      }
    } else {
      // Handle error
    }
  }

  void setDefaultMonth() {
    final now = DateTime.now();
    setState(() {
      selectedMonth = month[now.month - 1];
    });
  }

  void setDefaultYear() {
    final currentYear = DateTime.now().year.toString();
    setState(() {
      if (date.contains(currentYear)) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      double height = constraints.maxHeight;
      double parentWidth = constraints.maxWidth;

      double headerHeight = 100.0;
      double rowHeight = 60.0;
      double dropdownHeight = 30.0;
      double paddingHeight = 40.0;

      double remainingHeight =
          height - (headerHeight + rowHeight + dropdownHeight + paddingHeight);

      return Column(
        children: [
          CustomHeader(
            label: "Reports: $text",
            fname: widget.fname,
            lname: widget.lname,
            profileImage: widget.profileImage,
            redirectPage: widget.redirectPage,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomElevatedButtonReports(
                      text: "Monthly",
                      onTap: () {
                        setState(() {
                          activeIndex = 0;
                          text = "Monthly Results";
                        });
                      },
                      active: activeIndex == 0,
                    ),
                    CustomElevatedButtonReports(
                      text: "Quarterly",
                      onTap: () {
                        setState(() {
                          activeIndex = 1;
                          text = "Quarterly Results";
                        });
                      },
                      active: activeIndex == 1,
                    ),
                    CustomElevatedButtonReports(
                      text: "Annual",
                      onTap: () {
                        setState(() {
                          activeIndex = 2;
                          text = "Annual Results";
                        });
                      },
                      active: activeIndex == 2,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    // Division Dropdown
                    SizedBox(
                      width: parentWidth * 0.15,
                      child: CustomDropdown(
                        items: divisionItems,
                        selectedValue: selectedDivision,
                        onChanged: (value) {
                          setState(() {
                            selectedDivision = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),

                    // Year Dropdown
                    SizedBox(
                      width: parentWidth * 0.1,
                      child: CustomDropdown(
                        items: date,
                        selectedValue: selectedYear,
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),

                    // Quarter Dropdown (only for Quarterly)
                    if (activeIndex == 1)
                      SizedBox(
                        width: parentWidth * 0.1,
                        child: CustomDropdown(
                          items: quarter,
                          selectedValue: selectedQuarter,
                          onChanged: (value) {
                            setState(() {
                              selectedQuarter = value;
                            });
                          },
                        ),
                      ),

                    // Month Dropdown (only for Monthly)
                    if (activeIndex == 0)
                      SizedBox(
                        width: parentWidth * 0.1,
                        child: CustomDropdown(
                          items: month,
                          selectedValue: selectedMonth,
                          onChanged: (value) {
                            setState(() {
                              selectedMonth = value;
                            });
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: remainingHeight,
                  width: parentWidth,
                  child: Builder(
                    builder: (context) {
                      if (activeIndex == 0) {
                        // Monthly
                        return ResultPageDataTable(
                          width: parentWidth,
                          campus: widget.campus,
                          selectedMonth: selectedMonth,
                          selectedYear: selectedYear,
                          selectedDivision: selectedDivision,
                        );
                      } else if (activeIndex == 1) {
                        // Quarterly
                        return ResultPageQuarterly(
                          width: parentWidth,
                          campus: widget.campus,
                          selectedQuarter: selectedQuarter,
                          selectedYear: selectedYear,
                          selectedDivision: selectedDivision,
                        );
                      } else if (activeIndex == 2) {
                        // Annual
                        return ResultPageAnnually(
                          width: parentWidth,
                          campus: widget.campus,
                          selectedYear: selectedYear,
                          selectedDivision: selectedDivision,
                        );
                      } else {
                        return Center(
                            child: Text("Please select a report type."));
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}
