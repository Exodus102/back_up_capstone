import 'dart:typed_data';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String label;
  final String? fname;
  final String? lname;
  final Uint8List? profileImage;
  final String? redirectPage;
  const CustomHeader({
    super.key,
    required this.label,
    this.fname,
    this.lname,
    this.profileImage,
    this.redirectPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFF1F7F9),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E1E1E).withValues(alpha: 0.4),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF064089),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Row(
              children: [
                profileImage != null
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF474747),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.memory(
                            profileImage!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 40,
                        color: Color(0xFF474747),
                      ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$fname $lname'),
                    Text(
                      redirectPage == 'MisPage'
                          ? 'University MIS'
                          : redirectPage == 'CssCoordinatorPanelSide'
                              ? 'CSS Coordinator'
                              : redirectPage == 'DirectorPanel'
                                  ? 'Director'
                                  : redirectPage == 'DccPanel'
                                      ? 'DCC'
                                      : redirectPage == 'UnitHeadPanel'
                                          ? 'Unit Head'
                                          : redirectPage == 'CssHeadPanel'
                                              ? 'CSS Head'
                                              : 'Office',
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
