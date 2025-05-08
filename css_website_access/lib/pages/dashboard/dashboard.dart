import 'dart:typed_data';

import 'package:css_website_access/pages/dashboard/dashboard-contents/low_responses.dart';
import 'package:css_website_access/pages/dashboard/dashboard-contents/trend_analysis.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  final String? campus;
  const Dashboard({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
    this.campus,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constrainst) {
        final double height = constrainst.maxHeight;
        final double width = constrainst.maxWidth;
        print("Campus before sending: $campus");

        double customHeader = 100;
        double lowResponses = 300;
        double button = 23;

        double remainingHeignt =
            height - (customHeader + lowResponses + button + 91 + 30);

        return Column(
          children: [
            CustomHeader(
              label: "Dashboard",
              fname: fname,
              lname: lname,
              profileImage: profileImage,
              redirectPage: redirectPage,
            ),
            SizedBox(
              width: width,
              child: LowResponses(
                width: width,
                campus: campus,
              ),
            ),
          ],
        );
      },
    );
  }
}
