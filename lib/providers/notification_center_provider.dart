import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_notification.dart';

class NotificationCenterProvider extends ChangeNotifier {
  static const String _storageKey = 'notification_center_items';
  static final NotificationCenterProvider instance =
      NotificationCenterProvider._internal();

  NotificationCenterProvider._internal();

  List<AppNotification> _items = [];
  bool _loading = true;

  List<AppNotification> get items => List.unmodifiable(_items);
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final rawItems = prefs.getString(_storageKey);

    if (rawItems != null && rawItems.isNotEmpty) {
      final decoded = jsonDecode(rawItems) as List;
      _items = decoded
          .map((item) => AppNotification.fromJson(item as Map<String, dynamic>))
          .toList();
      _items = _normalizeItems(_items);
    } else {
      _items = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> addNotification(AppNotification notification) async {
    _items = _normalizeItems(_items);

    final index = _items.indexWhere((item) => item.id == notification.id);
    if (index >= 0) {
      final existing = _items[index];
      final incomingIsGeneric =
          notification.title == 'Notificación' && notification.body.isEmpty;
      final existingIsMoreUseful =
          existing.title != 'Notificación' || existing.body.isNotEmpty;

      if (incomingIsGeneric && existingIsMoreUseful) {
        return;
      }

      _items[index] = notification;
    } else {
      final recentMatchIndex = _items.indexWhere(
        (item) =>
            _isSameTapWindow(item.receivedAt, notification.receivedAt) &&
            (_isGenericNotification(item) ||
                _isGenericNotification(notification)),
      );

      if (recentMatchIndex >= 0) {
        final existing = _items[recentMatchIndex];
        final existingIsGeneric = _isGenericNotification(existing);
        final incomingIsGeneric = _isGenericNotification(notification);

        if (existingIsGeneric && !incomingIsGeneric) {
          _items[recentMatchIndex] = notification;
        } else if (!existingIsGeneric && incomingIsGeneric) {
          // Keep the richer existing notification.
          await _save();
          notifyListeners();
          return;
        } else {
          _items.insert(0, notification);
        }
      } else {
        _items.insert(0, notification);
      }
    }

    await _save();
    notifyListeners();
  }

  Future<void> removeNotification(int id) async {
    _items.removeWhere((item) => item.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _items.clear();
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_items.map((item) => item.toJson()).toList()),
    );
  }

  List<AppNotification> _normalizeItems(List<AppNotification> items) {
    if (items.length < 2) {
      return items;
    }

    final sortedItems = List<AppNotification>.from(items)
      ..sort((left, right) => right.receivedAt.compareTo(left.receivedAt));

    final normalized = <AppNotification>[];

    for (final current in sortedItems) {
      final nearDuplicateIndex = normalized.indexWhere(
        (existing) => _isSameTapWindow(existing.receivedAt, current.receivedAt),
      );

      if (nearDuplicateIndex >= 0) {
        final existing = normalized[nearDuplicateIndex];
        final existingIsGeneric = _isGenericNotification(existing);
        final currentIsGeneric = _isGenericNotification(current);

        if (existingIsGeneric && !currentIsGeneric) {
          normalized[nearDuplicateIndex] = current;
        }
        continue;
      }

      normalized.add(current);
    }

    return normalized;
  }

  bool _isGenericNotification(AppNotification notification) {
    return notification.title.trim() == 'Notificación' &&
        notification.body.trim().isEmpty;
  }

  bool _isSameTapWindow(DateTime left, DateTime right) {
    return left.difference(right).inMilliseconds.abs() <= 1500;
  }
}
