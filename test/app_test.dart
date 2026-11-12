import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme/theme.dart';
import 'package:vrat/app/app_model.dart';
import 'package:vrat/data/places.dart';
import 'package:vrat/engine/engine.dart';
import 'package:vrat/main.dart';
import 'package:vrat/notify/home_widget.dart';
import 'package:vrat/notify/reminders.dart';
import 'package:vrat/ui/upcoming_page.dart';
import 'package:vrat/vrat/calendar.dart';
import 'package:vrat/vrat/observance.dart';

const delhi = Place(name: 'New Delhi', region: 'Delhi, India', latitude: 28.6356, longitude: 77.2244, standardOffsetMinutes: 330);

/// A reminders service that records instead of notifying.
class FakeReminders extends Reminders {
  int calls = 0;

  @override
  Future<void> schedule({
    required List<Observance> items,
    required Place place,
    required bool hindi,
    int? eveningMinutes,
    int? morningMinutes,
  }) async {
    calls++;
  }

  @override
  Future<bool> get enabled async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  UiTypography.useGoogleFonts = false;

  test('widget payload keeps only the next 60 days, with ISO dates', () {
    final all = VratCalendar(delhi).build(DateTime.utc(2026, 11, 1), DateTime.utc(2027, 3, 31));
    final today = DateTime.utc(2026, 11, 12);
    final json = jsonDecode(widgetPayload(items: all, today: today, hindi: false)) as Map<String, dynamic>;
    final items = (json['items'] as List).cast<Map<String, dynamic>>();
    expect(items, isNotEmpty);
    expect(items.length, lessThanOrEqualTo(12));
    final end = today.add(const Duration(days: widgetDays));
    for (final i in items) {
      final d = DateTime.parse('${i['d']}T00:00:00Z');
      expect(d.isBefore(today) || d.isAfter(end), isFalse);
      expect(i['n'], isNotEmpty);
    }
    expect(json['hindi'], false);
  });

  group('reminder plan', () {
    final all = VratCalendar(delhi).build(DateTime.utc(2026, 11, 1), DateTime.utc(2026, 12, 31));
    final now = DateTime.utc(2026, 11, 11);

    test('evening before and morning of, at the chosen local times', () {
      final diwali = all.where((o) => o.id == 'devutthana' || o.variant == 'devutthana').toList();
      expect(diwali, hasLength(1)); // Dev Uthani Ekadashi, 2026-11-20
      final plan = planReminders(
        items: diwali,
        place: delhi,
        hindi: false,
        now: now,
        eveningMinutes: 20 * 60,
        morningMinutes: 6 * 60 + 30,
      );
      expect(plan, hasLength(2));
      final evening = delhi.toLocal(plan[0].at), morning = delhi.toLocal(plan[1].at);
      expect((evening.year, evening.month, evening.day, evening.hour, evening.minute), (2026, 11, 19, 20, 0));
      expect((morning.year, morning.month, morning.day, morning.hour, morning.minute), (2026, 11, 20, 6, 30));
      expect(plan[0].title, startsWith('Tomorrow: '));
      expect(plan[1].title, startsWith('Today: '));
      expect(plan[0].body, contains('Parana'));
      expect(plan[0].id, isNot(plan[1].id));
    });

    test('Hindi text, past reminders dropped, limit respected, toggles respected', () {
      final hi = planReminders(items: all, place: delhi, hindi: true, now: now, eveningMinutes: 1200, morningMinutes: 390, limit: 5);
      expect(hi, hasLength(5));
      expect(hi.first.title, anyOf(startsWith('कल: '), startsWith('आज: ')));
      expect(hi.every((r) => r.at.isAfter(now)), isTrue);
      expect(hi.map((r) => r.at).toList(), [...hi.map((r) => r.at)]..sort());
      final none = planReminders(items: all, place: delhi, hindi: false, now: now);
      expect(none, isEmpty);
      final ids = planReminders(items: all, place: delhi, hindi: false, now: now, eveningMinutes: 1200, morningMinutes: 390).map((r) => r.id);
      expect(ids.toSet().length, ids.length);
    });
  });

  test('city list loads, settings are remembered', () async {
    SharedPreferences.setMockInitialValues({});
    final places = await Places.load();
    expect(places.nearest(28.5, 77.4).name, 'Noida');
    final m = await AppModel.load(reminders: FakeReminders());
    expect(m.hindi, isFalse);
    expect(m.follow, containsAll(['ekadashi', 'diwali']));
    m
      ..hindi = true
      ..setFollow('pradosh', false)
      ..eveningMinutes = 19 * 60
      ..remindMorning = false;
    final again = await AppModel.load(reminders: FakeReminders());
    expect(again.hindi, isTrue);
    expect(again.follow.contains('pradosh'), isFalse);
    expect(again.eveningMinutes, 19 * 60);
    expect(again.remindMorning, isFalse);
  });

  testWidgets('upcoming list, detail and language switch', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final fake = FakeReminders();
    final model = await AppModel.load(reminders: fake);
    tester.view
      ..physicalSize = const Size(800, 3200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.runAsync(() async {
      await tester.pumpWidget(VratApp(model: model));
      await model.refresh();
    });
    await tester.pump(const Duration(milliseconds: 300));
    expect(model.all, isNotEmpty);
    expect(fake.calls, greaterThan(0));
    expect(find.text('Coming up'), findsOneWidget);

    await tester.tap(find.descendant(of: find.byType(UpcomingPage), matching: find.byType(UiListTile)).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Significance'), findsOneWidget);
    expect(find.text('How it is observed'), findsOneWidget);
    await tester.pageBack();
    await tester.pump(const Duration(milliseconds: 400));

    model.hindi = true;
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('आगामी'), findsWidgets);
    await tester.tap(find.text('कैलेंडर'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('इस महीने'), findsWidgets);
  });
}
