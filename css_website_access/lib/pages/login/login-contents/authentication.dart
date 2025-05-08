import 'package:css_website_access/pages/login/login-contents/show_dialog_resend_code.dart';
import 'package:css_website_access/pages/login/login-contents/splash_screen.dart';
import 'package:css_website_access/pages/login/login-contents/terms_of_services_and_privacy_policy.dart';
import 'package:css_website_access/pages/login/privacy-policy/privacy_policy.dart';
import 'package:css_website_access/pages/login/terms-of-services/terms_of_services.dart';
import 'package:css_website_access/widgets/custom_button_login.dart';
import 'package:css_website_access/widgets/custom_textbutton_login.dart';
import 'package:css_website_access/widgets/custom_textfield_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class Authentication extends StatefulWidget {
  final double width;
  final String? email;
  const Authentication({
    super.key,
    required this.width,
    this.email,
  });

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final TextEditingController codeController = TextEditingController();
  bool showTermsOfServices = false;
  bool showPrivacyPolicy = false;
  int failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    sendVerificationCode();
  }

  void sendVerificationCode() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.104/database/login/authentication.php"),
      body: {"email": widget.email},
    );
    print("this is the response" + response.body);

    if (response.statusCode == 200) {
      print("OTP sent successfully");
    } else {
      print("Failed to send OTP");
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

  bool isLoading = false;
  bool? color;

  void verifyCode() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse("http://192.168.1.104/database/login/verification.php"),
      body: {
        "email": widget.email,
        "code": codeController.text.trim(),
      },
    );

    setState(() {
      isLoading = false;
    });

    print("this is the response for verification:" + response.body);

    if (response.body.contains("Verification successful")) {
      // Reset failed attempts
      failedAttempts = 0;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(
            email: widget.email,
          ),
        ),
      );
    } else {
      setState(() {
        color = true;
      });

      failedAttempts++;
      if (failedAttempts >= 3) {
        // Trigger resend
        sendVerificationCode();
        failedAttempts = 0;
        showDialogResendCode(context);
      }
    }
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
                    "2-Step Verification",
                    style: TextStyle(
                      color: Color(0xFF064089),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  Center(
                    child: Text(
                      "To help keep your account safe, please enter the code sent to your email address to verify it’s you.",
                      style: TextStyle(
                        color: Color(0xFF474849),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextfieldLogin(
                    label: "Enter Code",
                    controller: codeController,
                    color: color,
                    onSubmitted: (_) {
                      if (!isLoading) {
                        verifyCode();
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomTextbuttonLogin(
                      label: "Resend Code",
                      onPressed: () {
                        sendVerificationCode();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButtonLogin(
                      width: widget.width * 0.2,
                      label: "Log in",
                      onPressed: isLoading
                          ? () {
                              null;
                            }
                          : verifyCode,
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
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3), // Semi-transparent background
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF064089), // Match your theme color
              ),
            ),
          ),
      ],
    );
  }
}
