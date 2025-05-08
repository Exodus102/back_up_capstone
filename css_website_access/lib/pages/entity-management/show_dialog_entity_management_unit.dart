import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:css_website_access/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void showDialogAddUnit(BuildContext context) {
  TextEditingController unitController = TextEditingController();
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
    String unit = unitController.text.trim();

    if (selectedDivision == null || unit.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.1.104/database/office/add_office.php'),
      body: {
        'division': selectedDivision!,
        'unit': unit,
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
      setState(() {
        errorMessage = 'Failed to add unit';
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          fetchDivisions(setState);
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
                          "Unit",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          child: TextField(
                            controller: unitController,
                            cursorColor: Color(0xFF064089),
                            decoration: InputDecoration(
                              hintText: "Name of New Unit",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: errorMessage.isNotEmpty
                                      ? Colors.red
                                      : Color(0xFF064089),
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 1),
                            ),
                          ),
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
