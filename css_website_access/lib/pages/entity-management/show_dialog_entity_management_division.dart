import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void showDialogAddDivision(BuildContext context) {
  TextEditingController divisionController = TextEditingController();
  String errorMessage = '';

  Future<void> addDivision(StateSetter setState) async {
    String division = divisionController.text.trim();

    if (division.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a Division';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.1.104/database/division/add_division.php'),
      body: {'division': division},
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        // Handle success
        Navigator.pop(context);
      } else {
        // Handle error
        setState(() {
          errorMessage = result['message'];
        });
      }
    } else {
      // Handle error
      setState(() {
        errorMessage = 'Failed to add division';
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
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
                      "Add Division",
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Division",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          child: TextField(
                            controller: divisionController,
                            cursorColor: Color(0xFF064089),
                            decoration: InputDecoration(
                              hintText: "Name of New Division",
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
                                horizontal: 10,
                                vertical: 1,
                              ),
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
                  onPressed: () => addDivision(setState),
                ),
              )
            ],
          );
        },
      );
    },
  );
}
