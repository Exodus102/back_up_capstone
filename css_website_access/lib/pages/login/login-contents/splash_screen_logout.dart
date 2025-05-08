import 'package:css_website_access/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/svg.dart';

class SplashScreenLogout extends StatefulWidget {
  const SplashScreenLogout({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreenLogout> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  "svg/Logo-SplashScreen.svg",
                  width: 150, // Smaller logo
                  height: 150,
                ),
                SizedBox(height: 20),
                Text(
                  'URSatisfaction',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'We comply so URSatisfied',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              '© University of Rizal System - 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
