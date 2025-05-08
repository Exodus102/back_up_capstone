import 'package:css_website_access/pages/edit-survey/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:css_website_access/widgets/custom_dropdown.dart';
import 'package:css_website_access/widgets/custom_button.dart';
import 'package:css_website_access/pages/edit-survey/cancel_button.dart';
import 'package:css_website_access/pages/edit-survey/edit_question.dart';
import 'package:css_website_access/pages/edit-survey/required_button.dart';
import 'package:css_website_access/pages/edit-survey/survey_button.dart';

class SurveyItem extends StatefulWidget {
  final String render;
  final String type;
  final String question;
  final List<Map<String, dynamic>> choices;
  final int required;
  final int header;
  final int transactionType;
  final Function(String, String) onQuestionChanged;
  final ValueChanged<List<Map<String, dynamic>>> onChoicesChanged;
  final ValueChanged<int> onRequiredChanged;
  final ValueChanged<int> onHeaderChanged;
  final VoidCallback onDelete;
  final void Function(int id, int transactionType) onTransactionTypeChanged;
  final void Function(String? render) onRenderChanged;
  final int id;
  const SurveyItem({
    super.key,
    required this.type,
    required this.question,
    required this.choices,
    required this.required,
    required this.onQuestionChanged,
    required this.onChoicesChanged,
    required this.onRequiredChanged,
    required this.onDelete,
    required this.onHeaderChanged,
    required this.header,
    required this.onTransactionTypeChanged,
    required this.transactionType,
    required this.id,
    required this.onRenderChanged,
    required this.render,
  });

  @override
  SurveyItemState createState() => SurveyItemState();
}

class SurveyItemState extends State<SurveyItem> {
  late TextEditingController _questionController;
  late List<TextEditingController> _choiceControllers;
  bool _isEditing = false;
  String? selectedChoice;
  String? selectedTransactionType;
  String? selectedRender;
  late String _oldQuestion;

  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question);
    _choiceControllers = widget.choices
        .map((choice) => TextEditingController(text: choice['choice_text']))
        .toList();
    _oldQuestion = widget.question;
    selectedTransactionType =
        _mapTransactionTypeToDropdownValue(widget.transactionType);
    selectedRender =
        ["None", "QoS", "SU"].contains(widget.render) ? widget.render : "None";
  }

  String _mapTransactionTypeToDropdownValue(int transactionType) {
    switch (transactionType) {
      case 1:
        return "Face-to-Face";
      case 2:
        return "Online";
      default:
        return "Default";
    }
  }

  int _mapDropdownValueToTransactionType(String? dropdownValue) {
    switch (dropdownValue) {
      case "Face-to-Face":
        return 1;
      case "Online":
        return 2;
      default:
        return 0;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _choiceControllers) {
      controller.dispose();
    }
    _debouncer.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
    if (!_isEditing) {
      widget.onQuestionChanged(_questionController.text, _oldQuestion);
      _updateChoices();
      _oldQuestion = _questionController.text;
    }
  }

  void _updateChoices() {
    List<Map<String, dynamic>> updatedChoices = _choiceControllers
        .map((controller) => {'choice_text': controller.text})
        .toList();
    widget.onChoicesChanged(updatedChoices);
  }

  void _addChoice() {
    setState(() {
      _choiceControllers.add(TextEditingController(text: ""));
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _questionController.text = widget.question;
      _choiceControllers = widget.choices
          .map((choice) => TextEditingController(text: choice['choice_text']))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF48494A)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(widget.type),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: CustomDropdown(
                    items: const ["Default", "Face-to-Face", "Online"],
                    selectedValue: selectedTransactionType,
                    onChanged: (value) {
                      setState(() {
                        selectedTransactionType = value;
                      });
                      final updatedTransactionType =
                          _mapDropdownValueToTransactionType(value);
                      print("Question ID: ${widget.id}");
                      print("Question: ${widget.question}");
                      print("Selected Dropdown Value: $value");
                      print("Mapped Transaction Type: $updatedTransactionType");

                      widget.onTransactionTypeChanged(
                          widget.id, updatedTransactionType);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: CustomDropdown(
                    items: const ["None", "QoS", "SU"],
                    selectedValue: selectedRender,
                    onChanged: (value) {
                      setState(() {
                        selectedRender = value;
                      });
                      print("Question ID: ${widget.id}");
                      print("Question: ${widget.question}");
                      print("Selected Dropdown Value: $value");
                      widget.onRenderChanged(value);
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                RequiredButton(
                  title: "Required",
                  initialRequired: widget.required,
                  onChanged: widget.onRequiredChanged,
                ),
                const SizedBox(width: 10),
                RequiredButton(
                  title: "Numeric",
                  initialRequired: widget.header,
                  onChanged: widget.onHeaderChanged,
                ),
                const SizedBox(width: 10),
                if (!_isEditing)
                  SurveyButton(
                    svgPath: "svg/icons/pencil.svg",
                    text: "Edit",
                    onPressed: _toggleEdit,
                  ),
                if (_isEditing)
                  Row(
                    children: [
                      CustomButton(
                        label: "Save Changes",
                        svgPath: "svg/icons/floppy-disk.svg",
                        onPressed: _toggleEdit,
                      ),
                      const SizedBox(width: 10),
                      CancelButton(
                        label: "Cancel",
                        onPressed: _cancelEdit,
                      ),
                    ],
                  ),
                const SizedBox(width: 10),
                if (!_isEditing)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      border: Border.all(color: const Color(0xFFEF4444)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      color: const Color(0xFFEF4444),
                      icon: const Icon(Icons.delete),
                      onPressed: widget.onDelete,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        _isEditing
            ? EditQuestionTextField(
                controller: _questionController,
                onChanged: (value) {
                  _debouncer.run(() {
                    widget.onQuestionChanged(value, _oldQuestion);
                  });
                },
              )
            : Text(
                widget.question,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
        const SizedBox(height: 10),
        if (widget.type == "Multiple Choice" || widget.type == "Dropdown")
          _buildChoiceList(),
        if (widget.type == "Text Answer") _buildTextAnswer(),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Divider(color: Color(0xFF86898A)),
        ),
      ],
    );
  }

  Widget _buildChoiceList() {
    return Column(
      children: [
        ...List.generate(_choiceControllers.length, (index) {
          return Row(
            children: [
              if (widget.type == "Multiple Choice")
                Radio<String>(
                  value: _choiceControllers[index].text,
                  groupValue: selectedChoice,
                  onChanged: (value) {
                    setState(() {
                      selectedChoice = value;
                    });
                  },
                ),
              Expanded(
                child: _isEditing
                    ? TextField(
                        controller: _choiceControllers[index],
                        onChanged: (value) {
                          _debouncer.run(() => _updateChoices());
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      )
                    : Text(_choiceControllers[index].text),
              ),
            ],
          );
        }),
        if (_isEditing)
          TextButton.icon(
            onPressed: _addChoice,
            icon: const Icon(Icons.add),
            label: const Text("Add Option"),
          ),
      ],
    );
  }

  Widget _buildTextAnswer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: const TextField(
        readOnly: true,
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(width: 3.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
