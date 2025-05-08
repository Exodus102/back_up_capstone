import 'package:css_website/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class SurveyPage5 extends StatefulWidget {
  final VoidCallback onNext;
  final String? campus;
  final String? division;
  final String? officeUnit;
  final String? customerName;
  final String? customerContact;
  final String? customerType;
  final String? transactionType;
  final String? purposeOfVisit;
  final List<int>? selectedValues;
  final Function(List<int> values)? onSaveData;
  const SurveyPage5({
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
    this.selectedValues,
    this.onSaveData,
  });

  @override
  State<SurveyPage5> createState() => _SurveyPage5State();
}

class _SurveyPage5State extends State<SurveyPage5> {
  final Map<String, int> _selectedValues = {};

  void saveSurveyData() {
    final selectedRatings = _selectedValues.values.toList();
    if (_selectedValues.length < 4 ||
        _selectedValues.values.any((value) => value == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please answer all the questions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFF0C5AC0),
        ),
      );
      return;
    }
    final surveyData = {
      'campus': widget.campus,
      'division': widget.division,
      'officeUnit': widget.officeUnit,
      'customerType': widget.customerType,
      'name': widget.customerName,
      'contactNumber': widget.customerContact,
      'Transaction Type': widget.transactionType,
      'Purpose of Visit': widget.purposeOfVisit,
      'Selected Values': widget.selectedValues,
      'Selected Values Page5': selectedRatings,
    };
    if (widget.onSaveData != null) {
      widget.onSaveData!(selectedRatings);
    }

    widget.onNext();
  }

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
                'a. Accessibility/location of the office/unit',
                '(Lokasyon ng tanggapan)',
              ),
              _buildSurveyRow(
                'b. Physical setup, condition, and availability of facilities and equipment',
                '(Pisikal na kaayusan, kalagayan at pgkakaroon ng mga kagamitan)',
              ),
              _buildSurveyRow(
                'c. Cleanliness of the premises',
                '(Kalinisan ng kapaligiran)',
              ),
              _buildSurveyRow(
                'd. Processes and procedures of service delivery are customer-friendly',
                '(Kaangkupan ng mga pamamaraan sa pagbibigay ng serbisyo sa mga kliyente o bisita)',
              ),
              const SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: CustomButtons(
                  onPressed: saveSurveyData,
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
      activeColor: const Color(0xFF064089),
    );
  }
}
