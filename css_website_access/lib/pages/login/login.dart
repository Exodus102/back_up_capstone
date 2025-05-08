import 'package:css_website_access/pages/login/login-contents/left_content.dart';
import 'package:css_website_access/pages/login/login-contents/right_content.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F7F9),
      body: LayoutBuilder(
        builder: (context, BoxConstraints constrains) {
          double width = constrains.maxWidth;
          double height = constrains.maxHeight;

          return Row(
            children: [
              SizedBox(
                width: width * 0.65,
                height: height,
                child: LeftContent(
                  width: width,
                  height: height,
                ),
              ),
              RightContent(
                width: width * 0.35,
                height: height,
              ),
            ],
          );
        },
      ),
    );
  }
}
