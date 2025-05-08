import 'dart:convert';

import 'package:css_website_access/pages/login/login-contents/decodebase64image.dart';
import 'package:css_website_access/pages/login/login-contents/show_password_dialog.dart';
import 'package:css_website_access/pages/login/login-contents/terms_of_services_and_privacy_policy.dart';
import 'package:css_website_access/pages/login/privacy-policy/privacy_policy.dart';
import 'package:css_website_access/pages/login/terms-of-services/terms_of_services.dart';
import 'package:css_website_access/services/login-services/login_password_services.dart';
import 'package:css_website_access/services/login-services/verify_login.dart';
import 'package:css_website_access/widgets/custom_button_login.dart';
import 'package:css_website_access/widgets/custom_checkbox.dart';
import 'package:css_website_access/widgets/custom_textbutton_login.dart';
import 'package:css_website_access/widgets/custom_textfield_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class LoginPassword extends StatefulWidget {
  final double width;
  final VoidCallback onBack;
  final String? email;
  final VoidCallback onInvalidPassword;
  final VoidCallback onNext;
  const LoginPassword({
    super.key,
    required this.width,
    required this.onBack,
    this.email,
    required this.onInvalidPassword,
    required this.onNext,
  });

  @override
  State<LoginPassword> createState() => _LoginPasswordState();
}

class _LoginPasswordState extends State<LoginPassword> {
  bool isVerifying = false;
  bool isPasswordVisible = false;
  String? name;
  bool isLoading = true;
  String? imageBase64;
  bool showTermsOfServices = false;
  bool showPrivacyPolicy = false;
  bool? color;
  bool isSendingResetCode = false;

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchName();
  }

  Future<void> fetchName() async {
    final email = widget.email;
    if (email != null && email.isNotEmpty) {
      final authService = LoginPasswordServices();
      try {
        final userData = await authService.fetchUserData(email);
        setState(() {
          if (userData != null) {
            name = userData['fname'];
            imageBase64 = userData['image'];
          } else {
            name = "User not found";
            imageBase64 = null;
          }
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          name = "Failed to fetch data";
          imageBase64 = null;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        name = "Invalid email";
        isLoading = false;
      });
    }
  }

  void onBack() {
    widget.onBack();
  }

  void onNext() async {
    if (widget.email == null || widget.email!.isEmpty) return;
    setState(() {
      isVerifying = true;
    });

    String enteredPassword = _passwordController.text;
    final authService = VerifyLogin();

    bool isAuthenticated =
        await authService.verifyCredentials(widget.email!, enteredPassword);

    setState(() {
      isVerifying = false;
    });

    if (isAuthenticated) {
      widget.onNext();
    } else {
      setState(() {
        color = true;
      });
    }
  }

  void showPassword(bool isChecked) {
    setState(() {
      isPasswordVisible = isChecked;
    });
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

  Future<void> sendResetCode(String email) async {
    setState(() {
      isSendingResetCode = true; // Set loading state to true
    });
    final response = await http.post(
      Uri.parse('http://192.168.1.104/database/login/send_password_code.php'),
      body: {'email': email},
    );
    print("Reset Password code sent to: ${response.body}");

    final data = jsonDecode(response.body);
    setState(() {
      isSendingResetCode = false; // Set loading state to false after response
    });
    if (data['success'] != null) {
      showUploadDialogForgotPass(context, email);
    } else {
      // You can show an error message using a dialog or snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['error'] ?? 'Something went wrong')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F7F9),
      appBar: showTermsOfServices || showPrivacyPolicy
          ? null
          : AppBar(
              backgroundColor: Color(0xFFF1F7F9),
              title: IconButton(
                onPressed: onBack,
                icon: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF064089),
                ),
              ),
            ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.width * 0.1,
                right: widget.width * 0.1,
                bottom: 60,
                top: (showTermsOfServices || showPrivacyPolicy)
                    ? widget.width * 0.2
                    : 0,
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
                    SizedBox(
                      height: widget.width * 0.09,
                    ),
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
                      height: widget.width * 0.05,
                    ),
                    isLoading
                        ? CircularProgressIndicator()
                        : decodeBase64Image(imageBase64),
                    SizedBox(
                      height: widget.width * 0.05,
                    ),
                    Text(
                      isLoading
                          ? "Loading..."
                          : "Welcome, ${name ?? widget.email}",
                      style: TextStyle(
                        color: Color(0xFF064089),
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    CustomeTextButtonLoginPassword(onPressed: onBack),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextfieldLogin(
                      label: "Password",
                      isObscure: !isPasswordVisible,
                      controller: _passwordController,
                      color: color,
                      onSubmitted: (_) => onNext(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomCheckbox(
                          isChecked: isPasswordVisible,
                          onChanged: showPassword,
                        ),
                        CustomTextbuttonLogin(
                          label: "Forgot Password",
                          onPressed: () {
                            if (widget.email != null &&
                                widget.email!.isNotEmpty) {
                              sendResetCode(widget.email!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Email is required to reset password')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButtonLogin(
                        label: "Next",
                        width: widget.width * 0.2,
                        onPressed: onNext,
                      ),
                    ),
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
          if (isVerifying)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          if (isSendingResetCode)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
