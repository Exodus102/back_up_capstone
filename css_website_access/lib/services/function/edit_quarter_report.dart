import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<Uint8List?> modifyPdf(String? year, String? quarter) async {
  try {
    // Load the existing PDF from assets
    final ByteData data =
        await rootBundle.load("assets/pdf/reports/CSS_Report_Template.pdf");
    final Uint8List pdfData = data.buffer.asUint8List();

    // Load the PDF document
    final PdfDocument document = PdfDocument(inputBytes: pdfData);

    // Get the first page and graphics
    final PdfPage page = document.pages[0];
    final PdfGraphics graphics = page.graphics;

    // Load "Bookman Old Style" font from assets
    final ByteData fontData = await rootBundle
        .load("fonts/bookman-old-style/BookmanOldStyleBold.ttf");
    final Uint8List fontBytes = fontData.buffer.asUint8List();
    final PdfFont bookOldFont = PdfTrueTypeFont(fontBytes, 26);

    // Quarter details mapping
    final Map<String, String> quarterDetails = {
      "1st Quarter": "JANUARY TO MARCH",
      "2nd Quarter": "APRIL TO JUNE",
      "3rd Quarter": "JULY TO SEPTEMBER",
      "4th Quarter": "OCTOBER TO DECEMBER"
    };

    // Fetch quarter and month range
    final String quarterText =
        quarter?.split(" ").take(2).join(" ") ?? "";
    final String monthsText = quarterDetails[quarterText] ?? "";
    final String yearText = year ?? "";

    // Combine month and year in one line
    final String monthsAndYear = "$monthsText $yearText";

    // Get page width for centering
    double pageWidth = page.getClientSize().width;
    double xPosition = pageWidth / 2;

    // Draw "1st Quarter" in Bookman Old Style
    Size quarterSize = bookOldFont.measureString(quarterText);
    graphics.drawString(
      quarterText,
      bookOldFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(
          xPosition - (quarterSize.width / 2), 372, quarterSize.width, 50),
    );

    // Draw "JANUARY TO MARCH 2024" in Bookman Old Style
    Size monthsYearSize = bookOldFont.measureString(monthsAndYear);
    graphics.drawString(
      monthsAndYear,
      bookOldFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(xPosition - (monthsYearSize.width / 2), 402,
          monthsYearSize.width, 50),
    );

    // Save the modified PDF to memory
    List<int> bytes = await document.save();
    document.dispose();

    return Uint8List.fromList(bytes);
  } catch (e) {
    print("Error modifying PDF: $e");
    return null;
  }
}
