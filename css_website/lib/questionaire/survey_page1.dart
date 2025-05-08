import 'package:css_website/widgets/custom_buttons.dart';
import 'package:css_website/widgets/custom_text_survey_p1.dart';
import 'package:css_website/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SurveyPage1 extends StatefulWidget {
  final VoidCallback onNext;
  final String? campus;
  final String? division;
  final String? officeUnit;
  final Function(String? name, String? customerNumber, String customerType)?
      onSaveCustomer;
  const SurveyPage1({
    super.key,
    required this.onNext,
    this.campus,
    this.division,
    this.officeUnit,
    this.onSaveCustomer,
  });

  @override
  State<SurveyPage1> createState() => _SurveyPage1State();
}

class _SurveyPage1State extends State<SurveyPage1> {
  String? _customerType;
  String? _name;
  String? _contactNumber;

  void saveSurveyData() {
    if (_customerType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select the Customer Field',
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
      'customerType': _customerType,
      'name': _name,
      'contactNumber': _contactNumber,
    };

    if (widget.onSaveCustomer != null) {
      widget.onSaveCustomer!(
        _name,
        _contactNumber,
        _customerType!,
      );
    }

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
            'Take a second to introduce yourself!',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Please note that some fields are optional.',
            style: TextStyle(
              height: 1,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 40),
          const CustomTextSurveyP1(text: "Name (Optional)"),
          const SizedBox(height: 20),
          const CustomTextSurveyP1(text: "Customer Type"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                      child: RadioListTile<String>(
                        title: const Text("Student"),
                        value: "Student",
                        groupValue: _customerType,
                        onChanged: (value) {
                          setState(() {
                            _customerType = value;
                          });
                        },
                        activeColor: const Color(0xFF064089),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: RadioListTile<String>(
                        title: const Text("Parent"),
                        value: "Parent",
                        groupValue: _customerType,
                        onChanged: (value) {
                          setState(() {
                            _customerType = value;
                          });
                        },
                        activeColor: const Color(0xFF064089),
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text("Faculty"),
                      value: "Faculty",
                      groupValue: _customerType,
                      onChanged: (value) {
                        setState(() {
                          _customerType = value;
                        });
                      },
                      activeColor: const Color(0xFF064089),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                      child: RadioListTile<String>(
                        title: const Text("Staff"),
                        value: "Staff",
                        groupValue: _customerType,
                        onChanged: (value) {
                          setState(() {
                            _customerType = value;
                          });
                        },
                        activeColor: const Color(0xFF064089),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: RadioListTile<String>(
                        title: const Text("Alumni"),
                        value: "Alumni",
                        groupValue: _customerType,
                        onChanged: (value) {
                          setState(() {
                            _customerType = value;
                          });
                        },
                        activeColor: const Color(0xFF064089),
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text("Others"),
                      value: "Other",
                      groupValue: _customerType,
                      onChanged: (value) {
                        setState(() {
                          _customerType = value;
                        });
                      },
                      activeColor: const Color(0xFF064089),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomButtons(
              label: 'Continue',
              onPressed: saveSurveyData,
            ),
          )
        ],
      ),
    );
  }
}
