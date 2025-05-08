import 'package:flutter/material.dart';
import 'package:css_website/widgets/custom_buttons.dart';
import 'package:css_website/widgets/custom_dropdown.dart';

class TransactionTypePage extends StatefulWidget {
  final Function(Map<String, String?>) onNext;

  const TransactionTypePage({super.key, required this.onNext});

  @override
  State<TransactionTypePage> createState() => _TransactionTypePageState();
}

class _TransactionTypePageState extends State<TransactionTypePage> {
  String? selectedType;
  bool hasError = false;
  bool purposeHasError = false;

  final TextEditingController purposeController = TextEditingController();
  final FocusNode purposeFocusNode = FocusNode();

  bool isPurposeFocused = false;
  bool hasTypedInPurpose = false;

  Map<String, String?> answers = {};

  int getTransactionTypeId(String? type) {
    if (type == "Face-to-Face") return 1;
    if (type == "Online") return 2;
    return 0;
  }

  @override
  void initState() {
    super.initState();

    // Track focus
    purposeFocusNode.addListener(() {
      setState(() {
        isPurposeFocused = purposeFocusNode.hasFocus;
        hasTypedInPurpose = purposeController.text.trim().isNotEmpty;
      });
    });

    // Track input and remove error if user starts typing
    purposeController.addListener(() {
      final hasText = purposeController.text.trim().isNotEmpty;
      setState(() {
        hasTypedInPurpose = hasText;
        if (hasText && purposeHasError) {
          purposeHasError = false; // Clear error as user fixes it
        }
      });
    });
  }

  @override
  void dispose() {
    purposeController.dispose();
    purposeFocusNode.dispose();
    super.dispose();
  }

  Color getPurposeLabelColor() {
    if (purposeHasError) return Colors.red;
    if (isPurposeFocused || hasTypedInPurpose) return const Color(0xFF064089);
    return Colors.black;
  }

  FontWeight getPurposeLabelWeight() {
    if (isPurposeFocused || hasTypedInPurpose) return FontWeight.bold;
    return FontWeight.normal;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: MediaQuery.of(context).size.width < 600
          ? const EdgeInsets.only(left: 30, right: 30)
          : EdgeInsets.symmetric(horizontal: size.width * 0.25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Getting started!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            const Text(
              "Help us understand what we are working on today by providing the following information:",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            const SizedBox(height: 30),
            CustomDropdown(
              labelText: "Transaction Type",
              items: const ['Face-to-Face', 'Online'],
              selectedValue: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                  hasError = value == null;
                });
              },
              hasError: hasError,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: purposeController,
              focusNode: purposeFocusNode,
              decoration: InputDecoration(
                labelText: "Purpose of Visit or Transaction",
                labelStyle: TextStyle(
                  color: getPurposeLabelColor(),
                  fontWeight: getPurposeLabelWeight(),
                ),
                errorText: purposeHasError ? 'This field is required' : null,
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF064089), width: 2.0),
                ),
              ),
              maxLines: 3,
              cursorColor: const Color(0xFF064089),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomRight,
              child: isMobile
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CustomButtons(
                        label: "Evaluate",
                        onPressed: () {
                          setState(() {
                            hasError = selectedType == null;
                            purposeHasError =
                                purposeController.text.trim().isEmpty;
                          });

                          if (hasError || purposeHasError) return;

                          answers['transaction_type'] = selectedType;
                          answers['purpose'] = purposeController.text.trim();
                          widget.onNext(answers);
                        },
                      ),
                    )
                  : CustomButtons(
                      label: "Evaluate",
                      onPressed: () {
                        setState(() {
                          hasError = selectedType == null;
                          purposeHasError =
                              purposeController.text.trim().isEmpty;
                        });

                        if (hasError || purposeHasError) return;

                        answers['transaction_type'] = selectedType;
                        answers['purpose'] = purposeController.text.trim();
                        widget.onNext(answers);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
