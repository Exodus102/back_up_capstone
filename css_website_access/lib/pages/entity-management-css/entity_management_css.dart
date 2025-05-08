import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:css_website_access/pages/entity-management-css/editable_data_cell_css.dart';
import 'package:css_website_access/pages/entity-management-css/show_dialog_entity_management_css.dart';
import 'package:css_website_access/pages/entity-management-css/show_error_dialog_entity_management_empty.dart';
import 'package:css_website_access/pages/entity-management-css/update_office_css.dart';
import 'package:css_website_access/pages/entity-management/edit_button_data_table_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:css_website_access/widgets/custom_button.dart';
import 'package:css_website_access/widgets/custom_header.dart';

class EntityManagementCss extends StatefulWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  final String? campus;
  const EntityManagementCss({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
    this.campus,
  });

  @override
  State<EntityManagementCss> createState() => _EntityManagementCssState();
}

class _EntityManagementCssState extends State<EntityManagementCss> {
  List<String> offices = [];
  int? _editingIndex;
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchOffices();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      fetchOffices();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchOffices() async {
    String campus = widget.campus ?? "Binangonan";
    final response = await http.get(Uri.parse(
        'http://192.168.1.104/database/office/get_office_list_css.php?campus=$campus'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        offices = data.map((item) => item['office'] as String).toList();
      });
    } else {
      throw Exception('Failed to load offices');
    }
  }

  void deleteCampusData(String office) async {
    String campus = widget.campus ?? "Binangonan";
    final response = await http.post(
      Uri.parse(
          'http://192.168.1.104/database/office/delete_office_entity_css.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'campus': campus,
        'office': office,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] != null) {
        setState(() {
          offices.remove(office);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Office deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete office')),
        );
      }
    } else {
      throw Exception('Failed to delete office');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constrainst) {
        final double width = constrainst.maxWidth;
        final ScrollController vertical = ScrollController();
        final ScrollController horizontal = ScrollController();
        double firstWidth = (width * 0.7).clamp(100.0, width - 100.0);
        double remainingWidth = (width - firstWidth - 40 - 16 - 40 - 90)
            .clamp(100.0, width - 100.0);

        return Column(
          children: [
            CustomHeader(
              label: 'Entity Management',
              fname: widget.fname,
              lname: widget.lname,
              profileImage: widget.profileImage,
              redirectPage: widget.redirectPage,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 150,
                          child: CustomButton(
                            label: "Add Unit",
                            svgPath: "svg/icons/+.svg",
                            onPressed: () {
                              showDialogAddUnitCss(context, widget.campus);
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Scrollbar(
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
                                    border: Border.all(
                                        color: const Color(0xFF7B8186),
                                        width: 1),
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
                                    headingRowColor:
                                        WidgetStateProperty.resolveWith<Color?>(
                                            (
                                      states,
                                    ) =>
                                                const Color(0xFF064089)),
                                    columns: [
                                      DataColumn(
                                        label: SizedBox(
                                          width: width * 0.7,
                                          child: Text(
                                            textAlign: TextAlign
                                                .start, // Align to the left
                                            'Unit',
                                            style: TextStyle(
                                                color: Color(0xFFF1F7F9)),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: remainingWidth,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'Actions',
                                            style: TextStyle(
                                                color: Color(0xFFF1F7F9)),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: offices
                                        .asMap()
                                        .map(
                                          (index, office) => MapEntry(
                                            index,
                                            DataRow(
                                              color: WidgetStateProperty
                                                  .resolveWith(
                                                (states) => index.isEven
                                                    ? Color(
                                                        0xFFEFF4F6) // Light blue
                                                    : Color(
                                                        0xFFCFD8E5), // Light greenish
                                              ),
                                              cells: [
                                                DataCell(
                                                  SizedBox(
                                                    width: width * 0.7,
                                                    child: _editingIndex ==
                                                            index
                                                        ? EditableDataCellCss(
                                                            controller:
                                                                _editingController,
                                                            focusNode:
                                                                _focusNode,
                                                            onSubmitted:
                                                                (value) {
                                                              setState(() {
                                                                offices[index] =
                                                                    value;
                                                                _editingIndex =
                                                                    null;
                                                              });
                                                            },
                                                            onUpdate: () async {
                                                              String oldOffice =
                                                                  offices[
                                                                      index];
                                                              String newOffice =
                                                                  _editingController
                                                                      .text
                                                                      .trim();
                                                              String campus = widget
                                                                      .campus ??
                                                                  "Binangonan";

                                                              if (newOffice
                                                                  .isEmpty) {
                                                                showErrorDialogEntityManagementEmpty(
                                                                    context,
                                                                    "Office name cannot be empty.");
                                                                return;
                                                              }

                                                              if (newOffice ==
                                                                  oldOffice) {
                                                                showErrorDialogEntityManagementEmpty(
                                                                    context,
                                                                    "Office name has not changed.");
                                                                return;
                                                              }

                                                              bool success =
                                                                  await updateOfficeCss(
                                                                context:
                                                                    context,
                                                                oldOffice:
                                                                    oldOffice,
                                                                newOffice:
                                                                    newOffice,
                                                                campus: campus,
                                                              );

                                                              if (success) {
                                                                setState(() {
                                                                  offices[index] =
                                                                      newOffice;
                                                                  _editingIndex =
                                                                      null;
                                                                });
                                                              }
                                                            },
                                                            onCancel: () {
                                                              setState(() {
                                                                _editingIndex =
                                                                    null;
                                                              });
                                                            },
                                                          )
                                                        : Text(
                                                            office,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                  ),
                                                ),
                                                DataCell(
                                                  SizedBox(
                                                    width: remainingWidth,
                                                    child: Row(
                                                      spacing: 10,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        EditButtonDataTableEntity(
                                                          onPressed: () {
                                                            setState(() {
                                                              _editingIndex =
                                                                  index;
                                                              _editingController
                                                                      .text =
                                                                  office;
                                                              _focusNode
                                                                  .requestFocus();
                                                            });
                                                          },
                                                          backgroundColor: index
                                                                  .isEven
                                                              ? Color(
                                                                  0xFFEFF4F6)
                                                              : Color(
                                                                  0xFFCFD8E5),
                                                        ),
                                                        MouseRegion(
                                                          cursor:
                                                              SystemMouseCursors
                                                                  .click,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              deleteCampusData(
                                                                  office);
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFFFEE2E2),
                                                                border: Border.all(
                                                                    color: Color(
                                                                        0xFFEF4444)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Color(
                                                                      0xFFEF4444),
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .values
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
