import 'dart:convert';
import 'package:css_website_access/pages/reports/show_dialog_success.dart';
import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void resetPasswordDialog(BuildContext context, String email) {
  TextEditingController codeController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
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
                              SvgPicture.asset(
                                "svg/icons/exclamation.svg",
                                color: const Color(0xFF064089),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Please enter your new password.",
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
                        SizedBox(
                          child: TextField(
                            controller: codeController,
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF064089),
                                    width: 2), // Active color
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF064089),
                                    width: 1), // Inactive color
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomButtonNoIcon(
                          label: "Change Password",
                          onPressed: () async {
                            final response = await http.post(
                              Uri.parse(
                                  'http://192.168.1.104/database/login/new_password.php'),
                              body: {
                                'email': email,
                                'password': codeController.text.trim(),
                              },
                            );
                            print(
                                "Response body for password: ${response.body}");

                            final data = jsonDecode(response.body);
                            if (data['success'] == true) {
                              Navigator.of(context).pop();
                              showDialogSuccessReports(
                                  context, "Password changed successfully.");
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Invalid code. Please try again."),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 8),
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
    },
  );
}
