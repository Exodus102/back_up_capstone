import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';
import 'package:css_website_access/pages/data-responses/upload_services.dart';

void showUploadDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool isUploading = false;

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
                                "svg/icons/cloud-upload.svg",
                                color: const Color(0xFF064089),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Upload CSV/XLS File",
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
                          "Please select and upload a CSV/XLS file containing your data.",
                          style: TextStyle(
                            height: 1,
                            color: const Color(0xFF48494A),
                          ),
                        ),
                        Text(
                          "Make sure your file meets the following requirements:",
                          style: TextStyle(
                            color: const Color(0xFF48494A),
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildRequirementTile(
                            "File Format:", "CSV (.csv) or XLS (.xls)"),
                        _buildRequirementTile("Required Fields:",
                            "Must follow the table heading"),
                        _buildRequirementTile("Encoding:", "UTF-8 recommended"),
                        _buildRequirementTile("Delimiter:",
                            "Use commas or excel sheets to separate fields"),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: isUploading
                              ? null
                              : () {
                                  pickAndUploadFile(
                                    context,
                                    onStart: () =>
                                        setState(() => isUploading = true),
                                    onComplete: () =>
                                        setState(() => isUploading = false),
                                  );
                                },
                          child: DottedBorder(
                            color: Colors.grey,
                            strokeWidth: 2,
                            dashPattern: [6, 3],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(8),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xFFCBD8E1)),
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: isUploading
                                    ? const CircularProgressIndicator()
                                    : const Column(
                                        children: [
                                          Icon(Icons.cloud_upload,
                                              size: 40,
                                              color: Color(0xFF7B8186)),
                                          SizedBox(height: 8),
                                          Text(
                                            "Upload a file or drag and drop",
                                            style: TextStyle(
                                                color: Color(0xFF7B8186)),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
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
    },
  );
}

Widget _buildRequirementTile(String title, String content) {
  return ListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    title: Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Color(0xFF48494A),
            height: 1,
          ),
          children: [
            TextSpan(
                text: title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: " $content"),
          ],
        ),
      ),
    ),
  );
}
