import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pet_list_provider.dart';
import 'app.dart';
import 'services/notification_service.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

/// Punto de entrada de la aplicación
///
/// Esta aplicación sigue el patrón MVC (Model-View-Controller):
/// - Models: Contienen los datos y la lógica de negocio
/// - Views: Muestran la información al usuario
/// - Controllers: Gestionan la interacción entre Models y Views
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.initialize();

  // Solicitar permiso de notificaciones en Android 13+
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => PetListProvider(),
      child: const PetApp(),
    ),
  );
}
