import 'package:css_website_access/pages/reports/show_dialog_error_reports.dart';
import 'package:css_website_access/pages/reports/show_dialog_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void showSubmitNcar(
  BuildContext context, {
  required String year,
  required String quarter,
  required String name,
  required String campus,
  required String office,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFF1F7F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: SvgPicture.asset(
                              "svg/icons/exclamation.svg",
                              color: const Color(0xFF064089),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Submit Report?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF064089),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEDE2E3),
                            foregroundColor: Color(0xFFEF4444),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () async {
                            final url = Uri.parse(
                                "http://192.168.1.104/database/files/ncar_report_sent.php");

                            try {
                              final response = await http.post(
                                url,
                                body: {
                                  'year': year,
                                  'quarter': quarter,
                                  'name': name,
                                  'campus': campus,
                                  'office': office,
                                },
                              );

                              final result = json.decode(response.body);

                              Navigator.of(context).pop();

                              if (result['success']) {
                                showDialogSuccessReports(
                                  context,
                                  "Report Submitted.",
                                );
                              } else {
                                showDialogErrorReports(
                                  context,
                                  "There was an error while submitting your report.",
                                );
                              }
                            } catch (e) {
                              Navigator.of(context).pop();
                              showDialogErrorReports(context, "An error $e");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD8E5EF),
                            foregroundColor: Color(0xFF064089),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Color(0xFF064089),
                              ),
                            ),
                          ),
                          child: const Text("Submit"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
