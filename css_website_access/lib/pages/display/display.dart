import 'dart:typed_data';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatelessWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  const DisplayPage({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          label: "Display",
          fname: fname,
          lname: lname,
          profileImage: profileImage,
          redirectPage: redirectPage,
        ),
      ],
    );
  }
}
