import 'package:css_website/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class SurveyPage5Online extends StatefulWidget {
  final VoidCallback onNext;
  const SurveyPage5Online({super.key, required this.onNext});

  @override
  State<SurveyPage5Online> createState() => _SurveyPage5OnlineState();
}

class _SurveyPage5OnlineState extends State<SurveyPage5Online> {
  final Map<String, int> _selectedValues = {};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How did you find our service unit as to:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Ano ang masasabi mo sa aming tanggapan ayon sa:',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16.0),
              _buildSurveyRow(
                'a. Online platform used is customer-friendly',
                '(Kaangkupan ng ginamit na online platform o pamamaraan mga kliyente o bisita)',
              ),
              const SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: CustomButtons(
                  onPressed: widget.onNext,
                  label: "Continue",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurveyRow(String question, String description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRadioButton(5, question),
            _buildRadioButton(4, question),
            _buildRadioButton(3, question),
            _buildRadioButton(2, question),
            _buildRadioButton(1, question),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton(int value, String question) {
    return Radio<int>(
      value: value,
      groupValue: _selectedValues[question] ?? 0,
      onChanged: (int? newValue) {
        setState(() {
          _selectedValues[question] = newValue!;
        });
      },
    );
  }
}
