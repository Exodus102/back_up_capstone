import 'dart:typed_data';
import 'package:css_website_access/pages/audit-logs/audit_logs_data_table.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';

class AuditLogs extends StatelessWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  const AuditLogs({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constrainst) {
        double height = constrainst.maxHeight;
        double parentwidth = constrainst.maxWidth;

        double header = 100;
        double paddingHeight = 40;
        double remainingHeight = height - (paddingHeight + header);

        return Column(
          children: [
            CustomHeader(
              label: "Audit Logs",
              fname: fname,
              lname: lname,
              profileImage: profileImage,
              redirectPage: redirectPage,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: remainingHeight,
                width: parentwidth,
                child: AuditLogsDataTable(),
              ),
            ),
          ],
        );
      },
    );
  }
}
