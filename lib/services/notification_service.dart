import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notificationsPlugin.initialize(settings: settings);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();
    final tzScheduled = tz.TZDateTime.from(scheduledTime, tz.local);
    print(
      '[NOTIF] Ahora:   '
              '[32m[1m'
              '[0m' +
          now.toString(),
    );
    print(
      '[NOTIF] Programada para: '
              '[33m[1m'
              '[0m' +
          tzScheduled.toString(),
    );
    print('[NOTIF] ID: $id, Título: $title, Body: $body');
    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzScheduled,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'pet_activities',
          'Actividades de Mascotas',
          channelDescription: 'Notificaciones de actividades de mascotas',
          importance: Importance.max,
          priority: Priority.high,
          // sound: RawResourceAndroidNotificationSound('test'), // Usar sonido por defecto
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  static Future<void> showTestNotification() async {
    await _notificationsPlugin.show(
      id: 9999,
      title: 'Prueba inmediata',
      body: '¿Ves esta notificación?',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'pet_activities',
          'Actividades de Mascotas',
          channelDescription: 'Notificaciones de actividades de mascotas',
          importance: Importance.max,
          priority: Priority.high,
          // sound: RawResourceAndroidNotificationSound('test'), // Desactivado para evitar problemas
        ),
      ),
    );
  }
}
