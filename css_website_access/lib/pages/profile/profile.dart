import 'dart:typed_data';
import 'package:css_website_access/pages/profile/information_handler.dart';
import 'package:css_website_access/pages/profile/picture_handler.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  final String? email;
  final String? campus;
  final String? password;
  const Profile({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
    this.email,
    this.campus,
    this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          label: "Profile",
          fname: fname,
          lname: lname,
          profileImage: profileImage,
          redirectPage: redirectPage,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F7F9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.2 * 255).toInt()),
                          offset: Offset(4, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: PictureHandler(
                      email: email ?? '',
                      profileImage: profileImage,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F7F9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.2 * 255).toInt()),
                          offset: Offset(4, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: InformationHandler(
                      fname: fname ?? '',
                      lname: lname ?? '',
                      campus: campus ?? '',
                      userRole: redirectPage ?? '',
                      email: email ?? '',
                      password: password ?? '',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
