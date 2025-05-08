import 'package:css_website_access/pages/edit-survey/show_dialog_success.dart';
import 'package:css_website_access/pages/edit-survey/survey_section.dart';
import 'package:flutter/material.dart';
import 'package:css_website_access/pages/edit-survey/show_button.dart';
import 'package:css_website_access/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurveyMis extends StatefulWidget {
  final String? questionnaireTitle;
  final double height;
  final VoidCallback onBack;
  final String? fname;
  final String? lname;
  const SurveyMis({
    super.key,
    required this.height,
    this.questionnaireTitle,
    required this.onBack,
    this.fname,
    this.lname,
  });

  @override
  State<SurveyMis> createState() => _SurveyMisState();
}

class _SurveyMisState extends State<SurveyMis> {
  List<int> sectionNumbers = [];
  Map<String, List<Map<String, dynamic>>> sections = {};
  List<Map<String, dynamic>> deletedQuestions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  void _addSection() {
    setState(() {
      int newSectionNumber = sectionNumbers.length + 1;
      sectionNumbers.add(newSectionNumber);
      sections['Section $newSectionNumber'] = [];
    });
  }

  void _updateSection(
      String sectionKey, List<Map<String, dynamic>> updatedQuestions) {
    setState(() {
      List<Map<String, dynamic>> oldQuestions = sections[sectionKey] ?? [];
      List<Map<String, dynamic>> mergedQuestions =
          updatedQuestions.map((updatedQuestion) {
        Map<String, dynamic>? oldQuestion = oldQuestions.firstWhere(
            (q) => q['id'] == updatedQuestion['id'],
            orElse: () => {});
        return {
          ...oldQuestion,
          ...updatedQuestion,
        };
      }).toList();
      sections[sectionKey] = mergedQuestions;
    });
  }

  void _deleteQuestion(String sectionKey, Map<String, dynamic> question) {
    setState(() {
      sections[sectionKey]?.remove(question);
      deletedQuestions
          .add({'section': sectionKey, 'question': question['question']});
      print("Marked for deletion: ${question['question']}");
    });
  }

  Future<void> _fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.104/database/questionaire/get_question.php?survey_title=${widget.questionnaireTitle}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            sections = {};
            decodedData.forEach((key, value) {
              if (value is List) {
                sections[key] = List<Map<String, dynamic>>.from(value.map((q) {
                  if (q is Map<String, dynamic>) {
                    return {
                      'id': q['id'] ?? '', // Add unique identifier
                      'question': q['question']?.toString() ?? 'No Question',
                      'type': q['type'] ?? '',
                      'required': q['required'] ?? 0, // Include required field
                      'header': q['header'] ?? 0,
                      'transaction_type': q['transaction_type'] ?? 0,
                      'render': q['render'] ?? 'None',
                      'choices': (q['choices'] is List)
                          ? List<Map<String, dynamic>>.from(
                              q['choices'].map((choice) {
                              return {
                                'choice_id': choice['choice_id'] ?? '',
                                'choice_text': choice['choice_text'] ?? '',
                              };
                            }))
                          : [],
                    };
                  } else {
                    return {};
                  }
                }));
              }
            });
            sectionNumbers =
                List.generate(sections.length, (index) => index + 1);
          });
        }
      }
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }

  Future<void> saveLogs() async {
    final String fullName =
        '${widget.fname ?? ''} ${widget.lname ?? ''}'.trim();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.104/database/logs/audit_logs.php'),
        body: {
          'name': fullName,
          'message': 'Edited the survey form.',
        },
      );

      if (response.statusCode == 200) {
        print('Log saved successfully: ${response.body}');
      } else {
        print('Failed to save log: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while saving log: $e');
    }
  }

  Future<void> _saveSurvey() async {
    List<Map<String, dynamic>> surveyData = [];

    sections.forEach((section, questions) {
      print("questiopnaire: ${widget.questionnaireTitle}");
      for (var question in questions) {
        surveyData.add({
          'id': question['id'] ?? 0,
          'section': section,
          'old_question': question['old_question'] ?? question['question'],
          'question': question['question'],
          'type': question['type'],
          'choices': question['choices'],
          'required': question['required'] ?? 0,
          'survey_title': widget.questionnaireTitle,
          'header': question['header'] ?? 0,
          'transaction_type': question['transaction_type'] ?? 0,
          'render': question['render'] ?? 'None',
        });
      }
    });

    try {
      final requestBody = jsonEncode(
          {'questions': surveyData, 'deletedQuestions': deletedQuestions});
      print("Request Body: $requestBody");
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.104/database/questionaire/save_changes1.php'),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        showDialogSuccessEditSurvey(context, "Survey saved successfully.");
        deletedQuestions.clear();
        saveLogs();
      } else {
        print("Failed to save survey: ${response.body}");
      }
    } catch (e) {
      print("Error saving survey: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      double width = constraints.maxWidth;

      return Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_circle_left_outlined),
                        color: const Color(0xFF064089),
                      ),
                      Text(
                        "${widget.questionnaireTitle}",
                        style: TextStyle(
                          color: Color(0xFF064089),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomButton(
                        label: "Add Section",
                        svgPath: "svg/icons/+.svg",
                        onPressed: _addSection,
                      ),
                      const SizedBox(width: 10),
                      ShowButton(
                        label: "Save Changes",
                        onPressed: _saveSurvey,
                        svgPath: "svg/icons/floppy-disk.svg",
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: width,
                height: widget.height - 22 - 8,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    children: sectionNumbers.map((sectionNumber) {
                      String sectionKey = 'Section $sectionNumber';
                      return SurveySection(
                        sectionNumber: sectionNumber,
                        questions: List<Map<String, dynamic>>.from(
                          sections[sectionKey] ?? [],
                        ),
                        onSectionUpdated: (updatedQuestions) {
                          _updateSection(sectionKey, updatedQuestions);
                        },
                        onQuestionDeleted: (question) {
                          _deleteQuestion(sectionKey, question);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
