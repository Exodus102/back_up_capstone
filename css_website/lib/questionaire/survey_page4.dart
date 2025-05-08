import 'package:css_website/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class SurveyPage4 extends StatefulWidget {
  final VoidCallback onNext;
  final String? campus;
  final String? division;
  final String? officeUnit;
  final String? customerName;
  final String? customerContact;
  final String? customerType;
  final String? transactionType;
  final String? purposeOfVisit;
  final Function(List<int> values)? onSaveData;
  const SurveyPage4({
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
    this.onSaveData,
  });

  @override
  State<SurveyPage4> createState() => _SurveyPage4State();
}

class _SurveyPage4State extends State<SurveyPage4> {
  final Map<String, int> _selectedValues = {};
  Map<String, int> getSurveyData() {
    return _selectedValues;
  }

  void saveSurveyData() {
    final selectedRatings = _selectedValues.values.toList();
    if (_selectedValues.length < 7 ||
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
      'Selected Values': selectedRatings,
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
                'How well were you served by the personnel during your visit / transaction in terms of the following:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Paano ka pinagsilbihan ng kawani nang bumisita ka sa tanggapan ayon sa mga sumusunod:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16.0),
              _buildSurveyRow(
                'a. Knowledge of the job',
                '(Kaalaman sa trabaho)',
              ),
              _buildSurveyRow(
                'b. Accuracy in providing information',
                '(Katumpakan sa pagbibigay ng impormasyon)',
              ),
              _buildSurveyRow(
                'c. Delivery of prompt and appropriate service',
                '(Pagbibigay ng mabilis at nararapat na serbisyo)',
              ),
              _buildSurveyRow(
                'd. Professionalism and skillfulness of the service personnel',
                '(Pagiging propesyunal at may kasanayan na kawani)',
              ),
              _buildSurveyRow(
                'e. Flexibility in handling requests and inquiries',
                '(Kakayahang umangkop ng pagtugon sa mga kahilingan at katanungan)',
              ),
              _buildSurveyRow(
                'f. Friendliness, attentiveness, helpfulness and courtesy',
                '(Pagiging magiliw, maasikaso, matulungin at magalang)',
              ),
              _buildSurveyRow(
                'g. The physical appearance of service personnel (e.g. wearing the prescribed uniform, ID, etc.)',
                '(Pisikal na kaayusan ng kawani tulad ng pagsusuot ng akmang uniporme, pagkakakilanlan o ID, at iba pa)',
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
