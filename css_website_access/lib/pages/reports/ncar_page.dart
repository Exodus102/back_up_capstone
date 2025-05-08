import 'dart:convert';
import 'dart:typed_data';

import 'package:css_website_access/pages/reports/ncar_page_data_table.dart';
import 'package:css_website_access/pages/reports/view_ncar_page.dart';
import 'package:css_website_access/widgets/custom_dropdown.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NcarPage extends StatefulWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  final String? campus;
  const NcarPage({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
    this.campus,
  });

  @override
  State<NcarPage> createState() => _NcarPageState();
}

class _NcarPageState extends State<NcarPage> {
  String? selectedDate;
  String? selectedOffice;
  String? selectedQuarter;
  bool isLoading = true;
  bool showReportPage = false;

  @override
  void initState() {
    super.initState();
    fetchYears();
    selectedQuarter = getCurrentQuarter();
  }

  Future<void> fetchYears() async {
    try {
      final response = await http
          .get(Uri.parse("http://192.168.1.104/database/date/get_year.php"));
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
        print("Selected Year after fetch: $selectedDate");
      }
    } catch (e) {
      print("Error fetching years: $e");
    }
  }

  List<String> date = [];
  final List<String> quarter = [
    "1st Quarter",
    "2nd Quarter",
    "3rd Quarter",
    "4th Quarter"
  ];
  String getCurrentQuarter() {
    int month = DateTime.now().month;
    if (month >= 1 && month <= 3) return "1st Quarter";
    if (month >= 4 && month <= 6) return "2nd Quarter";
    if (month >= 7 && month <= 9) return "3rd Quarter";
    return "4th Quarter";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constrainst) {
        double height = constrainst.maxHeight;
        double parentwidth = constrainst.maxWidth;

        double headerHeight = 100.0;
        double dropdownHeight = 30.0;
        double paddingHeight = 40.0;
        double buttonHeight = 15.0;
        double paddingWidth = 30.0;

        double remainingWidth = parentwidth - paddingWidth;
        double contentHeight = showReportPage
            ? (height - 150)
            : (height -
                headerHeight -
                dropdownHeight -
                paddingHeight -
                buttonHeight);

        double remainingHeight = height -
            (headerHeight + dropdownHeight + paddingHeight + buttonHeight);

        return Column(
          children: [
            CustomHeader(
              label: "Reports: Non-conformity and Corrective Action Report",
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
                          width: parentwidth * 0.1,
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
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: parentwidth * 0.1,
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
                      ],
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: contentHeight,
                    width: parentwidth,
                    child: SizedBox(
                      height: remainingHeight,
                      width: parentwidth,
                      child: showReportPage
                          ? SizedBox(
                              width: remainingWidth,
                              child: ViewNcarPage(
                                quarter: selectedQuarter,
                                fname: widget.fname,
                                lname: widget.lname,
                                office: selectedOffice ?? "Unknown",
                                campus: widget.campus,
                                year: selectedDate,
                                onBack: () {
                                  setState(() {
                                    showReportPage = false;
                                  });
                                },
                              ),
                            )
                          : NcarPageDataTable(
                              selectedQuarter: selectedQuarter,
                              campus: widget.campus,
                              width: remainingWidth,
                              selectedYear: selectedDate,
                              onViewReportPressed: (office) {
                                print("Quarter selected: $office");
                                setState(() {
                                  selectedOffice = office;
                                  showReportPage = true;
                                });
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
