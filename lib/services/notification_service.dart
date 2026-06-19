import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide GroupAlertBehavior;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/app_notification.dart';
import '../providers/notification_center_provider.dart';
import 'dart:convert';

class NotificationService {
  static const String _awesomeChannelKey = 'pet_activities_channel_v6';
  static Future<void>? _initFuture;

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        'pet_activities_v6',
        'Actividades de Mascotas',
        channelDescription: 'Notificaciones de actividades de mascotas',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

  static Future<void> initialize() async {
    if (_initFuture != null) {
      return _initFuture!;
    }

    _initFuture = _initializeInternal();
    return _initFuture!;
  }

  static Future<void> _initializeInternal() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onLocalNotificationResponse,
    );

    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: _awesomeChannelKey,
        channelName: 'Actividades de Mascotas',
        channelDescription: 'Notificaciones de actividades de mascotas',
        importance: NotificationImportance.Max,
        playSound: true,
        enableVibration: true,
        onlyAlertOnce: false,
        groupAlertBehavior: GroupAlertBehavior.All,
      ),
    ]);

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onAwesomeActionReceived,
    );

    final launchDetails = await _notificationsPlugin
        .getNotificationAppLaunchDetails();
    final response = launchDetails?.notificationResponse;
    if (launchDetails?.didNotificationLaunchApp == true && response != null) {
      final payload = _decodePayload(response.payload);
      await _storeNotificationFromTap(
        id: response.id ?? DateTime.now().millisecondsSinceEpoch,
        title: payload['title'] ?? 'Notificación',
        body: payload['body'] ?? '',
      );
    }
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
    await initialize();
    await configureLocalTimeZone();
    await requestPlatformPermissions();

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
          payload: {'id': '$id', 'title': title, 'body': body},
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
        payload: jsonEncode({'id': id, 'title': title, 'body': body}),
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

  @pragma('vm:entry-point')
  static Future<void> _onLocalNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = _decodePayload(response.payload);
    await _storeNotificationFromTap(
      id: response.id ?? DateTime.now().millisecondsSinceEpoch,
      title: payload['title'] ?? 'Notificación',
      body: payload['body'] ?? '',
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _onAwesomeActionReceived(ReceivedAction action) async {
    final payload = _decodePayload(jsonEncode(action.payload ?? const {}));
    await _storeNotificationFromTap(
      id: action.id ?? DateTime.now().millisecondsSinceEpoch,
      title: payload['title'] ?? action.title ?? 'Notificación',
      body: payload['body'] ?? action.body ?? '',
    );
  }

  static Future<void> _storeNotificationFromTap({
    required int id,
    required String title,
    required String body,
  }) async {
    await NotificationCenterProvider.instance.addNotification(
      AppNotification(
        id: id,
        title: title,
        body: body,
        receivedAt: DateTime.now(),
      ),
    );
  }

  static Map<String, dynamic> _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return const {};
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Si el payload no es JSON, ignoramos el contenido extra.
    }

    return const {};
  }
}
