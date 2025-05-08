import 'package:css_website_access/pages/login/login-contents/authentication.dart';
import 'package:flutter/material.dart';
import 'package:css_website_access/pages/login/login-contents/login_email.dart';
import 'package:css_website_access/pages/login/login-contents/login_password.dart';
import 'package:css_website_access/pages/login/login-contents/unrecognize_email.dart';

class RightContent extends StatefulWidget {
  final double height;
  final double width;
  const RightContent({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  State<RightContent> createState() => _RightContentState();
}

class _RightContentState extends State<RightContent> {
  final PageController controller = PageController();
  String? email = "";
  String? password = "";

  void navigateToNextPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void navigateToPreviousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void navigateToPage(int pageIndex) {
    controller.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void saveEmail(String email) {
    setState(() {
      this.email = email;
    });
    navigateToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          LoginEmail(
            width: widget.width,
            onInvalidEmail: () {
              navigateToPage(2);
            },
            onValidEmail: (email) {
              debugPrint('Email from LoginEmail: $email');
              saveEmail(email);
            },
          ),
          LoginPassword(
            email: email,
            width: widget.width,
            onBack: navigateToPreviousPage,
            onInvalidPassword: () {
              navigateToPage(2);
            },
            onNext: () => {
              navigateToPage(3),
            },
          ),
          UnrecognizeEmail(
            width: widget.width,
            onPressed: () => navigateToPage(0),
          ),
          Authentication(
            width: widget.width,
            email: email,
          ),
        ],
      ),
    );
  }
}
