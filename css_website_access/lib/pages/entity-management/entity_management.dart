import 'dart:typed_data';
import 'package:css_website_access/pages/entity-management/edit_entity_management.dart';
import 'package:css_website_access/pages/entity-management/show_dialog_entity_management_campus.dart';
import 'package:css_website_access/pages/entity-management/show_dialog_entity_management_customer_type.dart';
import 'package:css_website_access/pages/entity-management/show_dialog_entity_management_division.dart';
import 'package:css_website_access/pages/entity-management/show_dialog_entity_management_unit.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class EntityManagement extends StatefulWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  const EntityManagement({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
  });

  @override
  EntityManagementState createState() => EntityManagementState();
}

class EntityManagementState extends State<EntityManagement> {
  List<String> unitItems = ["Show All"];
  String? selectedUnit = "Show All";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchDivisions();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchDivisions();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchDivisions() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.104/database/division/get_division_entity_dropdown.php'));

    if (response.statusCode == 200) {
      List<dynamic> divisions = json.decode(response.body);
      setState(() {
        unitItems = ["Show All"] + divisions.cast<String>();
        if (!unitItems.contains(selectedUnit)) {
          selectedUnit = "Show All";
        }
      });
    } else {
      throw Exception('Failed to load divisions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      double width = constraints.maxWidth;

      return SingleChildScrollView(
        child: Column(
          children: [
            CustomHeader(
              label: "Entity Management",
              fname: widget.fname,
              lname: widget.lname,
              profileImage: widget.profileImage,
              redirectPage: widget.redirectPage,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                spacing: 20,
                children: [
                  EditEntityManagement(
                    width: width,
                    text: "Add Customer Type",
                    label: "Add",
                    onPressed: () {
                      showDialogAddCustomerType(context);
                    },
                    items: [],
                    selectedValue: null,
                    onChanged: (value) {},
                  ),
                  EditEntityManagement(
                    width: width,
                    text: "Add Campus",
                    label: "Add",
                    onPressed: () {
                      showDialogAddCampus(context);
                    },
                    items: [],
                    selectedValue: null,
                    onChanged: (value) {},
                  ),
                  EditEntityManagement(
                    width: width,
                    text: "Add Division",
                    label: "Add",
                    onPressed: () {
                      showDialogAddDivision(context);
                    },
                    items: [],
                    selectedValue: null,
                    onChanged: (value) {},
                  ),
                  EditEntityManagement(
                    width: width,
                    text: "Add Unit",
                    label: "Add",
                    onPressed: () {
                      showDialogAddUnit(context);
                    },
                    items: unitItems,
                    selectedValue: selectedUnit,
                    onChanged: (value) {
                      setState(() {
                        selectedUnit = value;
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
