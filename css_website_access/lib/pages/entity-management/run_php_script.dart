import 'package:css_website_access/widgets/custom_button_no_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class PhpScript {
  // Accept BuildContext in order to display UI dialog
  static Future<void> runPhpScript(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.104/database/questionaire/insert_static_section.php'));

      if (response.statusCode == 200) {
        print("PHP script executed successfully");

        showUploadDialog(context);
      } else {
        print("Failed to execute PHP script: ${response.statusCode}");
      }
    } catch (e) {
      print("Error executing PHP script: $e");
    }
  }
}

void showUploadDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFF1F7F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "svg/icons/sucess.svg",
                            color: const Color(0xFF064089),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Import Success",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF064089),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Changes are saved successfully.",
                      style: TextStyle(
                        height: 1,
                        color: const Color(0xFF48494A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButtonNoIcon(
                      label: "Close",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
