import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

Future<void> pickAndUploadFile(
  BuildContext context, {
  required VoidCallback onStart,
  required VoidCallback onComplete,
}) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
    withData: true,
  );

  if (result != null && result.files.single.bytes != null) {
    onStart(); // Show loader

    Uint8List fileBytes = result.files.single.bytes!;
    String fileName = result.files.single.name;

    var uri =
        Uri.parse("http://192.168.1.104/database/upload_csv/upload_csv.php");

    var request = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    try {
      final json = jsonDecode(responseBody);

      if (json['status'] == 'success') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Upload successful!\nInserted: ${json['inserted']} | Failed: ${json['failed']}",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${json['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error decoding response: $e")),
      );
    }

    onComplete(); // Hide loader
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No file selected.")),
    );
  }
}
