import 'dart:typed_data';
import 'package:css_website_access/pages/dashboard/dashboard.dart';
import 'package:css_website_access/pages/display/display.dart';
import 'package:css_website_access/pages/profile/profile.dart';
import 'package:css_website_access/pages/reports/dcc_reports_page.dart';
import 'package:css_website_access/pages/survey/survey.dart';
import 'package:css_website_access/services/log-out/log_out.dart';
import 'package:css_website_access/widgets/custom_listile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dcc extends StatefulWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? campus;
  final String? redirectPage;
  final String? email;
  final String? password;
  const Dcc({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.campus,
    this.redirectPage,
    this.email,
    this.password,
  });

  @override
  State<Dcc> createState() => _Dcc();
}

class _Dcc extends State<Dcc> {
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = Dashboard(
      fname: widget.fname,
      lname: widget.lname,
      profileImage: widget.profileImage,
      redirectPage: widget.redirectPage,
    );
  }

  String _active = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E7EC),
      body: Row(
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Color(0xFFF1F7F9),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1E1E1E).withOpacity(0.4),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: SvgPicture.asset(
                              'svg/Logo.svg',
                              height: 100,
                              width: 50,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomListTile(
                            textStyle: TextStyle(
                                fontWeight: _active == "Dashboard"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _active == "Dashboard"
                                    ? Color(0xFF064089)
                                    : Color(0xFF48494A)),
                            onTapCallback: () {
                              setState(() {
                                _active = "Dashboard";
                                _currentPage = Dashboard(
                                  fname: widget.fname,
                                  lname: widget.lname,
                                  profileImage: widget.profileImage,
                                  redirectPage: widget.redirectPage,
                                );
                              });
                            },
                            text: 'Dashboard',
                            svgPath: 'svg/icons/dashboard.svg',
                            color: _active == "Dashboard"
                                ? Color(0xFF064089)
                                : Color(0xFF48494A),
                          ),
                          CustomListTile(
                            textStyle: TextStyle(
                                fontWeight: _active == "Survey"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _active == "Survey"
                                    ? Color(0xFF064089)
                                    : Color(0xFF48494A)),
                            onTapCallback: () {
                              setState(() {
                                _active = "Survey";
                                _currentPage = Survey(
                                  fname: widget.fname,
                                  lname: widget.lname,
                                  profileImage: widget.profileImage,
                                  redirectPage: widget.redirectPage,
                                );
                              });
                            },
                            text: 'Survey',
                            svgPath: 'svg/icons/survey.svg',
                            color: _active == "Survey"
                                ? Color(0xFF064089)
                                : Color(0xFF48494A),
                          ),
                          CustomListTile(
                            textStyle: TextStyle(
                                fontWeight: _active == "Reports"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _active == "Reports"
                                    ? Color(0xFF064089)
                                    : Color(0xFF48494A)),
                            onTapCallback: () {
                              setState(() {
                                _active = "Reports";
                                _currentPage = DccReportsPage(
                                  campus: widget.campus,
                                  fname: widget.fname,
                                  lname: widget.lname,
                                  profileImage: widget.profileImage,
                                  redirectPage: widget.redirectPage,
                                );
                              });
                            },
                            text: 'Reports',
                            svgPath: 'svg/icons/file-earmark-bar-graph.svg',
                            color: _active == "Reports"
                                ? Color(0xFF064089)
                                : Color(0xFF48494A),
                          ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'SETTINGS',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF48494A),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomListTile(
                            textStyle: TextStyle(
                                fontWeight: _active == "Profile"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _active == "Profile"
                                    ? Color(0xFF064089)
                                    : Color(0xFF48494A)),
                            onTapCallback: () {
                              setState(() {
                                _active = "Profile";
                                _currentPage = Profile(
                                  fname: widget.fname,
                                  lname: widget.lname,
                                  profileImage: widget.profileImage,
                                  redirectPage: widget.redirectPage,
                                  email: widget.email,
                                  campus: widget.campus,
                                  password: widget.password,
                                );
                              });
                            },
                            text: 'Profile',
                            svgPath: 'svg/icons/profile-circle.svg',
                            color: _active == "Profile"
                                ? Color(0xFF064089)
                                : Color(0xFF48494A),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => LogoutService.logout(context),
                      icon: const Icon(Icons.logout, color: Color(0xFF064089)),
                      label: const Text(
                        'Logout',
                        style: TextStyle(color: Color(0xFF064089)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color(0xFF064089), width: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _currentPage,
          ),
        ],
      ),
    );
  }
}
