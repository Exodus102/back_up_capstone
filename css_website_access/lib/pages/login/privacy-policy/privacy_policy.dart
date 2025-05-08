import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrivacyPolicy extends StatelessWidget {
  final double width;
  final VoidCallback onBack;

  const PrivacyPolicy({
    super.key,
    required this.width,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appBarHeight = kToolbarHeight + 40;

    double additionalHeight = screenWidth >= 2560 ? 144 : 0;

    double remainingHeight =
        screenHeight - appBarHeight - 71 - additionalHeight - 0.520;

    return SizedBox(
      height: remainingHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: onBack,
              ),
              Expanded(
                child: Row(
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
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(width: 48),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      color: Color(0xFF064089),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "Privacy Policy for Customer Satisfaction Survey System\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: "University of Rizal System",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Effective Date: 17/11/2024",
                    style: TextStyle(
                      color: Color(0xFF064089),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "The University of Rizal System is committed to protecting the privacy of its students, staff, and other stakeholders who participate in the Customer Satisfaction Survey System. This Privacy Policy outlines how we collect, use, and safeguard your personal data in compliance with applicable data protection laws.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "1. Data We Collect\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text:
                              "We collect the following types of data through the Customer Satisfaction Survey System:\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " 1. Personal Information (optional unless specified):\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "      • Name\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              "      • Contact information (email, phone number)\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: " 2. Survey Responses:\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              "      • Ratings and feedback on university services\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "      • Comments and suggestions\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: " 3. System Data:\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              "      • Device information (e.g., IP address, browser type)\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "      • Date and time of survey submission",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "2. Purpose of Data Collection\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text:
                              "The data collected through the Customer Satisfaction Survey System will be used for the following purposes:\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • To assess and improve the quality of services offered by URS.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: " • To identify areas requiring improvement.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • To ensure accountability and responsiveness to stakeholders.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • For research and statistical analysis aimed at enhancing user satisfaction.",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "3. Legal Basis for Processing\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text:
                              "The processing of your data is based on your consent, which is obtained when you voluntarily participate in the survey. In cases where your data is used for academic research or statistical purposes, it will be anonymized to protect your identity.",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "4. Data Sharing and Disclosure\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text:
                              "We do not sell, trade, or share your personal data with third parties, except in the following situations:\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • With your consent: If explicit permission is given for specific purposes.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • With authorized URS personnel: Data may be shared internally to improve university services.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • As required by law: If disclosure is necessary to comply with legal obligations or protect rights.",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "5. Data Security\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text:
                              "The University of Rizal System employs robust security measures to protect your data, including:\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Encryption of sensitive data during transmission.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Restricted access to data based on user roles.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Regular system updates and vulnerability assessments.",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "6. Data Retention\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text:
                              "We will retain your data only as long as necessary to fulfill the purposes outlined in this policy or as required by law. Survey responses are anonymized and stored for statistical purposes after the original purpose is achieved.",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "7. Your Rights\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text:
                              "As a survey participant, you have the following rights:\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Right to Access: Request access to your personal data and survey responses.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Right to Rectification: Correct inaccuracies in your personal data.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Right to Erasure: Request deletion of your personal data, subject to legal or contractual obligations.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Right to Object: Opt-out of non-essential data processing.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Right to Data Portability: Request a copy of your data in a machine-readable format.\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
