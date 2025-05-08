import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TermsOfServices extends StatelessWidget {
  final double width;
  final VoidCallback onBack;

  const TermsOfServices({
    super.key,
    required this.width,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appBarHeight = kToolbarHeight + 40;

    double additionalHeight = screenWidth >= 2560 ? 144 : 0.520;

    double remainingHeight =
        screenHeight - appBarHeight - 71 - additionalHeight;

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
                    "Terms of Services",
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
                          text: "The ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              "URSatisfaction: Customer Satisfaction Survey System for University of Rizal System ",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "is developed to collect and evaluate feedback from stakeholders, including students, faculty, staff, and other users of university services.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "By accessing and using URSatisfaction,",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " you agree to abide by these Terms of Service,",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              " which outline the rights and responsibilities of users and the university.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "1. Acceptance of Terms\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text:
                              "By accessing and participating in URSatisfaction, you agree to be bound by these Terms of Service. If you do not agree with these terms, you may not participate in the survey system.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "2. Purpose of the System\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: "URSatisfaction aims to:\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Gather feedback to evaluate the performance of university services, facilities, and programs.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Enhance the quality of services provided by URS using survey results.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Ensure anonymity and confidentiality to safeguard respondent identity and trust.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "3. User Responsibilities\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: "As a user of URSatisfaction, you agree to:\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Provide honest and constructive feedback to improve university services.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Refrain from submitting offensive, defamatory, or inappropriate responses. Avoid providing false or misleading information.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • URS reserves the right to remove or disregard feedback that violates these responsibilities.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "4. Privacy and Data Security\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: " 1. Data Collection:\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              "     • URSatisfaction collects survey responses and limited personal information for analytical and service-improvement purposes.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " 2. Anonymity:\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              "     • All responses are treated confidentially and anonymously unless the respondent explicitly chooses to disclose their identity.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " 3. Use of Data:\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              "     • Data collected through URSatisfaction will be used exclusively for institutional improvement and will not be shared with unauthorized third parties.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " 4. Data Protection:\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              "     • The University of Rizal System implements robust security measures to protect survey data from unauthorized access or breaches.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "5. Intellectual Property\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text:
                              " 1. URSatisfaction, including its software, content, and generated reports, is the intellectual property of the University of Rizal System.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " 2. Unauthorized reproduction, distribution, or modification of the system or its contents is strictly prohibited.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "6. Limitations of Liability\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: "The University of Rizal System:\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Does not guarantee the accuracy, completeness, or reliability of survey responses.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Will not be held responsible for issues arising from the misuse of URSatisfaction by users.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "7. Termination of Use\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text:
                              "URS reserves the right to terminate or suspend access to URSatisfaction for users who:\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " • Violate these Terms of Service.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " • Engage in fraudulent, inappropriate, or abusive activities while using the system.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "8. Updates to Terms\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text:
                              " 1. The University of Rizal System may modify or update these Terms of Service at any time.\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              " 2. Users will be notified of significant changes, and continued use of URSatisfaction constitutes acceptance of the updated terms.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "9. Contact\n",
                          style: TextStyle(
                            color: Color(0xFF064089),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text:
                              "Information For questions, concerns, or feedback about URSatisfaction or these Terms of Service, please contact:\n",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              "Office of the University President\nUniversity of Rizal System\nofficeofthepresident@urs.edu.ph\n09182739109",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "By participating in URSatisfaction, you acknowledge that you have read, understood, and agreed to these Terms of Service. Your feedback is our commitment to improvement. We comply so URSatisfy. Thank you!",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
