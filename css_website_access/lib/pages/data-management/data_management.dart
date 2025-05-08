import 'dart:typed_data';
import 'package:css_website_access/pages/data-management/container_box_for_backups.dart';
import 'package:css_website_access/pages/data-management/container_box_for_restore.dart';
import 'package:css_website_access/pages/data-management/text_title.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class DataManagement extends StatelessWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;

  const DataManagement({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double availableWidth = width - 40;

        return Column(
          children: [
            CustomHeader(
              label: "Data Management",
              fname: fname,
              lname: lname,
              profileImage: profileImage,
              redirectPage: redirectPage,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextTitle(),
                          // Adjust the size of the boxes based on available screen space
                          ContainerBoxForRestore(
                            width: availableWidth,
                          ),
                          ContainerBoxForBackups(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
