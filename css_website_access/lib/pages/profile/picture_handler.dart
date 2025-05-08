import 'dart:typed_data';
import 'package:css_website_access/pages/profile/profile_service.dart';
import 'package:css_website_access/pages/profile/show_dialog_box_error.dart';
import 'package:css_website_access/pages/profile/show_dialog_box_success.dart';
import 'package:css_website_access/pages/profile/show_dialog_box_upload.dart';
import 'package:css_website_access/pages/profile/upload_photo_button.dart';
import 'package:flutter/material.dart';

class PictureHandler extends StatefulWidget {
  final String email;
  final Uint8List? profileImage;
  const PictureHandler({
    super.key,
    required this.email,
    this.profileImage,
  });

  @override
  State<PictureHandler> createState() => _PictureHandlerState();
}

class _PictureHandlerState extends State<PictureHandler> {
  Uint8List? profileImage;

  void _updateProfileImage(Uint8List? image, String? fileName) async {
    if (image != null) {
      setState(() {
        profileImage = image;
      });

      bool success =
          await ProfileService.uploadProfileImage(widget.email, image);

      if (success) {
        showDialogBoxSuccess(context);
      } else {
        showDialogBoxError(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: widget.profileImage != null
                    ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF474747),
                            width: 3,
                          ),
                        ),
                        child: Image.memory(
                          widget.profileImage!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.account_circle,
                          size: 90,
                          color: Colors.grey[700],
                        ),
                      ),
              ),
              SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload a new photo",
                    style: TextStyle(
                      color: Color(0xFF064089),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Update profile icon",
                  ),
                ],
              ),
            ],
          ),
          UploadPhotoButton(
            onPressed: () {
              showDialogBoxUploadProfile(context, _updateProfileImage);
            },
          ),
        ],
      ),
    );
  }
}
