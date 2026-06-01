import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const String _awesomeChannelKey = 'pet_activities_channel';

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        'pet_activities',
        'Actividades de Mascotas',
        channelDescription: 'Notificaciones de actividades de mascotas',
        importance: Importance.max,
        priority: Priority.high,
      );

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notificationsPlugin.initialize(settings: settings);

    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: _awesomeChannelKey,
        channelName: 'Actividades de Mascotas',
        channelDescription: 'Notificaciones de actividades de mascotas',
        importance: NotificationImportance.Max,
      ),
    ]);
  }

  static Future<void> configureLocalTimeZone() async {
    try {
      final deviceTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(deviceTimeZone));
      print('[NOTIF] Zona horaria configurada: $deviceTimeZone');
    } catch (e) {
      // Fallback seguro para evitar que falle la programación.
      tz.setLocalLocation(tz.getLocation('UTC'));
      print(
        '[NOTIF] No se pudo obtener zona horaria local. Usando UTC. Error: $e',
      );
    }
  }

  static Future<void> requestPlatformPermissions() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();

    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<bool> canScheduleExactAlarms() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final canSchedule = await androidPlugin?.canScheduleExactNotifications();
    return canSchedule ?? false;
  }

  static Future<bool> requestExactAlarmPermissionForTest() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final before = await androidPlugin?.canScheduleExactNotifications();
    if (before == true) {
      return true;
    }

    await androidPlugin?.requestExactAlarmsPermission();
    final after = await androidPlugin?.canScheduleExactNotifications();
    print('[NOTIF] Permiso exacto habilitado: ${after == true}');
    return after == true;
  }

  static Future<AndroidScheduleMode> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();
    final tzScheduled = tz.TZDateTime.from(scheduledTime, tz.local);
    print('[NOTIF] Ahora: $now');
    print('[NOTIF] Programada para: $tzScheduled');
    print('[NOTIF] ID: $id, Título: $title, Body: $body');

    if (!tzScheduled.isAfter(tz.TZDateTime.now(tz.local))) {
      print(
        '[NOTIF] Ajustando hora: estaba en pasado o muy cerca del presente.',
      );
    }

    final safeSchedule = tzScheduled.isAfter(tz.TZDateTime.now(tz.local))
        ? tzScheduled
        : tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    final hasExactPermission = await canScheduleExactAlarms();
    print('[NOTIF] canScheduleExactAlarms: $hasExactPermission');

    try {
      final awesomeScheduled = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: _awesomeChannelKey,
          title: title,
          body: body,
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
        ),
        schedule: NotificationCalendar.fromDate(
          date: safeSchedule.toLocal(),
          preciseAlarm: hasExactPermission,
          allowWhileIdle: true,
          repeats: false,
        ),
      );

      final scheduledByAwesome =
          (await AwesomeNotifications().listScheduledNotifications()).any(
            (notification) => notification.content?.id == id,
          );

      if (awesomeScheduled || scheduledByAwesome) {
        final usedMode = hasExactPermission
            ? AndroidScheduleMode.alarmClock
            : AndroidScheduleMode.inexactAllowWhileIdle;
        print(
          '[NOTIF] Programada con AwesomeNotifications. '
          'Resultado bool: $awesomeScheduled, encontrada en agenda: $scheduledByAwesome',
        );
        return usedMode;
      }

      print('[NOTIF] AwesomeNotifications devolvió false, aplicando fallback.');
    } catch (e) {
      print('[NOTIF] Error al programar con AwesomeNotifications: $e');
    }

    Future<AndroidScheduleMode> scheduleWithMode(
      AndroidScheduleMode mode,
    ) async {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: safeSchedule,
        notificationDetails: NotificationDetails(android: _androidDetails),
        androidScheduleMode: mode,
      );
      print('[NOTIF] Programada con modo: $mode');
      return mode;
    }

    late final AndroidScheduleMode usedMode;

    if (hasExactPermission) {
      try {
        // En Android recientes, alarmClock suele disparar con mayor consistencia.
        usedMode = await scheduleWithMode(AndroidScheduleMode.alarmClock);
      } catch (e) {
        print('[NOTIF] alarmClock falló: $e');
        usedMode = await scheduleWithMode(
          AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    } else {
      usedMode = await scheduleWithMode(
        AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }

    final pending = await _notificationsPlugin.pendingNotificationRequests();
    print('[NOTIF] Pendientes tras programar: ${pending.length}');
    return usedMode;
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
    await _notificationsPlugin.cancel(id: id);
  }

  static Future<void> showTestNotification() async {
    await _notificationsPlugin.show(
      id: 9999,
      title: 'Prueba inmediata',
      body: '¿Ves esta notificación?',
      notificationDetails: NotificationDetails(android: _androidDetails),
    );
  }
}
