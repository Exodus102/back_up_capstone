import 'dart:async';
import 'dart:convert';
import 'package:css_website_access/pages/entity-management/edit_button_data_table_entity.dart';
import 'package:css_website_access/pages/entity-management/editable_data_cell.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCustomerTypeDataTable extends StatefulWidget {
  final double width;
  const AddCustomerTypeDataTable({
    super.key,
    required this.width,
  });

  @override
  AddCustomerTypeDataTableState createState() =>
      AddCustomerTypeDataTableState();
}

class AddCustomerTypeDataTableState extends State<AddCustomerTypeDataTable> {
  List<Map<String, String>> data = [];
  Timer? _timer;
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? _editingIndex;

  late double firstWidth;
  late double remainingWidth;

  @override
  void initState() {
    super.initState();
    firstWidth = widget.width * 0.7;
    remainingWidth = widget.width - firstWidth - 40 - 16 - 40 - 90;
    fetchData();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _editingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.104/database/customer-type/get_customer_type.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        data = jsonData
            .map((item) =>
                {"Office": item['customer_type'] as String, "Actions": "View"})
            .toList()
            .cast<Map<String, String>>();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteCustomerType(String customerType) async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.1.104/database/customer-type/delete_customer_type.php'),
      body: {'customer_type': customerType},
    );

    if (response.statusCode == 200) {
      setState(() {
        data.removeWhere((item) => item['Office'] == customerType);
      });
    } else {
      throw Exception('Failed to delete customer type');
    }
  }

  Future<void> _updateCustomerType(
      String oldCustomerType, String newCustomerType) async {
    if (newCustomerType.trim().isEmpty) {
      _showErrorDialog('Customer type cannot be empty.');
      return;
    }

    final response = await http.post(
      Uri.parse(
          'http://192.168.1.104/database/customer-type/update_customer_type.php'),
      body: {
        'old_customer_type': oldCustomerType,
        'new_customer_type': newCustomerType
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        setState(() {
          data = data.map((row) {
            if (row['Office'] == oldCustomerType) {
              row['Office'] = newCustomerType;
            }
            return row;
          }).toList();
        });
      } else {
        _showErrorDialog(result['error']);
      }
    } else {
      throw Exception('Failed to update customer type');
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController vertical = ScrollController();
    final ScrollController horizontal = ScrollController();

    return Scrollbar(
      trackVisibility: true,
      thumbVisibility: true,
      interactive: true,
      thickness: 8.0,
      controller: horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: horizontal,
        child: Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          interactive: true,
          thickness: 8.0,
          controller: vertical,
          child: SingleChildScrollView(
            controller: vertical,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF7B8186), width: 1),
                ),
                child: DataTable(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Color(0xFF7B8186),
                      width: 1,
                    ),
                    verticalInside: BorderSide(
                      color: Color(0xFF7B8186),
                      width: 1,
                    ),
                  ),
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (states) => const Color(0xFF064089),
                  ),
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: widget.width * 0.7,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Customer Type',
                          style: TextStyle(color: Color(0xFFF1F7F9)),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: remainingWidth,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Actions',
                          style: TextStyle(color: Color(0xFFF1F7F9)),
                        ),
                      ),
                    ),
                  ],
                  rows: data
                      .asMap()
                      .map((index, row) {
                        Color rowColor = index.isEven
                            ? Color(0xFFF1F7F9)
                            : Color(0xFFCFD8E5);

                        return MapEntry(
                          index,
                          DataRow(
                            color: MaterialStateProperty.all(rowColor),
                            cells: [
                              DataCell(
                                _editingIndex == index
                                    ? EditableDataCell(
                                        controller: _editingController,
                                        focusNode: _focusNode,
                                        onSubmitted: (newValue) {
                                          _updateCustomerType(
                                              row['Office']!, newValue);
                                          setState(() {
                                            _editingIndex = null;
                                          });
                                        },
                                        onUpdate: () {
                                          _updateCustomerType(row['Office']!,
                                              _editingController.text);
                                          setState(() {
                                            _editingIndex = null;
                                          });
                                        },
                                        onCancel: () {
                                          setState(() {
                                            _editingIndex = null;
                                          });
                                        },
                                      )
                                    : Text(
                                        row['Office']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                              DataCell(
                                Row(
                                  spacing: 10,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    EditButtonDataTableEntity(
                                      onPressed: () {
                                        setState(() {
                                          _editingIndex = index;
                                          _editingController.text =
                                              row['Office']!;
                                          _focusNode.requestFocus();
                                        });
                                      },
                                      backgroundColor: rowColor,
                                    ),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          deleteCustomerType(row['Office']!);
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFEE2E2),
                                            border: Border.all(
                                                color: Color(0xFFEF4444)),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.delete,
                                              color: Color(0xFFEF4444),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                      .values
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
