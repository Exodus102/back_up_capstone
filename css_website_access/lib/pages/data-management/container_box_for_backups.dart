import 'package:css_website_access/pages/data-management/custom_button_transparent_bg.dart';
import 'package:css_website_access/pages/data-management/show_dialog_success_data_management.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding JSON response

class ContainerBoxForBackups extends StatefulWidget {
  const ContainerBoxForBackups({super.key});

  @override
  State<ContainerBoxForBackups> createState() => _ContainerBoxForBackupsState();
}

class _ContainerBoxForBackupsState extends State<ContainerBoxForBackups> {
  // Method to trigger the backup
  Future<void> _createBackup(BuildContext context) async {
    print("Sending backup request...");

    try {
      final url =
          Uri.parse('http://192.168.1.104/database/backup-restore/backup.php');
      final response = await http.post(url,
          headers: <String, String>{'Content-Type': 'application/json'});

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          showDialogSuccessDataManagement(context);
        } else {
          showDialogSuccessDataManagement(context);
        }
      } else {
        print("Failed with status code: ${response.statusCode}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create backup.')));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF1F7F9),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Backup",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Create a new backup file of this system’s current version."),
                CustomButtonTransparentBg(
                  onPressed: () => _createBackup(context),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
