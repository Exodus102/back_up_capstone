import 'dart:convert';

import 'package:css_website_access/pages/profile/change_fname.dart';
import 'package:css_website_access/pages/profile/change_lname.dart';
import 'package:css_website_access/pages/profile/change_password.dart';
import 'package:css_website_access/pages/profile/fetch_campus_profile.dart';
import 'package:css_website_access/pages/profile/fetch_email.dart';
import 'package:css_website_access/pages/profile/fetch_unit_profile.dart';
import 'package:css_website_access/pages/profile/save_changes_button_profile.dart';
import 'package:css_website_access/pages/profile/show_dialog_box_error.dart';
import 'package:css_website_access/pages/profile/show_dialog_box_success.dart';
import 'package:css_website_access/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InformationHandler extends StatefulWidget {
  final String email;
  final String lname;
  final String fname;
  final String campus;
  final String userRole;
  final String password;
  const InformationHandler({
    super.key,
    required this.email,
    required this.lname,
    required this.fname,
    required this.campus,
    required this.userRole,
    required this.password,
  });

  @override
  State<InformationHandler> createState() => _InformationHandlerState();
}

class _InformationHandlerState extends State<InformationHandler> {
  bool? isChange = false;
  bool? isShown = true;
  late TextEditingController fnameController;
  late TextEditingController lnameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    fnameController = TextEditingController(text: widget.fname);
    lnameController = TextEditingController(text: widget.lname);
    passwordController = TextEditingController(text: widget.password);
  }

  void toggleChange() {
    setState(() {
      isChange = true;
      isShown = false;
    });
  }

  void updateUserInfo() async {
    setState(() {
      isChange = null;
    });

    final url =
        "http://192.168.1.104/database/update-profile/update_information.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': widget.email,
          'fname': fnameController.text,
          'lname': lnameController.text,
          'password': passwordController.text.isNotEmpty
              ? passwordController.text
              : widget.password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            isChange = false;
            isShown = true;
          });
          showDialogBoxSuccess(context);
        } else {
          setState(() {
            isChange = true;
          });
          showDialogBoxError(context);
        }
      } else {
        setState(() {
          isChange = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile.")),
        );
      }
    } catch (e) {
      setState(() {
        isChange = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: MediaQuery.of(context).size.width * 0.2,
        bottom: 30,
        top: 30,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Change User Information Here",
                style: TextStyle(
                  color: Color(0xFF064089),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              isChange == true
                  ? SaveChangesButtonProfile(
                      onPressed: updateUserInfo,
                    )
                  : CustomButton(
                      label: "Edit",
                      svgPath: "svg/icons/pencil.svg",
                      onPressed: toggleChange,
                    ),
            ],
          ),
          SizedBox(height: 20),
          ChangeFname(
            isChange: isChange,
            controller: fnameController,
          ),
          SizedBox(height: 20),
          ChangeLname(
            isChange: isChange,
            controller: lnameController,
          ),
          SizedBox(height: 20),
          FetchUnitProfile(
            redirectPage: widget.userRole,
          ),
          SizedBox(height: 20),
          FetchCampusProfile(
            campus: widget.campus,
          ),
          SizedBox(height: 20),
          FetchEmail(
            email: widget.email,
          ),
          SizedBox(height: 20),
          ChangePassword(
            isChange: isChange,
            isShown: isShown,
            controller: passwordController,
          ),
        ],
      ),
    );
  }
}
