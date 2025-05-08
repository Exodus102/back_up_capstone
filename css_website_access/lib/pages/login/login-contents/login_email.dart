import 'package:css_website_access/pages/login/login-contents/terms_of_services_and_privacy_policy.dart';
import 'package:css_website_access/pages/login/privacy-policy/privacy_policy.dart';
import 'package:css_website_access/pages/login/terms-of-services/terms_of_services.dart';
import 'package:css_website_access/services/login-services/login_email_services.dart';
import 'package:css_website_access/widgets/custom_button_login.dart';
import 'package:css_website_access/widgets/custom_textfield_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginEmail extends StatefulWidget {
  final double width;
  final Function(String email) onValidEmail;
  final VoidCallback onInvalidEmail;

  const LoginEmail({
    super.key,
    required this.width,
    required this.onValidEmail,
    required this.onInvalidEmail,
  });

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  TextEditingController emailController = TextEditingController();
  bool showTermsOfServices = false;
  bool showPrivacyPolicy = false;
  bool isLoading = false;

  void buttonClick() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text;

    try {
      bool isEmailRegistered = await checkEmailRegistered(email);

      if (isEmailRegistered) {
        widget.onValidEmail(email);
      } else {
        widget.onInvalidEmail();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify your email or username')),
      );
      print("Fatal Error: $error");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: widget.width * 0.1,
              right: widget.width * 0.1,
              top: widget.width * 0.2,
              bottom: 60,
            ),
            child: Column(
              children: [
                if (showTermsOfServices) ...[
                  TermsOfServices(
                    width: widget.width,
                    onBack: toggleTermsOfServices,
                  ),
                ] else if (showPrivacyPolicy) ...[
                  PrivacyPolicy(
                    width: widget.width,
                    onBack: togglePrivacyPolicy,
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("svg/Logo.svg"),
                      SizedBox(width: 20),
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
                  SizedBox(height: widget.width * 0.09),
                  Text(
                    "Log In",
                    style: TextStyle(
                      color: Color(0xFF064089),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  Text(
                    "Using your URS email account or username",
                    style: TextStyle(
                      color: Color(0xFF474849),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextfieldLogin(
                    label: "Email or Username",
                    controller: emailController,
                    onSubmitted: (_) => buttonClick(),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButtonLogin(
                      width: widget.width * 0.2,
                      label: "Next",
                      onPressed: buttonClick,
                    ),
                  ),
                  SizedBox(height: 10),
                  Spacer(),
                  TermsOfServicesAndPrivacyPolicy(
                    onTermsOfServicesTap: toggleTermsOfServices,
                    onPrivacyPolicyTap: togglePrivacyPolicy,
                  ),
                ],
              ],
            ),
          ),
        ),

        // Full-screen loading overlay
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
