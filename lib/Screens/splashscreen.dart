import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int durationInSeconds = 6;
  String routeName = 'welcome';
  String assetPath = 'assets/splashscreenlottie.json';

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: durationInSeconds), () {
      Navigator.pushReplacementNamed(context, routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double animationWidth = screenSize.width;
    final double animationHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          assetPath,
          width: animationWidth,
          height: animationHeight,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
