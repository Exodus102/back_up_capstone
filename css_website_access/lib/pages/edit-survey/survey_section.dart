import 'package:css_website_access/pages/edit-survey/show_dialog_survey.dart';
import 'package:css_website_access/pages/edit-survey/survey_button.dart';
import 'package:css_website_access/pages/edit-survey/survey_item.dart';
import 'package:flutter/material.dart';

class SurveySection extends StatefulWidget {
  final int sectionNumber;
  final List<Map<String, dynamic>> questions;
  final Function(List<Map<String, dynamic>>) onSectionUpdated;
  final Function(Map<String, dynamic>) onQuestionDeleted;

  const SurveySection({
    super.key,
    required this.sectionNumber,
    required this.questions,
    required this.onSectionUpdated,
    required this.onQuestionDeleted,
  });

  @override
  State<SurveySection> createState() => _SurveySectionState();
}

class _SurveySectionState extends State<SurveySection> {
  List<Map<String, dynamic>> surveyItems = [];

  @override
  void initState() {
    super.initState();
    surveyItems = List<Map<String, dynamic>>.from(widget.questions);
  }

  void _autoSave() {
    widget.onSectionUpdated(surveyItems);
  }

  void _updateQuestion(int index, String newQuestion, String oldQuestion) {
    setState(() {
      surveyItems[index]['question'] = newQuestion;
      surveyItems[index]['old_question'] = oldQuestion;
    });
    _autoSave();
  }

  void _updateChoices(int index, List<Map<String, dynamic>> newChoices) {
    setState(() {
      surveyItems[index]['choices'] = newChoices;
    });
    _autoSave();
  }

  void _updateRequired(int index, int requiredValue) {
    setState(() {
      surveyItems[index]['required'] = requiredValue;
    });
    _autoSave();
  }

  void _updateHeader(int index, int newHeader) {
    setState(() {
      surveyItems[index]['header'] = newHeader;
    });
    _autoSave();
  }

  void _deleteQuestion(int index) {
    final deletedQuestion = {
      'section': "Section ${widget.sectionNumber}",
      'question': surveyItems[index]['question'],
    };
    setState(() {
      surveyItems.removeAt(index);
    });
    widget.onQuestionDeleted(deletedQuestion);
    _autoSave();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7F9),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 3, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF48494A)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.drag_indicator),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF48494A)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Section ${widget.sectionNumber}"),
                ),
              ),
              const Spacer(),
              SurveyButton(
                svgPath: "svg/icons/+.svg",
                text: 'Add Item',
                onPressed: () {
                  showDialogSurvey(context, (selectedChoice) {
                    setState(() {
                      surveyItems.add({
                        'type': selectedChoice,
                        'question': 'New Question',
                        'choices': [],
                        'required': 0,
                        'header': 0,
                        'transaction_type': 'Default',
                        'render': 'None',
                      });
                    });
                    _autoSave();
                  });
                },
              ),
            ],
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Divider(color: Color(0xFF86898A)),
          ),

          // Survey Items List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: surveyItems.length,
            itemBuilder: (context, index) {
              final item = surveyItems[index];
              return SurveyItem(
                render: item['render'] ?? 'None',
                id: item['id'] ?? 0, // Provide a default value for 'id'
                transactionType:
                    int.tryParse(item['transaction_type']?.toString() ?? '0') ??
                        0,
                type: item['type'] ??
                    '', // Default to an empty string if 'type' is null
                question: item['question'] ??
                    'No Question', // Default to 'No Question'
                choices: List<Map<String, dynamic>>.from(item['choices'] ?? []),
                required:
                    int.tryParse(item['required']?.toString() ?? '0') ?? 0,
                header: int.tryParse(item['header']?.toString() ?? '0') ?? 0,
                onQuestionChanged: (newQuestion, oldQuestion) =>
                    _updateQuestion(index, newQuestion, oldQuestion),
                onChoicesChanged: (newChoices) =>
                    _updateChoices(index, newChoices),
                onRequiredChanged: (value) => _updateRequired(index, value),
                onHeaderChanged: (newHeader) => _updateHeader(index, newHeader),
                onDelete: () => _deleteQuestion(index),
                onTransactionTypeChanged: (id, selectedTransaction) {
                  setState(() {
                    final questionIndex =
                        surveyItems.indexWhere((q) => q['id'] == id);
                    if (questionIndex != -1) {
                      surveyItems[questionIndex]['transaction_type'] =
                          selectedTransaction;
                      print(
                          "Updated transaction_type for question ID $id: $selectedTransaction");
                    }
                  });
                  _autoSave();
                },
                onRenderChanged: (selectedRender) {
                  setState(() {
                    final questionIndex =
                        surveyItems.indexWhere((q) => q['id'] == item['id']);
                    if (questionIndex != -1) {
                      surveyItems[questionIndex]['render'] = selectedRender;
                      print(
                          "Updated render for question ID ${item['id']}: $selectedRender");
                    }
                  });
                  _autoSave();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
