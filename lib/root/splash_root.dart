import 'package:flutter/material.dart';
import '../views/splash_screen.dart';
import 'pet_app_root.dart';

class SplashRoot extends StatefulWidget {
  const SplashRoot({Key? key}) : super(key: key);
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
          MaterialPageRoute(builder: (_) => const PetAppRoot()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
