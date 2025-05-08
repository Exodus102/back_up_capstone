import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:css_website/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import '../privacy_policy_page.dart';
import '../terms_of_services_page.dart';
import 'package:flutter/gestures.dart';

class SurveyPageComment extends StatefulWidget {
  final Function(String, String) onSubmit;
  final VoidCallback? onBack;

  const SurveyPageComment({super.key, required this.onSubmit, this.onBack});

  @override
  State<SurveyPageComment> createState() => _SurveyPageCommentState();
}

class _SurveyPageCommentState extends State<SurveyPageComment> {
  bool isChecked = false;

  Future<String> analyzeSentiment(String text) async {
    final initiateUrl = Uri.parse(
      'https://exodus102-sentiment-analysis-upload.hf.space/gradio_api/call/analyze_sentiment',
    );

    final response = await http.post(
      initiateUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "data": [text],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final eventId = data['event_id'];

      final resultUrl = Uri.parse(
        'https://exodus102-sentiment-analysis-upload.hf.space/gradio_api/call/analyze_sentiment/$eventId',
      );

      final resultResponse = await http.get(resultUrl);

      if (resultResponse.statusCode == 200) {
        final responseLines = LineSplitter.split(resultResponse.body).toList();
        final jsonLine = responseLines.firstWhere(
          (line) => line.trim().startsWith('data: '),
          orElse: () => '',
        );

        if (jsonLine.isNotEmpty) {
          final jsonString = jsonLine.replaceFirst('data: ', '').trim();
          final resultData = jsonDecode(jsonString);

          final label = resultData[0]['label'];
          return label;
        } else {
          return "Error: No data line in response.";
        }
      } else {
        return "Error fetching result: ${resultResponse.statusCode}";
      }
    } else {
      return "Error initiating analysis: ${response.statusCode}";
    }
  }

  final _formKey = GlobalKey<FormState>();
  String _feedback = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).size.width < 600
              ? const EdgeInsets.only(left: 30, right: 30)
              : EdgeInsets.symmetric(horizontal: size.width * 0.2),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Your thoughts matter!',
                  style: TextStyle(
                    fontSize: 25.0,
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
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.trim().toLowerCase() == 'none') {
                      return 'Please enter a valid response';
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
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        child: Checkbox(
                          value: isChecked,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Color(0xFF064089); // Checked
                            }
                            return Colors.white; // Unchecked
                          }),
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 7),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'By ticking, you are confirming that you have read, understood, and agree to the URSatisfaction: Customer Satisfaction Survey System, including our ',
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyPolicyPage(),
                                          ),
                                        );
                                      },
                                  ),
                                  const TextSpan(
                                    text: ' and ',
                                  ),
                                  TextSpan(
                                    text: 'Terms of Services',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TermsOfServicesPage(),
                                          ),
                                        );
                                      },
                                  ),
                                  const TextSpan(
                                    text: '.',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Submit button on top
                          AbsorbPointer(
                            absorbing: !isChecked,
                            child: Opacity(
                              opacity: isChecked ? 1.0 : 0.5,
                              child: SizedBox(
                                child: CustomButtons(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => const Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        ),
                                      );

                                      try {
                                        String sentiment =
                                            await analyzeSentiment(_feedback);

                                        Navigator.of(context).pop();
                                        widget.onSubmit(_feedback, sentiment);
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'An error occurred. Please try again.'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  label: "Submit",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Back button below
                          SizedBox(
                            child: CustomButtons(
                              onPressed: widget.onBack ?? () {},
                              label: "Back",
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButtons(
                            onPressed: widget.onBack ?? () {},
                            label: "Back",
                          ),
                          AbsorbPointer(
                            absorbing: !isChecked,
                            child: Opacity(
                              opacity: isChecked ? 1.0 : 0.5,
                              child: CustomButtons(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      ),
                                    );

                                    try {
                                      String sentiment =
                                          await analyzeSentiment(_feedback);

                                      Navigator.of(context).pop();
                                      widget.onSubmit(_feedback, sentiment);
                                    } catch (e) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'An error occurred. Please try again.'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                label: "Submit",
                              ),
                            ),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
