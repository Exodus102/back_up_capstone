import 'package:css_website_access/pages/reports/submit_ncar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:css_website_access/pages/reports/submit_report_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON parsing

class ViewNcarDirectors extends StatefulWidget {
  final VoidCallback onBack;
  final String? year;
  final String? campus;
  final String office;
  final String? quarter;
  final String? fname;
  final String? lname;
  final String? filePath;
  const ViewNcarDirectors({
    super.key,
    required this.onBack,
    this.year,
    this.campus,
    required this.office,
    this.quarter,
    this.fname,
    this.lname,
    this.filePath,
  });

  @override
  ViewNcarPageState createState() => ViewNcarPageState();
}

class ViewNcarPageState extends State<ViewNcarDirectors> {
  String? pdfUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPdfUrl();
  }

  Future<void> fetchPdfUrl() async {
    if (widget.filePath == null || widget.filePath!.isEmpty) {
      setState(() {
        isLoading = false;
        pdfUrl = null;
      });
      return;
    }

    final encodedPath = Uri.encodeComponent(widget.filePath!);
    final serverBaseUrl = 'http://192.168.1.104/database/files';
    final fullUrl =
        '$serverBaseUrl/view_ncar_director.php?file_path=$encodedPath';

    setState(() {
      pdfUrl = fullUrl;
      isLoading = false;
    });
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
              CustomButtonNoIcon(
                label: "Submit Report",
                onPressed: () {
                  if (widget.year == null ||
                      widget.quarter == null ||
                      widget.fname == null ||
                      widget.lname == null ||
                      widget.campus == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Missing information. Cannot submit report."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  showSubmitNcar(
                    context,
                    year: widget.year!,
                    quarter: widget.quarter!,
                    name: "${widget.fname} ${widget.lname}",
                    campus: widget.campus!,
                    office: widget.office,
                  );
                },
              )
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
