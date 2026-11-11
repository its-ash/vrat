import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../engine/engine.dart';
import '../vrat/catalog.dart';
import '../vrat/observance.dart';

/// One notification to be shown at [at] (UTC instant).
class PlannedReminder {
  const PlannedReminder(this.id, this.at, this.title, this.body);

  final int id;
  final DateTime at;
  final String title, body;
}

/// Decides which reminders to schedule: the evening before and the morning
/// of each observance, at the chosen local times of [place], from [now] on,
/// at most [limit] of them (the nearest ones).
List<PlannedReminder> planReminders({
  required List<Observance> items,
  required Place place,
  required bool hindi,
  required DateTime now,
  int? eveningMinutes,
  int? morningMinutes,
  int limit = 120,
}) {
  String t(String en, String hi) => hindi ? hi : en;
  String clock(DateTime utc) {
    final l = place.toLocal(utc);
    final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
    return '$h:${l.minute.toString().padLeft(2, '0')} ${l.hour < 12 ? 'AM' : 'PM'}';
  }

  String detail(Observance o) {
    if (o.parana != null) {
      final p = o.parana!;
      return t('Parana next morning: ${clock(p.start)} to ${clock(p.end)}', 'पारण अगली सुबह: ${clock(p.start)} से ${clock(p.end)}');
    }
    if (o.moonrise != null && (o.kind == ObsKind.sankashti || o.id == 'karwa_chauth')) {
      return t('Moonrise: ${clock(o.moonrise!)}', 'चंद्रोदय: ${clock(o.moonrise!)}');
    }
    return t('Tap to see the timings and how it is observed.', 'समय और विधि देखने के लिए दबाएँ।');
  }

  final out = <PlannedReminder>[];
  for (final o in items) {
    final name = nameOf(o).of(hindi);
    final key = o.key.hashCode & 0x3fffffff;
    if (eveningMinutes != null) {
      final prev = DateTime.utc(o.date.year, o.date.month, o.date.day - 1);
      final at = place.startOfDay(prev.year, prev.month, prev.day).add(Duration(minutes: eveningMinutes));
      if (at.isAfter(now)) out.add(PlannedReminder(key * 2, at, t('Tomorrow: $name', 'कल: $name'), detail(o)));
    }
    if (morningMinutes != null) {
      final at = place.startOfDay(o.date.year, o.date.month, o.date.day).add(Duration(minutes: morningMinutes));
      if (at.isAfter(now)) out.add(PlannedReminder(key * 2 + 1, at, t('Today: $name', 'आज: $name'), detail(o)));
    }
  }
  out.sort((a, b) => a.at.compareTo(b.at));
  return out.take(limit).toList();
}

/// Local notifications through `flutter_local_notifications`. Scheduled ones
/// survive a reboot (the plugin's boot receiver restores them).
class Reminders {
  Reminders({FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  Future<void> init() async {
    if (_ready) return;
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(android: AndroidInitializationSettings('@drawable/ic_notification')),
      );
      _ready = true;
    } catch (e) {
      debugPrint('Notifications unavailable: $e');
    }
  }

  /// Asks for the notification permission (Android 13+). True when allowed.
  Future<bool> requestPermission() async {
    await init();
    try {
      return await _android?.requestNotificationsPermission() ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get enabled async {
    await init();
    try {
      return await _android?.areNotificationsEnabled() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Replaces all scheduled reminders with the plan for [items].
  Future<void> schedule({
    required List<Observance> items,
    required Place place,
    required bool hindi,
    int? eveningMinutes,
    int? morningMinutes,
  }) async {
    await init();
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
      if (eveningMinutes == null && morningMinutes == null) return;
      if (!await enabled) return;
      final plan = planReminders(
        items: items,
        place: place,
        hindi: hindi,
        now: DateTime.now().toUtc(),
        eveningMinutes: eveningMinutes,
        morningMinutes: morningMinutes,
      );
      // Exact alarms need a special permission on Android 12+; fall back to
      // inexact ones (a few minutes late at worst) when it is not granted.
      final exact = await _android?.canScheduleExactNotifications() ?? false;
      final mode = exact ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle;
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'vrat_reminders',
          'Vrat and festival reminders',
          channelDescription: 'The evening before and the morning of a vrat or festival',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
      );
      for (final r in plan) {
        await _plugin.zonedSchedule(
          id: r.id,
          scheduledDate: tz.TZDateTime.from(r.at, tz.UTC),
          notificationDetails: details,
          androidScheduleMode: mode,
          title: r.title,
          body: r.body,
        );
      }
    } catch (e) {
      debugPrint('Could not schedule reminders: $e');
    }
  }

  Future<void> requestExactAlarms() async {
    try {
      await _android?.requestExactAlarmsPermission();
    } catch (_) {}
  }
}
