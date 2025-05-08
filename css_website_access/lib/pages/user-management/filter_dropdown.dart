import 'dart:convert';
import 'package:css_website_access/pages/user-management/campus_services.dart';
import 'package:css_website_access/pages/user-management/dropdown_add_account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:css_website_access/widgets/custom_dropdown.dart';
import 'package:intl/intl.dart';

class FilterDropdowns extends StatefulWidget {
  final String? selectedCampus;
  final String? selectedUnit;
  final String? selectedUserType;
  final DateTime? selectedDate;
  final String? selectedStatus;

  final Function(String?) onCampusChanged;
  final Function(String?) onUnitChanged;
  final Function(String?) onUserTypeChanged;
  final Function(DateTime?) onDateChanged;
  final Function(String?) onStatusChanged;

  const FilterDropdowns({
    super.key,
    required this.selectedCampus,
    required this.selectedUnit,
    required this.selectedUserType,
    required this.selectedDate,
    required this.selectedStatus,
    required this.onCampusChanged,
    required this.onUnitChanged,
    required this.onUserTypeChanged,
    required this.onDateChanged,
    required this.onStatusChanged,
  });

  @override
  FilterDropdownsState createState() => FilterDropdownsState();
}

class FilterDropdownsState extends State<FilterDropdowns> {
  List<Map<String, String>> campuses = [];
  List<Map<String, String>> units = [];

  @override
  void initState() {
    super.initState();
    loadCampuses();
    fetchUnits();
  }

  Future<void> loadCampuses() async {
    List<Map<String, String>> fetchedCampuses =
        await CampusServices.fetchCampuses();
    setState(() {
      campuses = fetchedCampuses;
    });
  }

  Future<void> fetchUnits() async {
    final url = Uri.parse(
        "http://192.168.1.104/database/filter-account/fetch_unit.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          units = [
                {"id": "all", "name": "Show All"}
              ] +
              data
                  .map((unit) => {
                        "id": unit["id"].toString(),
                        "name": unit["name"].toString()
                      })
                  .toList();
        });
      }
    } catch (e) {
      print("Error fetching units: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != widget.selectedDate) {
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("FILTERS:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 10),

        // Campus Dropdown
        Flexible(
          child: DropdownAddAccount(
            hintText: "Select Campus",
            items: campuses.map((campus) => campus["name"]!).toList(),
            selectedValue: widget.selectedCampus ?? "Show All",
            onChanged: (value) {
              widget.onCampusChanged(
                value == "Show All" ? null : value,
              );
            },
          ),
        ),
        SizedBox(width: 10),

        // Unit Dropdown
        Flexible(
          child: CustomDropdown(
            items: units.map((unit) => unit["name"]!).toList(),
            selectedValue: units.any((u) => u["name"] == widget.selectedUnit)
                ? widget.selectedUnit
                : "Show All",
            onChanged: (value) {
              widget.onUnitChanged(value == "Show All" ? null : value);
            },
          ),
        ),
        SizedBox(width: 10),

        // User Type Dropdown
        Flexible(
          child: CustomDropdown(
            items: [
              'Show All',
              'Coordinators',
              'Unit Head',
              'Director',
              'DCC',
              'MIS',
              'University MIS'
            ],
            selectedValue: widget.selectedUserType ?? "Show All",
            onChanged: (value) {
              widget.onUserTypeChanged(value == "Show All" ? null : value);
            },
          ),
        ),
        SizedBox(width: 10),

        // Date Picker as Dropdown
        Flexible(
          child: CustomDropdown(
            items: [
              "Select Date",
              if (widget.selectedDate != null)
                DateFormat('yyyy-MM-dd').format(widget.selectedDate!)
            ],
            selectedValue: widget.selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(widget.selectedDate!)
                : "Select Date",
            onChanged: (value) async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: widget.selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                setState(() {
                  widget.onDateChanged(pickedDate);
                });
              }
            },
          ),
        ),

        SizedBox(width: 10),

        // Status Dropdown
        Flexible(
          child: CustomDropdown(
            items: ["Show All", "Active", "Inactive"],
            selectedValue: widget.selectedStatus ?? "Show All",
            onChanged: (value) {
              widget.onStatusChanged(value == "Show All" ? null : value);
            },
          ),
        ),
      ],
    );
  }
}
