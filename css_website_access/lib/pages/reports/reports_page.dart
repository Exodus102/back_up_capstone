import 'dart:typed_data';
import 'package:css_website_access/pages/reports/report_page_data_table.dart';
import 'package:css_website_access/pages/reports/view_report_page.dart';
import 'package:css_website_access/widgets/custom_button.dart';
import 'package:css_website_access/widgets/custom_dropdown.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportsPage extends StatefulWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  final String? campus;
  const ReportsPage({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
    this.campus,
  });

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String? selectedDate;
  List<String> date = [];
  bool isLoading = true;
  bool showReportPage = false;

  String? quarter;

  @override
  void initState() {
    super.initState();
    fetchYears();
  }

  Future<void> fetchYears() async {
    try {
      final response = await http
          .get(Uri.parse("http://192.168.1.104/database/date/get_year.php"));

      print("Year: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          date = data.map((e) => e.toString()).toList();
          date.sort();
          if (date.isNotEmpty) {
            selectedDate = date.first;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching years: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        double height = constraints.maxHeight;
        double parentWidth = constraints.maxWidth;

        double headerHeight = 100.0;
        double dropdownHeight = 30.0;
        double paddingHeight = 40.0;
        double buttonHeight = 15.0;
        double paddingWidth = 30.0;

        double remainingWidth = parentWidth - paddingWidth;
        double contentHeight = showReportPage
            ? (height - 150)
            : (height -
                headerHeight -
                dropdownHeight -
                paddingHeight -
                buttonHeight);

        return Column(
          children: [
            CustomHeader(
              label: "Reports: Reports",
              fname: widget.fname,
              lname: widget.lname,
              profileImage: widget.profileImage,
              redirectPage: widget.redirectPage,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (!showReportPage)
                    Row(
                      children: [
                        SizedBox(
                          width: parentWidth * 0.1,
                          child: CustomDropdown(
                            items: date,
                            selectedValue: selectedDate,
                            onChanged: (value) {
                              setState(() {
                                selectedDate = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  SizedBox(
                      height: contentHeight,
                      width: parentWidth,
                      child: showReportPage
                          ? SizedBox(
                              width: remainingWidth,
                              child: ViewReportPage(
                                campus: widget.campus,
                                fname: widget.fname,
                                lname: widget.lname,
                                quarter: quarter,
                                year: selectedDate,
                                onBack: () {
                                  setState(() {
                                    showReportPage = false;
                                  });
                                },
                              ),
                            )
                          : selectedDate != null
                              ? ReportPageDataTable(
                                  campus: widget.campus,
                                  selectedYear: selectedDate,
                                  width: remainingWidth,
                                  onViewReportPressed: (selectedQuarter) {
                                    setState(() {
                                      showReportPage = true;
                                      quarter = selectedQuarter;
                                    });
                                  },
                                )
                              : Center(
                                  child: Text(
                                      "No reports can generate right now.")))
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
