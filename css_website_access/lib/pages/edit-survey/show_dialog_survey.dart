import 'package:css_website_access/pages/edit-survey/choices_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void showDialogSurvey(BuildContext context, Function(String) onChoiceSelected) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFFF1F7F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "svg/icons/add-item.svg",
                            color: const Color(0xFF064089),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Add Item",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF064089),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            ChoicesButton(
                              text: "Text Answer",
                              onPressed: () {
                                onChoiceSelected("Text Answer");
                                Navigator.of(context).pop();
                              },
                            ),
                            ChoicesButton(
                              text: "Description",
                              onPressed: () {
                                onChoiceSelected("Description");
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            ChoicesButton(
                              text: "Multiple Choice",
                              onPressed: () {
                                onChoiceSelected("Multiple Choice");
                                Navigator.of(context).pop();
                              },
                            ),
                            ChoicesButton(
                              text: "Dropdown",
                              onPressed: () {
                                onChoiceSelected("Dropdown");
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
