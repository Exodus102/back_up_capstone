import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TitleSurveyLogo extends StatelessWidget {
  const TitleSurveyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveWidth = screenWidth * 0.9;

    // Responsive sizes
    bool isMobile = screenWidth < 600;
    double logoSize = isMobile ? 50 : 100;
    double titleFontSize = isMobile ? 24 : 35;
    double subtitleFontSize = isMobile ? 14 : 20;

    return Center(
      child: SizedBox(
        width: responsiveWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/svg/images/Logo.svg",
              width: logoSize,
              height: logoSize,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'URS',
                    style: TextStyle(
                      color: const Color(0xFF95B3D3),
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                    ),
                    children: [
                      TextSpan(
                        text: 'atisfaction',
                        style: TextStyle(
                          color: const Color(0xFFF1F7F9),
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'We comply so URSatisfied',
                  style: TextStyle(
                    color: const Color(0xFFF1F7F9),
                    fontSize: subtitleFontSize,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
