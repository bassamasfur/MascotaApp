import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB2EBF2), Color(0xFF81D4FA), Color(0xFFB3E5FC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('🐾', style: TextStyle(fontSize: 90, fontFamily: null)),
              SizedBox(height: 32),
              Text(
                '¡Bienvenido a Pet App!',
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF0D47A1),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Cuida, registra y disfruta de tus mascotas',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(color: Colors.blue, strokeWidth: 4),
            ],
          ),
        ),
      ),
    );
  }
}
