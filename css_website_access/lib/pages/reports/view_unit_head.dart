import 'package:css_website_access/pages/reports/submit_ncar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:css_website_access/pages/reports/submit_report_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewUnitHead extends StatefulWidget {
  final VoidCallback onBack;
  final String? year;
  final String? campus;
  final String? office;
  final String? quarter;
  final String? fname;
  final String? lname;
  const ViewUnitHead({
    super.key,
    required this.onBack,
    this.year,
    this.campus,
    this.office,
    this.quarter,
    this.fname,
    this.lname,
  });

  @override
  ViewNcarPageState createState() => ViewNcarPageState();
}

class ViewNcarPageState extends State<ViewUnitHead> {
  String? pdfUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPdfUrl();
  }

  Future<void> fetchPdfUrl() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.104/database/files/ncar_pdf_form.php?campus=${widget.campus}&office=${widget.office}'),
    );

    print("Response body for file: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("NCAR PDF Response: $responseData");

      if (responseData["success"] == true) {
        setState(() {
          pdfUrl =
              "http://192.168.1.104/database/files/ncar_pdf_view.php?campus=${widget.campus}&office=${widget.office}";
          isLoading = false;
        });
      } else {
        print("Server reported failure: ${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch PDF URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;
      double remainingHeight = height - (30 + 20);

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_circle_left_outlined),
                    color: const Color(0xFF064089),
                  ),
                  Text(
                    "${widget.office} NCAR",
                    style: const TextStyle(
                      color: Color(0xFF064089),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: width,
            height: remainingHeight,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F7F9),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : pdfUrl != null
                    ? SfPdfViewer.network(
                        pdfUrl!,
                        onDocumentLoadFailed:
                            (PdfDocumentLoadFailedDetails details) {
                          print("Failed to load PDF: ${details.error}");
                          print("Error Details: ${details.description}");
                        },
                      )
                    : const Center(
                        child: Text('PDF not available'),
                      ),
          ),
        ],
      );
    });
  }
}
