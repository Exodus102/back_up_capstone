import 'package:css_website_access/pages/login/login-contents/terms_of_services_and_privacy_policy.dart';
import 'package:css_website_access/pages/login/privacy-policy/privacy_policy.dart';
import 'package:css_website_access/pages/login/terms-of-services/terms_of_services.dart';
import 'package:css_website_access/widgets/custom_button_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UnrecognizeEmail extends StatefulWidget {
  final double width;
  final VoidCallback onPressed;
  const UnrecognizeEmail({
    super.key,
    required this.width,
    required this.onPressed,
  });

  @override
  State<UnrecognizeEmail> createState() => _UnrecognizeEmailState();
}

class _UnrecognizeEmailState extends State<UnrecognizeEmail> {
  bool showTermsOfServices = false;
  bool showPrivacyPolicy = false;
  void buttonClick() {
    widget.onPressed();
  }

  void toggleTermsOfServices() {
    setState(() {
      showTermsOfServices = !showTermsOfServices;
    });
  }

  void togglePrivacyPolicy() {
    setState(() {
      showPrivacyPolicy = !showPrivacyPolicy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.width * 0.1,
          vertical: widget.width * 0.2,
        ),
        child: Column(
          children: [
            if (showTermsOfServices) ...[
              TermsOfServices(
                width: widget.width,
                onBack: toggleTermsOfServices,
              )
            ] else if (showPrivacyPolicy) ...[
              PrivacyPolicy(
                width: widget.width,
                onBack: togglePrivacyPolicy,
              )
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("svg/Logo.svg"),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "URSatisfaction",
                        style: TextStyle(
                          height: 1,
                          color: Color(0xFF064089),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        "We comply so URSatisfy",
                        style: TextStyle(
                          height: 1,
                          color: Color(0xFF1E1E1E),
                          fontSize: 15,
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: widget.width * 0.09,
              ),
              Text(
                "No Account Found",
                style: TextStyle(
                  color: Color(0xFF064089),
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              Text(
                "We couldn’t find an account that matches the information you entered. Please double-check your details and try again.",
                style: TextStyle(
                  color: Color(0xFF474849),
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButtonLogin(
                  width: widget.width * 0.25,
                  label: "Try Again",
                  onPressed: buttonClick,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Spacer(),
              TermsOfServicesAndPrivacyPolicy(
                onTermsOfServicesTap: toggleTermsOfServices,
                onPrivacyPolicyTap: togglePrivacyPolicy,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
