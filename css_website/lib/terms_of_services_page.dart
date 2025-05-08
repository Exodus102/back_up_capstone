import 'package:flutter/material.dart';
import 'package:css_website/header/title_survey_logo.dart';
import '../privacy_policy_page.dart';

class TermsOfServicesPage extends StatelessWidget {
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
                                "Terms of Services",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF063F87),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 14, color: Colors.black),
                              children: [
                                TextSpan(text: "The "),
                                TextSpan(
                                  text: "URSatisfaction: Customer Satisfaction Survey System for University of Rizal System",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
                                ),
                                TextSpan(
                                  text:
                                      " is developed to collect and evaluate feedback from stakeholders, including students, faculty, staff, and other users of university services.\n\nBy accessing and using URSatisfaction, you ",
                                ),
                                TextSpan(
                                  text: "agree to abide by these Terms of Service",
                                  style: TextStyle(
                                      color: Color(0xFF063F87), decoration: TextDecoration.underline),
                                ),
                                TextSpan(
                                    text:
                                        ", which outline the rights and responsibilities of users and the university."),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          buildSectionTitle("1. Acceptance of Terms"),
                          buildParagraph(
                            "By accessing and participating in URSatisfaction, you agree to be bound by these Terms of Service. If you do not agree with these terms, you may not participate in the survey system.",
                          ),
                          buildSectionTitle("2. Purpose of the System"),
                          buildBulletList([
                            "Gather feedback to evaluate the performance of university services, facilities, and programs.",
                            "Enhance the quality of services provided by URS using survey results.",
                            "Ensure anonymity and confidentiality to safeguard respondent identity and trust.",
                          ]),
                          buildSectionTitle("3. User Responsibilities"),
                          buildBulletList([
                            "Provide honest and constructive feedback to improve university services.",
                            "Refrain from submitting offensive, defamatory, or inappropriate responses.",
                            "Avoid providing false or misleading information.",
                            "URS reserves the right to remove or disregard feedback that violates these responsibilities.",
                          ]),
                          buildSectionTitle("4. Privacy and Data Security"),
                          buildSubPoint("1. Data Collection", "URSatisfaction collects survey responses and limited personal information for analytical and service-improvement purposes."),
                          buildSubPoint("2. Anonymity", "All responses are treated confidentially and anonymously unless the respondent explicitly chooses to disclose their identity."),
                          buildSubPoint("3. Use of Data", "Data collected through URSatisfaction will be used exclusively for institutional improvement and will not be shared with unauthorized third parties."),
                          buildSubPoint("4. Data Protection", "The University of Rizal System implements robust security measures to protect survey data from unauthorized access or breaches."),
                          buildSectionTitle("5. Intellectual Property"),
                          buildBulletList([
                            "URSatisfaction, including its software, content, and generated reports, is the intellectual property of the University of Rizal System.",
                            "Unauthorized reproduction, distribution, or modification of the system or its contents is strictly prohibited.",
                          ]),
                          buildSectionTitle("6. Limitations of Liability"),
                          buildBulletList([
                            "The University of Rizal System does not guarantee the accuracy, completeness, or reliability of survey responses.",
                            "URS will not be held responsible for issues arising from the misuse of URSatisfaction by users.",
                          ]),
                          buildSectionTitle("7. Termination of Use"),
                          buildBulletList([
                            "URS reserves the right to terminate or suspend access to URSatisfaction for users who:",
                            "• Violate these Terms of Service.",
                            "• Engage in fraudulent, inappropriate, or abusive activities while using the system.",
                          ]),
                          buildSectionTitle("8. Updates to Terms"),
                          buildParagraph(
                            "The University of Rizal System may modify or update these Terms of Service at any time. Users will be notified of significant changes, and continued use of URSatisfaction constitutes acceptance of the updated terms.",
                          ),
                          buildSectionTitle("9. Contact Information"),
                          buildParagraph(
                            "For questions, concerns, or feedback about URSatisfaction or these Terms of Service, please contact:\n\n"
                            "Office of the University President\n"
                            "University of Rizal System\n"
                            "officeofthepresident@urs.edu.ph\n"
                            "09182739109",
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "By participating in URSatisfaction, you acknowledge that you have read, understood, and agreed to these Terms of Service.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF063F87),
                            ),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrivacyPolicyPage(),
                              ),
                            );
                          },
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

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF063F87),
        ),
      ),
    );
  }

  Widget buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildSubPoint(String subtitle, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(
              text: "$subtitle: ",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF063F87)),
            ),
            TextSpan(text: content),
          ],
        ),
      ),
    );
  }
}
