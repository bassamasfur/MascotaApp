import 'package:flutter/material.dart';
import 'root/splash_root.dart';
import 'root/pet_app_root.dart';
import 'views/breeds_screen.dart';

/// Clase principal de la aplicación
class PetApp extends StatelessWidget {
  const PetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const SplashRoot(),
      routes: {
        '/pets': (_) => const PetAppRoot(),
        '/breeds': (_) => const BreedsScreen(),
      },
    );
  }
}

//
