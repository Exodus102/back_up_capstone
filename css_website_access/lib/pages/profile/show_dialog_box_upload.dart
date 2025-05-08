import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

void showDialogBoxUploadProfile(
    BuildContext context, Function(Uint8List?, String?) onFileSelected) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UploadDialog(onFileSelected: onFileSelected);
    },
  );
}

class UploadDialog extends StatefulWidget {
  final Function(Uint8List?, String?) onFileSelected;
  const UploadDialog({super.key, required this.onFileSelected});

  @override
  State<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  DropzoneViewController? _dropzoneController;
  String? fileName;

  Future<void> pickFile() async {
    print("Opening File Picker...");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    );
    if (result != null && result.files.single.bytes != null) {
      print("File Selected: ${result.files.single.name}");
      widget.onFileSelected(
          result.files.single.bytes, result.files.single.name);
      Navigator.of(context).pop();
    } else {
      print("No file selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF1F7F9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
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
                          "Upload New Photo",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF064089),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Update your profile icon.",
                    style: TextStyle(
                      height: 1,
                      color: const Color(0xFF48494A),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dropzone
                  SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        DropzoneView(
                          onCreated: (DropzoneViewController ctrl) {
                            setState(() {
                              _dropzoneController = ctrl;
                            });
                          },
                          onDrop: (dynamic event) async {
                            if (_dropzoneController == null) {
                              print(
                                  "DropzoneController is not initialized yet.");
                              return;
                            }

                            Uint8List? fileData =
                                await _dropzoneController!.getFileData(event);
                            String? name =
                                await _dropzoneController!.getFilename(event);

                            widget.onFileSelected(fileData, name);
                            Navigator.of(context).pop(); // Close dialog
                          },
                        ),
                        Positioned.fill(
                          child: InkWell(
                            onTap: () {
                              print("Pressed");
                              pickFile();
                            },
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 2,
                              dashPattern: [6, 3],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFCBD8E1),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.cloud_upload,
                                          size: 40, color: Color(0xFF7B8186)),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Upload a file or drag and drop",
                                        style: const TextStyle(
                                            color: Color(0xFF7B8186)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
  }
}
