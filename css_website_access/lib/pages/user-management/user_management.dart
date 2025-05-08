import 'dart:typed_data';
import 'package:css_website_access/pages/user-management/add_account.dart';
import 'package:css_website_access/pages/user-management/edit_account.dart';
import 'package:css_website_access/pages/user-management/filter_dropdown.dart';
import 'package:css_website_access/pages/user-management/user_table.dart';
import 'package:css_website_access/widgets/custom_button.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;

  const UserManagement({
    super.key,
    required this.fname,
    required this.lname,
    required this.profileImage,
    required this.redirectPage,
  });

  @override
  UserManagementState createState() => UserManagementState();
}

class UserManagementState extends State<UserManagement> {
  String? selectedCampus;
  String? selectedUnit;
  String? selectedUserType = 'Show All';
  DateTime? selectedDate;
  String? selectedStatus = 'Show All';
  bool _showAddAccount = false;
  bool showEditAccount = false;
  String? searchQuery;
  Map<String, dynamic>? selectedUserData;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double totalHeight = constraints.maxHeight;

        double headerHeight = 100;
        double paddingHeight = 40;
        double searchBarHeight = 40;
        double filterDropdownHeight = 40;
        double spacing = 30;

        double remainingHeight = totalHeight -
            (headerHeight +
                paddingHeight +
                searchBarHeight +
                filterDropdownHeight +
                spacing);

        double addAccountHeight =
            totalHeight - headerHeight - paddingHeight - 50;

        return Column(
          children: [
            CustomHeader(
              label: "User Management",
              fname: widget.fname,
              lname: widget.lname,
              profileImage: widget.profileImage,
              redirectPage: widget.redirectPage,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (!_showAddAccount && !showEditAccount)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            cursorColor: const Color(0xFF064089),
                            decoration: const InputDecoration(
                              labelText: 'Search',
                              floatingLabelStyle:
                                  TextStyle(color: Color(0xFF064089)),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF064089),
                                  width: 2,
                                ),
                              ),
                              suffixIcon: Icon(Icons.search, size: 25),
                            ),
                          ),
                        ),
                        CustomButton(
                          label: "Add Account",
                          onPressed: () {
                            setState(() {
                              _showAddAccount = true;
                            });
                          },
                          svgPath: 'svg/icons/+.svg',
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  if (!_showAddAccount && !showEditAccount) ...[
                    FilterDropdowns(
                      selectedCampus: selectedCampus,
                      selectedUnit: selectedUnit,
                      selectedUserType: selectedUserType,
                      selectedDate: selectedDate,
                      selectedStatus: selectedStatus,
                      onCampusChanged: (value) =>
                          setState(() => selectedCampus = value),
                      onUnitChanged: (value) =>
                          setState(() => selectedUnit = value),
                      onUserTypeChanged: (value) =>
                          setState(() => selectedUserType = value),
                      onDateChanged: (value) =>
                          setState(() => selectedDate = value),
                      onStatusChanged: (value) =>
                          setState(() => selectedStatus = value),
                    ),
                    SizedBox(height: 10),
                    UserTable(
                      width: width,
                      height: remainingHeight,
                      selectedCampus: selectedCampus,
                      selectedUnit: selectedUnit,
                      selectedUserType: selectedUserType,
                      selectedStatus: selectedStatus,
                      selectedDate: selectedDate,
                      searchQuery: searchQuery,
                      onUserSelected: (userData) {
                        selectedUserData = userData;
                      },
                      onPressed: () {
                        setState(() {
                          showEditAccount = true;
                        });
                      },
                    ),
                  ] else if (_showAddAccount) ...[
                    AddAccount(
                      fname: widget.fname,
                      lname: widget.lname,
                      height: addAccountHeight,
                      width: width,
                      onPressed: () {
                        setState(() {
                          _showAddAccount = false;
                        });
                      },
                    ),
                  ] else if (showEditAccount) ...[
                    EditAccount(
                      fname: widget.fname,
                      lname: widget.lname,
                      userData: selectedUserData,
                      height: addAccountHeight,
                      width: width,
                      onPressed: () {
                        setState(() {
                          showEditAccount = false;
                          selectedUserData = null;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
