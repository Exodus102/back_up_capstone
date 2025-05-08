import 'package:css_website_access/widgets/custom_button.dart';
import 'package:css_website_access/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

class QrGeneration extends StatefulWidget {
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  const QrGeneration({
    super.key,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
  });

  @override
  QrGenerationState createState() => QrGenerationState();
}

class QrGenerationState extends State<QrGeneration> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();
  String _qrData = "";
  Color _qrColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;
      double remainingHeight = height - (100 + 40);

      return Column(
        children: [
          CustomHeader(
            label: "QR Generation",
            fname: widget.fname,
            lname: widget.lname,
            profileImage: widget.profileImage,
            redirectPage: widget.redirectPage,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: width,
              height: remainingHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
                color: Color(0xFFF1F7F9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Generated Link and QR Code",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_qrData.isNotEmpty)
                        RepaintBoundary(
                          key: _qrKey,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: _qrColor, width: 1),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                QrImageView(
                                  data: _qrData,
                                  version: 15,
                                  size: 400.0,
                                  eyeStyle: QrEyeStyle(
                                    eyeShape: QrEyeShape.circle,
                                    color: _qrColor,
                                  ),
                                  dataModuleStyle: QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.square,
                                    color: _qrColor,
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    width: 40,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/logo2.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                            border: Border.all(color: _qrColor, width: 1),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildColorButton(Color(0xFF064089), "Black"),
                            SizedBox(width: 8),
                            _buildColorButton(Color(0xFFFF9D5C), "Red"),
                            SizedBox(width: 8),
                            _buildColorButton(Color(0xFFCC8484), "Blue"),
                            SizedBox(width: 8),
                            _buildColorButton(Color(0xFF87A34F), "Green"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Enter URL",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          cursorColor: Color(0xFF064089),
                          controller: _controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF064089),
                                width: 2,
                              ),
                            ),
                            hintText: 'Enter link',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 250,
                        child: CustomButton(
                          label: "Generate QR Code",
                          svgPath: 'svg/icons/scan-qr-code.svg',
                          onPressed: () {
                            setState(() {
                              _qrData = _controller.text;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 250,
                        child: CustomButton(
                          label: "Download",
                          svgPath: 'svg/icons/download-bottom.svg',
                          onPressed: () async {
                            RenderRepaintBoundary boundary =
                                _qrKey.currentContext!.findRenderObject()
                                    as RenderRepaintBoundary;
                            ui.Image image = await boundary.toImage();
                            ByteData? byteData = await image.toByteData(
                                format: ui.ImageByteFormat.png);
                            Uint8List imageBytes =
                                byteData!.buffer.asUint8List();

                            final blob = html.Blob([imageBytes], 'image/jpeg');
                            final url = html.Url.createObjectUrlFromBlob(blob);
                            final anchor = html.AnchorElement(href: url)
                              ..setAttribute('download', 'css_qr.jpeg')
                              ..click();
                            html.Url.revokeObjectUrl(url);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildColorButton(Color color, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _qrColor = color;
        });
      },
      child: Container(
        width: 60,
        height: 90,
        decoration: BoxDecoration(
          color: Color(0xFFF1F7F9),
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              'svg/icons/scan-qr-code.svg',
              width: 30,
              height: 30,
              color: color,
            ),
            SizedBox(
              width: 20,
              height: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: color,
                ),
                onPressed: () {
                  setState(() {
                    _qrColor = color;
                  });
                },
                child: SizedBox(width: 10, height: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
