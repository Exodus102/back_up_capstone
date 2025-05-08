import 'package:css_website/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class ClosingPage extends StatelessWidget {
  final VoidCallback onSubmitAnotherResponse;

  const ClosingPage({super.key, required this.onSubmitAnotherResponse});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: MediaQuery.of(context).size.width < 600
          ? const EdgeInsets.only(left: 30, right: 30)
          : EdgeInsets.symmetric(horizontal: size.width * 0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thank you for your feedback!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "We appreciate your time and effort in sharing your thoughts with us. Your feedback is invaluable and will help us improve and serve you better.",
              style: TextStyle(),
            ),
            const SizedBox(height: 15),
            const Text(
              "URSatisfaction. We comply so URSatisfy!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 45),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomButtons(
                onPressed: onSubmitAnotherResponse,
                label: "Submit Another Response",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
