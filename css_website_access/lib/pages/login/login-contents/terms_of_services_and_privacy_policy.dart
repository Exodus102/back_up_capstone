import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsOfServicesAndPrivacyPolicy extends StatelessWidget {
  final VoidCallback? onTermsOfServicesTap;
  final VoidCallback? onPrivacyPolicyTap;
  const TermsOfServicesAndPrivacyPolicy({
    super.key,
    this.onTermsOfServicesTap,
    this.onPrivacyPolicyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "You are agreeing to the ",
          style: const TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 13,
          ),
          children: [
            TextSpan(
              text: "Terms of Services",
              style: const TextStyle(
                color: Color(0xFF064089),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTermsOfServicesTap,
            ),
            const TextSpan(
              text: " and ",
              style: TextStyle(
                color: Color(0xFF1E1E1E),
              ),
            ),
            TextSpan(
              text: "Privacy Policy",
              style: const TextStyle(
                color: Color(0xFF064089),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onPrivacyPolicyTap,
            ),
            const TextSpan(
              text: ".",
              style: TextStyle(
                color: Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
