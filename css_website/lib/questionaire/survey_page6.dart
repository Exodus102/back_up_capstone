import 'package:css_website/services/api_services_database.dart';
import 'package:css_website/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class SurveyPage6 extends StatefulWidget {
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
  final List<int>? selectedValuesPage5;
  const SurveyPage6({
    super.key,
    this.campus,
    this.division,
    this.officeUnit,
    this.customerName,
    this.customerContact,
    this.customerType,
    this.transactionType,
    this.purposeOfVisit,
    this.selectedValues,
    this.selectedValuesPage5,
    required this.onNext,
  });

  @override
  State<SurveyPage6> createState() => _SurveyPage6State();
}

class _SurveyPage6State extends State<SurveyPage6> {
  final _formKey = GlobalKey<FormState>();
  String _feedback = '';

  void saveSurveyData() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ApiService.saveData(
          campus: widget.campus ?? '',
          division: widget.division ?? '',
          officeUnit: widget.officeUnit ?? '',
          customerType: widget.customerType ?? '',
          customerName: widget.customerName ?? '',
          customerContact: widget.customerContact ?? '',
          transactionType: widget.transactionType ?? '',
          purposeOfVisit: widget.purposeOfVisit ?? '',
          selectedValues: widget.selectedValues ?? [],
          selectedValuesPage5: widget.selectedValuesPage5 ?? [],
          feedback: _feedback,
          context: context,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Your thoughts matter!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'We\'d love to hear your comments and suggestions to serve you better.',
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Comments and suggestions:',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF064089),
                        width: 2.0,
                      ),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _feedback = value;
                    });
                  },
                ),
                const SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: CustomButtons(
                    onPressed: saveSurveyData,
                    label: "Submit",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
