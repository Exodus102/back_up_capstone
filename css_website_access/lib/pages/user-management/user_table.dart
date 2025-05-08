import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserTable extends StatefulWidget {
  final double width;
  final double height;
  final String? selectedCampus;
  final String? selectedUnit;
  final String? selectedUserType;
  final String? selectedStatus;
  final DateTime? selectedDate;
  final String? searchQuery;
  final Function(Map<String, dynamic>) onUserSelected;
  final VoidCallback onPressed;

  const UserTable({
    super.key,
    required this.width,
    required this.height,
    this.selectedCampus,
    this.selectedUnit,
    this.selectedUserType,
    this.selectedStatus,
    this.selectedDate,
    this.searchQuery,
    required this.onUserSelected,
    required this.onPressed,
  });

  @override
  UserTableState createState() => UserTableState();
}

class UserTableState extends State<UserTable> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  void didUpdateWidget(UserTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedCampus != oldWidget.selectedCampus ||
        widget.selectedUnit != oldWidget.selectedUnit ||
        widget.selectedUserType != oldWidget.selectedUserType ||
        widget.selectedStatus != oldWidget.selectedStatus ||
        widget.selectedDate != oldWidget.selectedDate ||
        widget.searchQuery != oldWidget.searchQuery) {
      fetchUsers();
    }
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final queryParams = {
        if (widget.selectedCampus != null && widget.selectedCampus!.isNotEmpty)
          "campus": widget.selectedCampus!,
        if (widget.selectedUnit != null && widget.selectedUnit!.isNotEmpty)
          "unit": widget.selectedUnit!,
        if (widget.selectedUserType != null &&
            widget.selectedUserType!.isNotEmpty &&
            widget.selectedUserType != "Show All")
          "user_type": widget.selectedUserType!,
        if (widget.selectedStatus != null &&
            widget.selectedStatus!.isNotEmpty &&
            widget.selectedStatus != "Show All")
          "status": widget.selectedStatus!,
        if (widget.selectedDate != null &&
            widget.selectedDate!.toIso8601String().isNotEmpty)
          "created_at": widget.selectedDate!.toIso8601String().split("T")[0],
        if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty)
          "search": widget.searchQuery!,
      };

      final uri = Uri.http("192.168.1.104",
          "/database/add-account/fetch_users.php", queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          data = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Scrollbar(
              thumbVisibility: true,
              controller: verticalScrollController,
              child: SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: horizontalScrollController,
                  child: SingleChildScrollView(
                    controller: horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border:
                          TableBorder.all(color: Color(0xFF7B8186), width: 0.9),
                      headingRowColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => Color(0xFF064089),
                      ),
                      columns: [
                        DataColumn(
                            label: Text('Campus',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Unit',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('User Type',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Name',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Contact Number',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Email',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Password',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Date Created',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Status',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Edit',
                                style: TextStyle(color: Colors.white))),
                      ],
                      rows: data.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> item = entry.value;

                        Color rowColor = index % 2 == 0
                            ? Color(0xFFF1F7F9)
                            : Color(0xFFC8D0DD);

                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) => rowColor),
                          cells: [
                            DataCell(Text(item['Campus'])),
                            DataCell(Text(item['Unit'])),
                            DataCell(Text(item['User Type'])),
                            DataCell(Text(item['Name'])),
                            DataCell(Text(item['Contact Number'])),
                            DataCell(Text(item['Email'])),
                            DataCell(Text(item['Password'])),
                            DataCell(Text(item['Date Created'])),
                            DataCell(
                              Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item['Status'] == 'Inactive'
                                      ? Color(0xFFEE6B6E)
                                      : Color(0xFF29AB87),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: Text(item['Status'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  widget.onUserSelected(item);
                                  widget.onPressed();
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
