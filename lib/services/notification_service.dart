import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide GroupAlertBehavior;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const String _awesomeChannelKey = 'pet_activities_channel_v4';

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        'pet_activities_v4',
        'Actividades de Mascotas',
        channelDescription: 'Notificaciones de actividades de mascotas',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('actividad'),
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
        playSound: true,
        soundSource: 'resource://raw/actividad',
        enableVibration: true,
        onlyAlertOnce: false,
        groupAlertBehavior: GroupAlertBehavior.All,
      ),
    ]);
  }

  static Future<void> configureLocalTimeZone() async {
    try {
      final deviceTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(deviceTimeZone));
    } catch (_) {
      // Fallback seguro para evitar que falle la programación.
      tz.setLocalLocation(tz.getLocation('UTC'));
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

  static Future<AndroidScheduleMode> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tzScheduled = tz.TZDateTime.from(scheduledTime, tz.local);

    final safeSchedule = tzScheduled.isAfter(tz.TZDateTime.now(tz.local))
        ? tzScheduled
        : tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    final hasExactPermission = await canScheduleExactAlarms();

    try {
      final awesomeScheduled = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: _awesomeChannelKey,
          groupKey: 'activity_$id',
          title: title,
          body: body,
          customSound: 'resource://raw/actividad',
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
        return usedMode;
      }
    } catch (_) {
      // Si Awesome falla, continuamos con el fallback del plugin local.
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
      return mode;
    }

    late final AndroidScheduleMode usedMode;

    if (hasExactPermission) {
      try {
        // En Android recientes, alarmClock suele disparar con mayor consistencia.
        usedMode = await scheduleWithMode(AndroidScheduleMode.alarmClock);
      } catch (_) {
        usedMode = await scheduleWithMode(
          AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    } else {
      usedMode = await scheduleWithMode(
        AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }

    return usedMode;
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
    await _notificationsPlugin.cancel(id: id);
  }
}
