import 'package:flutter/material.dart';
import 'package:css_website/widgets/custom_buttons.dart';

class LandingPageQuestionaire extends StatefulWidget {
  final VoidCallback onNext;
  final Function(String campus, String division, String officeUnit)? onSaveData;

  const LandingPageQuestionaire({
    super.key,
    required this.onNext,
    this.onSaveData,
  });

  @override
  _LandingPageQuestionaireState createState() =>
      _LandingPageQuestionaireState();
}

class _LandingPageQuestionaireState extends State<LandingPageQuestionaire> {
  String? selectedCampus;
  String? selectedDivision;
  String? selectedOfficeUnit;

  final List<String> campus = [
    'Angono',
    'Antipolo',
    'Binangonan',
    'Cainta',
    'Cardona',
    'Morong',
    'Pililla',
    'Rodriguez',
    'Tanay',
    'Taytay',
  ];

  final List<String> division = [
    'Office of the President',
    'Academic Affairs',
    'Administration and Finance Division',
    'Research, Development, Extension, and Production Division',
  ];

  final List<String> officeunit = [
    'Campus Management Information System',
    'Campus Planning, Monitoring and Evaluation',
    'Campus Sports Development',
    'Culture and Arts',
  ];
  void saveFeedback() {
    if (selectedCampus == null ||
        selectedDivision == null ||
        selectedOfficeUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select all fields',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }
    if (widget.onSaveData != null) {
      widget.onSaveData!(
        selectedCampus!,
        selectedDivision!,
        selectedOfficeUnit!,
      );
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Which area is your feedback related to?',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Please select the area your feedback relates to:',
              style: TextStyle(
                height: 1,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(height: 30),
            SizedBox(
              width: size.width * 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButtons(
                    onPressed: saveFeedback,
                    label: 'Evaluate',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
