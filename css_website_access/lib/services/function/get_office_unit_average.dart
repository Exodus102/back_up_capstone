import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui';

Future<Uint8List?> getOfficeUnitPdf(
    String? year, String? quarter, Uint8List basePdf) async {
  try {
    // Load existing PDF
    PdfDocument document = PdfDocument(inputBytes: basePdf);

    // Extract text with positions
    PdfTextExtractor extractor = PdfTextExtractor(document);
    List<TextLine> textLines = extractor.extractTextLines();

    // Fetch report data
    Map<String, dynamic> reportData = await fetchReportData(year, quarter);
    String formattedQuarter = formatQuarterKey(quarter);

    // Process only if reportData is available
    if (reportData.isNotEmpty) {
      PdfPage page = document.pages[3];
      PdfGraphics graphics = page.graphics;
      PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 9);

      for (var officeUnit in reportData.keys) {
        var data = reportData[officeUnit];

        if (data != null && data.containsKey(formattedQuarter)) {
          var quarterData = data[formattedQuarter];
          var page5QuarterData = data["page5_$formattedQuarter"];
          var combinedQuarterData = data["combined_$formattedQuarter"];

          if (quarterData != null &&
              quarterData['average'] != "N/A" &&
              quarterData['category'] != "N/A") {
            print(
                "✅ Processing $officeUnit: $quarterData, $page5QuarterData, Combined: $combinedQuarterData");

            // 🔹 Find the position of the office unit text in the PDF
            for (var line in textLines) {
              if (line.text.contains(officeUnit)) {
                double x = line.bounds.left; // X position of the detected word
                double y = line.bounds.top; // Y position of the detected word

                // Draw the extracted values beside the detected word
                graphics.drawString(quarterData['average'].toString(), font,
                    bounds: Rect.fromLTWH(x + 231, y - 1, 50, 20));

                graphics.drawString(quarterData['category'], font,
                    bounds: Rect.fromLTWH(x + 268, y - 1, 50, 20));

                if (page5QuarterData != null &&
                    page5QuarterData['average'] != "N/A" &&
                    page5QuarterData['category'] != "N/A") {
                  graphics.drawString(
                      page5QuarterData['average'].toString(), font,
                      bounds: Rect.fromLTWH(x + 295, y - 1, 50, 20));

                  graphics.drawString(page5QuarterData['category'], font,
                      bounds: Rect.fromLTWH(x + 331, y - 1, 50, 20));
                }

                if (combinedQuarterData != null &&
                    combinedQuarterData['average'] != "N/A" &&
                    combinedQuarterData['category'] != "N/A") {
                  graphics.drawString(
                      combinedQuarterData['average'].toString(), font,
                      bounds: Rect.fromLTWH(x + 360, y - 1, 50, 20));

                  graphics.drawString(combinedQuarterData['category'], font,
                      bounds: Rect.fromLTWH(x + 396, y - 1, 50, 20));
                }

                break; // Stop searching after finding the first occurrence
              }
            }
          }
        }
      }
    } else {
      print("⚠️ Warning: No report data available.");
    }

    // Save and return modified PDF
    Uint8List finalPdf = Uint8List.fromList(document.saveSync());
    document.dispose();
    return finalPdf;
  } catch (e) {
    print("❌ Error modifying PDF: $e");
    return null;
  }
}

// 🔹 API Call to Fetch Report Data
Future<Map<String, dynamic>> fetchReportData(
    String? year, String? quarter) async {
  final response = await http.get(Uri.parse(
      "http://192.168.1.104/database/date/get_quarterly_report.php?year=$year&quarter=$quarter"));

  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);
    print("📄 API Response Data: ${json.encode(data)}");

    if (data is List) {
      Map<String, dynamic> mappedData = {};
      for (var item in data) {
        if (item is Map<String, dynamic> && item.containsKey("officeUnit")) {
          mappedData[item["officeUnit"] ?? "Unknown"] =
              processQuarterData(item);
        }
      }
      return mappedData;
    }

    if (data is Map) {
      Map<String, dynamic> stringData = Map<String, dynamic>.from(data);
      Map<String, dynamic> updatedData = {};

      stringData.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          updatedData[key] = processQuarterData(value);
        } else {
          updatedData[key] = value;
        }
      });

      return updatedData;
    }
  }

  throw Exception("Failed to fetch report data");
}

// 🔹 Process quarterly data, including page5_rating and combined averages
Map<String, dynamic> processQuarterData(Map<String, dynamic> item) {
  return {
    "1st_quarter": extractQuarterData(item, "1st_quarter"),
    "2nd_quarter": extractQuarterData(item, "2nd_quarter"),
    "3rd_quarter": extractQuarterData(item, "3rd_quarter"),
    "4th_quarter": extractQuarterData(item, "4th_quarter"),
    "page5_1st_quarter":
        extractQuarterData(item, "1st_quarter", usePage5: true),
    "page5_2nd_quarter":
        extractQuarterData(item, "2nd_quarter", usePage5: true),
    "page5_3rd_quarter":
        extractQuarterData(item, "3rd_quarter", usePage5: true),
    "page5_4th_quarter":
        extractQuarterData(item, "4th_quarter", usePage5: true),
    "combined_1st_quarter":
        extractQuarterData(item, "1st_quarter", useCombined: true),
    "combined_2nd_quarter":
        extractQuarterData(item, "2nd_quarter", useCombined: true),
    "combined_3rd_quarter":
        extractQuarterData(item, "3rd_quarter", useCombined: true),
    "combined_4th_quarter":
        extractQuarterData(item, "4th_quarter", useCombined: true),
  };
}

// 🔹 Extract quarter data dynamically, considering page5_rating
// 🔹 Extract quarter data dynamically, considering page5_rating and combined_averages
Map<String, String> extractQuarterData(
    Map<String, dynamic> item, String quarterKey,
    {bool usePage5 = false, bool useCombined = false}) {
  return {
    "average": (useCombined
        ? (item["combined_averages"]?[quarterKey]?["average"]?.toString() ??
            "N/A")
        : usePage5
            ? (item["page5_rating"]?[quarterKey]?["average"]?.toString() ??
                "N/A")
            : (item["rating"]?[quarterKey]?["average"]?.toString() ?? "N/A")),
    "category": (useCombined
        ? (item["combined_averages"]?[quarterKey]?["category"]?.toString() ??
            "N/A")
        : usePage5
            ? (item["page5_rating"]?[quarterKey]?["category"]?.toString() ??
                "N/A")
            : (item["rating"]?[quarterKey]?["category"]?.toString() ?? "N/A")),
  };
}

// 🔹 Format quarter key correctly
String formatQuarterKey(String? quarter) {
  if (quarter == null) return "";
  String lowerQuarter = quarter.toLowerCase();

  if (lowerQuarter.contains("1st") || lowerQuarter.contains("q1")) {
    return "1st_quarter";
  }
  if (lowerQuarter.contains("2nd") ||
      lowerQuarter.contains("q2") ||
      lowerQuarter.contains("second")) {
    return "2nd_quarter";
  }
  if (lowerQuarter.contains("3rd") ||
      lowerQuarter.contains("q3") ||
      lowerQuarter.contains("third")) {
    return "3rd_quarter";
  }
  if (lowerQuarter.contains("4th") ||
      lowerQuarter.contains("q4") ||
      lowerQuarter.contains("fourth")) {
    return "4th_quarter";
  }

  return "";
}
