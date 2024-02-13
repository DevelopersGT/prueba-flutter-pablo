import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:practica/config/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  static const String name = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      appRouter.go('/login_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: FadeIn(
                  duration: const Duration(seconds: 3),
                  child: Image.asset('assets/images/logogogo2.png'),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}