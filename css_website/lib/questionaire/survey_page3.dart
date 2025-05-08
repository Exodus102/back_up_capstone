import 'package:css_website/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class SurveyPage3 extends StatefulWidget {
  final VoidCallback onNext;
  final String? campus;
  final String? division;
  final String? officeUnit;
  final String? customerName;
  final String? customerContact;
  final String? customerType;
  final String? transactionType;
  final String? purposeOfVisit;
  const SurveyPage3({
    super.key,
    required this.onNext,
    this.campus,
    this.division,
    this.officeUnit,
    this.customerName,
    this.customerContact,
    this.customerType,
    this.transactionType,
    this.purposeOfVisit,
  });

  @override
  State<SurveyPage3> createState() => _SurveyPage3State();
}

class _SurveyPage3State extends State<SurveyPage3> {
  void saveSurveyData() {
    final surveyData = {
      'campus': widget.campus,
      'division': widget.division,
      'officeUnit': widget.officeUnit,
      'customerType': widget.customerType,
      'name': widget.customerName,
      'contactNumber': widget.customerContact,
      'Transaction Type': widget.transactionType,
      'Purpose of Visit': widget.purposeOfVisit,
    };

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Keep in that mind of URs!',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Click on the item corresponding to your answer using the given scale below.',
            style: TextStyle(
              height: 1,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            '5 - Excellent',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            '4 - Very Satisfactory',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            '3 - Satisfactory',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            '2 - Unsatisfactory',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            '1 - Needs Improvement',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomButtons(
              onPressed: saveSurveyData,
              label: 'Continue',
            ),
          ),
        ],
      ),
    );
  }
}
