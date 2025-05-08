import 'dart:convert';

import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:css_website_access/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonthlyResponsesRow extends StatefulWidget {
  final void Function(String office)? onOfficeChange;
  final void Function(String year)? onYearChanged;
  final void Function(String month)? onMonthChanged;

  const MonthlyResponsesRow({
    super.key,
    this.onOfficeChange,
    this.onYearChanged,
    this.onMonthChanged,
  });

  @override
  State<MonthlyResponsesRow> createState() => _MonthlyResponsesRowState();
}

class _MonthlyResponsesRowState extends State<MonthlyResponsesRow> {
  List<String> items = [];
  String? selectedOffice;
  String? selectedYear;
  String? selectedMonth;
  List<String> date = [];

  final List<String> months = [
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
    fetchDivisions();
    fetchYears();
    final now = DateTime.now();
    selectedMonth = months[now.month - 1];
  }

  Future<void> fetchYears() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.104/database/date/get_year.php"),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          date = data.map((e) => e.toString()).toList();
          date.sort();
          if (date.isNotEmpty) {
            selectedYear = date.first;
          }
        });
      }
    } catch (e) {
      print("Error fetching years: $e");
    }
  }

  Future<void> fetchDivisions() async {
    final response = await http.get(Uri.parse(
      'http://192.168.1.104/database/division/get_division_entity_dropdown.php',
    ));

    if (response.statusCode == 200) {
      List<String> fetchedDivisions =
          List<String>.from(json.decode(response.body));
      setState(() {
        items = fetchedDivisions;
        if (items.isNotEmpty) {
          selectedOffice = items[0];
        }
      });
    } else {
      print('Failed to load divisions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Text(
          "Monthly Responses",
          style: TextStyle(
            color: Color(0xFF064089),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Spacer(),
        SizedBox(
          width: 200,
          child: CustomDropdown(
            items: items,
            selectedValue: selectedOffice,
            onChanged: (value) {
              setState(() {
                selectedOffice = value;
              });
              if (value != null) widget.onOfficeChange?.call(value);
            },
            hint: "Select Division",
          ),
        ),
        SizedBox(
          width: 100,
          child: CustomDropdown(
            items: date,
            selectedValue: selectedYear,
            onChanged: (value) {
              setState(() {
                selectedYear = value;
              });
              if (value != null) widget.onYearChanged?.call(value);
            },
          ),
        ),
        SizedBox(
          width: 120,
          child: CustomDropdown(
            items: months,
            selectedValue: selectedMonth,
            onChanged: (value) {
              setState(() {
                selectedMonth = value;
              });
              if (value != null) widget.onMonthChanged?.call(value);
            },
          ),
        ),
      ],
    );
  }
}
