import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:css_website_access/pages/reports/submit_report_dialog.dart';
import 'package:http/http.dart' as http;

class ViewReportPage extends StatefulWidget {
  final VoidCallback onBack;
  final String? year;
  final String? quarter;
  final String? fname;
  final String? lname;
  final String? campus;

  const ViewReportPage({
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

class ViewReportPageState extends State<ViewReportPage> {
  String? pdfUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPdfandsave();
  }

  Future<void> loadPdfandsave() async {
    try {
      final String apiUrl =
          "http://192.168.1.104/database/files/get_response.php";

      String fullName = "${widget.fname ?? ''} ${widget.lname ?? ''}".trim();

      await http.post(
        Uri.parse(apiUrl),
        body: {
          'year': widget.year,
          'quarter': widget.quarter,
          'name': fullName,
          'campus': widget.campus,
        },
      );

      setState(() {
        pdfUrl =
            "http://192.168.1.104/database/files/get_report.php?year=${widget.year}&quarter=${widget.quarter}&campus=${widget.campus}";

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
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
              CustomButtonNoIcon(
                label: "Submit Report",
                onPressed: () {
                  showSubmitReportDialog(
                    context,
                    year: widget.year!,
                    quarter: widget.quarter!,
                    name: "${widget.fname} ${widget.lname}",
                    campus: widget.campus!,
                    endorseBy: "Endorse",
                    status: "Pending",
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
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator
                : SfPdfViewer.network(
                    pdfUrl!,
                    onDocumentLoadFailed:
                        (PdfDocumentLoadFailedDetails details) {
                      print("Failed to load PDF: ${details.error}");
                      print("Error Details: ${details.description}");
                    },
                  ),
          ),
        ],
      );
    });
  }
}
