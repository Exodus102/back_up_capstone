import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:css_website_access/users/css-coordinator/css_coordinator_page.dart';
import 'package:css_website_access/users/css-head-coordinator/css_head_coordinator.dart';
import 'package:css_website_access/users/dcc/dcc.dart';
import 'package:css_website_access/users/director/director.dart';
import 'package:css_website_access/users/mis/mis_page.dart';
import 'package:css_website_access/users/unit-head/unit_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  final String? email;
  const SplashScreen({
    super.key,
    this.email,
  });

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String? fname;
  String? lname;
  String? campus;
  Uint8List? profileImage;
  String? password;
  String? unit;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    if (widget.email == null || widget.email!.isEmpty) {
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("http://192.168.1.104/database/login/get_user_role.php"),
        body: {"email": widget.email},
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('fname') &&
            jsonResponse.containsKey('lname') &&
            jsonResponse.containsKey('campus')) {
          setState(() {
            fname = jsonResponse['fname'];
            lname = jsonResponse['lname'];
            campus = jsonResponse['campus'];
            unit = jsonResponse['unit'];
          });
        }

        if (jsonResponse.containsKey('password')) {
          password = jsonResponse['password'];
        }

        if (jsonResponse.containsKey('dp') && jsonResponse['dp'] != null) {
          profileImage = base64Decode(jsonResponse['dp']);
        }

        if (jsonResponse.containsKey('redirect')) {
          String redirectPage = jsonResponse['redirect'];

          Widget? nextPage;
          if (redirectPage == "MisPage") {
            nextPage = MisPage(
              email: widget.email, // Pass email
              fname: fname,
              lname: lname,
              campus: campus,
              profileImage: profileImage,
              redirectPage: redirectPage,
              password: password,
            );
          } else if (redirectPage == "CssCoordinatorPanelSide") {
            nextPage = CssCoordinatorPanelSide(
              email: widget.email,
              fname: fname,
              lname: lname,
              campus: campus,
              profileImage: profileImage,
              redirectPage: redirectPage,
              password: password,
            );
          } else if (redirectPage == "DirectorPanel") {
            nextPage = Director(
              email: widget.email,
              fname: fname,
              lname: lname,
              campus: campus,
              profileImage: profileImage,
              redirectPage: redirectPage,
              password: password,
            );
          } else if (redirectPage == "DccPanel") {
            nextPage = Dcc(
              email: widget.email,
              fname: fname,
              lname: lname,
              campus: campus,
              profileImage: profileImage,
              redirectPage: redirectPage,
              password: password,
            );
          } else if (redirectPage == "UnitHeadPanel") {
            nextPage = UnitHead(
              email: widget.email,
              fname: fname,
              lname: lname,
              campus: campus,
              profileImage: profileImage,
              redirectPage: redirectPage,
              password: password,
            );
          } else if (redirectPage == "CssHeadPanel") {
            nextPage = CssHeadCoordinator(
              email: widget.email,
              fname: fname,
              lname: lname,
              campus: campus,
              profileImage: profileImage,
              redirectPage: redirectPage,
              password: password,
            );
          }

          if (nextPage != null && mounted) {
            await Future.delayed(Duration(seconds: 3));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => nextPage!),
            );
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  "svg/Logo-SplashScreen.svg",
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),
                Text(
                  'URSatisfaction',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'We comply so URSatisfied',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              '© University of Rizal System - 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
