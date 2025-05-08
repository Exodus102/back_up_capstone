import 'package:css_website_access/pages/reports/show_submit_report_director.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:css_website_access/pages/reports/submit_report_dialog.dart';
import 'package:http/http.dart' as http;

class DccViewReports extends StatefulWidget {
  final VoidCallback onBack;
  final String? year;
  final String? quarter;
  final String? fname;
  final String? lname;
  final String? campus;

  const DccViewReports({
    super.key,
    required this.onBack,
    this.year,
    this.quarter,
    this.fname,
    this.lname,
    this.campus,
  });

  @override
  ViewReportPageState createState() => ViewReportPageState();
}

class ViewReportPageState extends State<DccViewReports> {
  String? pdfUrl;
  bool isLoading = true;
  String? pdfErrorMessage;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    final url =
        "http://192.168.1.104/database/files/director_file_view.php?year=${widget.year}&quarter=${widget.quarter}&campus=${widget.campus}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 &&
        response.headers['content-type'] == 'application/pdf') {
      setState(() {
        pdfUrl = url;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        pdfErrorMessage = response.body.contains("Report not submitted yet")
            ? "This report has not been submitted yet."
            : "Failed to load PDF file.";
      });
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
                    "${widget.year} ${widget.quarter}",
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
                    : Center(
                        child: Text(
                          pdfErrorMessage ?? 'No report available.',
                          style: const TextStyle(
                            fontSize: 30,
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
          ),
        ],
      );
    });
  }
}
