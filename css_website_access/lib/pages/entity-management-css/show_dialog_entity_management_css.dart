import 'package:css_website_access/pages/entity-management-css/show_error_dialog_entity_management.dart';
import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:css_website_access/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void showDialogAddUnitCss(BuildContext context, String? campus) {
  List<String> officeItems = [];
  String? selectedOffice;

  String? selectedDivision;
  String errorMessage = '';
  List<String> divisionItems = [];

  Future<void> fetchDivisions(StateSetter setState) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.104/database/division/get_division_entity_dropdown.php'));

    if (response.statusCode == 200) {
      List<dynamic> divisions = json.decode(response.body);
      setState(() {
        divisionItems = divisions.cast<String>();
        if (selectedDivision == null && divisionItems.isNotEmpty) {
          selectedDivision = divisionItems.first;
        }
      });
    } else {
      throw Exception('Failed to load divisions');
    }
  }

  Future<void> addUnit(StateSetter setState) async {
    String? unit = selectedOffice;

    if (selectedDivision == null || unit!.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.1.104/database/office/add_office_css.php'),
      body: {
        'division': selectedDivision,
        'unit': unit,
        'campus': campus,
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        Navigator.pop(context);
      } else {
        setState(() {
          errorMessage = result['message'];
        });
      }
    } else {
      showErrorDialogEntityManagement(context);
    }
  }

  Future<void> fetchOffices(StateSetter setState) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.104/database/office/fetch_office_list_css.php'));

    if (response.statusCode == 200) {
      List<dynamic> offices = json.decode(response.body);
      setState(() {
        officeItems =
            offices.map<String>((item) => item['office'] as String).toList();
        if (selectedOffice == null && officeItems.isNotEmpty) {
          selectedOffice = officeItems.first;
        }
      });
    } else {
      throw Exception('Failed to load offices');
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      bool hasLoadedData = false;

      return StatefulBuilder(
        builder: (context, setState) {
          if (!hasLoadedData) {
            fetchDivisions(setState);
            fetchOffices(setState);
            hasLoadedData = true;
          }

          return AlertDialog(
            backgroundColor: Colors.blueGrey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add Unit",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 15,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                spacing: 30,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        "Division",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomDropdown(
                          items: divisionItems,
                          selectedValue: selectedDivision,
                          onChanged: (value) {
                            setState(() {
                              selectedDivision = value;
                            });
                          }),
                    )
                  ]),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          "Office",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomDropdown(
                          items: officeItems,
                          selectedValue: selectedOffice,
                          onChanged: (value) {
                            setState(() {
                              selectedOffice = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: CustomButtonNoIcon(
                  label: "Add",
                  onPressed: () => addUnit(setState),
                ),
              )
            ],
          );
        },
      );
    },
  );
}
