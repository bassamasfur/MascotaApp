import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pet_list_provider.dart';
import 'app.dart';

/// Punto de entrada de la aplicación
///
/// Esta aplicación sigue el patrón MVC (Model-View-Controller):
/// - Models: Contienen los datos y la lógica de negocio
/// - Views: Muestran la información al usuario
/// - Controllers: Gestionan la interacción entre Models y Views
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PetListProvider(),
      child: const PetApp(),
    ),
  );
}
