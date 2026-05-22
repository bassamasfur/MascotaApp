import 'package:flutter/material.dart';
import '../views/splash_screen.dart';

import '../welcome_screen.dart';

class SplashRoot extends StatefulWidget {
  const SplashRoot({super.key});
  @override
  State<SplashRoot> createState() => _SplashRootState();
}

class _SplashRootState extends State<SplashRoot> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
