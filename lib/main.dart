import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/notification_center_provider.dart';
import 'providers/pet_list_provider.dart';
import 'app.dart';
import 'services/notification_service.dart';

import 'package:timezone/data/latest.dart' as tz;

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
  await NotificationCenterProvider.instance.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetListProvider()),
        ChangeNotifierProvider.value(
          value: NotificationCenterProvider.instance,
        ),
      ],
      child: const PetApp(),
    ),
  );

  // No bloquear el primer frame: pedir permisos despues de renderizar la UI.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NotificationService.configureLocalTimeZone();
    NotificationService.requestPlatformPermissions();
  });
}
