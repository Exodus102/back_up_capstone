import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void showDialogAddCampus(BuildContext context) {
  TextEditingController campusController = TextEditingController();
  String errorMessage = '';

  Future<void> addCampus(StateSetter setState) async {
    String campus = campusController.text.trim();

    if (campus.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a Campus';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.1.104/database/campus/add_campus.php'),
      body: {'campus': campus},
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
        errorMessage = 'Failed to add campus';
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
                      "Add Campus",
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
                        "Campus",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          child: TextField(
                            controller: campusController,
                            cursorColor: Color(0xFF064089),
                            decoration: InputDecoration(
                              hintText: "Name of New Campus",
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
                                vertical: 0,
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
                  onPressed: () => addCampus(setState),
                ),
              )
            ],
          );
        },
      );
    },
  );
}
