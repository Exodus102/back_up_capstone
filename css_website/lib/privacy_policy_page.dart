import 'package:flutter/material.dart';
import 'package:css_website/header/title_survey_logo.dart';
import '../terms_of_services_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF07326A), Color(0xFF063F87)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TitleSurveyLogo(),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF07326A),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF07326A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Privacy Policy Content
                          Text(
                            "Privacy Policy for Customer Satisfaction Survey System",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            "University of Rizal System",
                            style: TextStyle(fontSize: 14),
                          ),
                           const SizedBox(height: 10),
                          Text(
                            "Effective Date: 17/11/2024",
                             style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "The University of Rizal System is committed to protecting the privacy of its students, staff, and other stakeholders who participate in the Customer Satisfaction Survey System. This Privacy Policy outlines how we collect, use, and safeguard your personal data in compliance with applicable data protection laws.\n", // Add full text here
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "1. Data We Collect",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          Text(
                            "We collect the following types of data through the Customer Satisfaction Survey System:",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "• Personal Information (optional unless specified):\n"
                            "  - Name\n"
                            "  - Contact information (email, phone number)\n"
                            "• Survey Responses:\n"
                            "  - Ratings and feedback on university services\n"
                            "  - Comments and suggestions\n"
                            "• System Data:\n"
                            "  - Device information (e.g., IP address, browser type)\n"
                            "  - Date and time of survey submission",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "2. Purpose of Data Collection",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          Text(
                            "The data collected through the Customer Satisfaction Survey System will be used for the following purposes:\n"
                            "- To assess and improve the quality of services offered by URS.\n"
                            "- To identify areas requiring improvement.\n"
                            "- To ensure accountability and responsiveness to stakeholders.\n"
                            "- For research and statistical analysis aimed at enhancing user satisfaction.",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "3. Legal Basis for Processing",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          Text(
                            "The processing of your data is based on your consent, which is obtained when you voluntarily participate in the survey. "
                            "In cases where your data is used for academic research or statistical purposes, it will be anonymized to protect your identity.",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "4. Data Sharing and Disclosure",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          Text(
                            "We do not sell, trade, or share your personal data with third parties, except in the following situations:\n"
                            "- With your consent: If explicit permission is given for specific purposes.\n"
                            "- With authorized URS personnel: Data may be shared internally to improve university services.\n"
                            "- As required by law: If disclosure is necessary to comply with legal obligations or protect rights.",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "5. Data Security",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          Text(
                            "The University of Rizal System employs robust security measures to protect your data, including:\n"
                            "- Encryption of sensitive data during transmission.\n"
                            "- Restricted access to data based on user roles.\n"
                            "- Regular system updates and vulnerability assessments.",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "6. Data Retention",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          Text(
                            "We will retain your data only as long as necessary to fulfill the purposes outlined in this policy or as required by law. "
                            "Survey responses are anonymized and stored for statistical purposes after the original purpose is achieved.",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "7. Your Rights",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          Text(
                            "As a survey participant, you have the following rights:\n"
                            "- Right to Access: Request access to your personal data and survey responses.\n"
                            "- Right to Rectification: Correct inaccuracies in your personal data.\n"
                            "- Right to Erasure: Request deletion of your personal data, subject to legal or contractual obligations.\n"
                            "- Right to Object: Opt-out of non-essential data processing.\n"
                            "- Right to Data Portability: Request a copy of your data in a machine-readable format.\n"
                            "For inquiries or to exercise your rights, please contact:\nData Protection Officer (DPO)\nUniversity of Rizal System\nEmail: [Insert Email Address]\nPhone: [Insert Phone Number]",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "8. Cookies and Tracking Technologies",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          Text(
                            "The survey system may use cookies to improve your experience. Cookies collect non-identifiable information such as browser type, "
                            "session duration, and navigation patterns. You can disable cookies through your browser settings.",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "9. Updates to This Privacy Policy",
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                          ),
                          Text(
                            "The University of Rizal System may update this Privacy Policy to reflect changes in legal, technical, or operational requirements. "
                            "We encourage participants to review this policy periodically.\n\n"
                            "By participating in the Customer Satisfaction Survey System, you acknowledge that you have read and understood this Privacy Policy "
                            "and consent to the processing of your data as described herein.\n\n"
                            "For further information, contact:\nUniversity of Rizal System\nData Control Center (DCC)\nursdcc@urs.edu.ph",
                            style: TextStyle(fontSize: 14),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "© University of Rizal System - Customer Satisfaction Survey System",
                        style: TextStyle(color: Color(0xFFF1F7F9)),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Privacy Policy",
                            style: TextStyle(
                              color: Color(0xFFF1F7F9),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFF1F7F9),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TermsOfServicesPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Terms of Services",
                            style: TextStyle(
                              color: Color(0xFFF1F7F9),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFF1F7F9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
