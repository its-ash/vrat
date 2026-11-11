import 'package:flutter_test/flutter_test.dart';
import 'package:vrat/app/app_model.dart';
import 'package:vrat/engine/engine.dart';
import 'package:vrat/vrat/calendar.dart';
import 'package:vrat/vrat/catalog.dart';
import 'package:vrat/vrat/observance.dart';
import 'package:vrat/vrat/rules.dart';

import 'reference.dart';

/// New Delhi as on the Drik Panchang pages (28 deg 38' N, 77 deg 13' E).
const delhi = Place(
  name: 'New Delhi',
  region: 'Delhi, India',
  latitude: 28.6356,
  longitude: 77.2244,
  standardOffsetMinutes: 330,
);

String md(DateTime d) => '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

late final List<Observance> obs;

List<Observance> of(String id, int year) => [for (final o in obs) if (o.id == id && o.date.year == year) o];

void main() {
  setUpAll(() {
    obs = VratCalendar(delhi).build(DateTime.utc(2025, 1, 1), DateTime.utc(2027, 12, 31));
  });

  void sameDates(String id, List<String> a26, List<String> a27, [String? also]) {
    for (final (y, ref) in [(2026, a26), (2027, a27)]) {
      final got = [...of(id, y), if (also != null) ...of(also, y)].map((o) => md(o.date)).toList()..sort();
      expect(got, ref, reason: '$id $y');
    }
  }

  group('monthly vrats match Drik Panchang (New Delhi, 2026 and 2027)', () {
    test('Pradosh', () => sameDates('pradosh', pradosh2026, pradosh2027));
    test('Purnima (vrat day)', () => sameDates('purnima', purnima2026, purnima2027));
    test('Amavasya', () => sameDates('amavasya', amavasya2026, amavasya2027));
    test('Vinayaka Chaturthi (incl. Ganesh Chaturthi)', () => sameDates('vinayaka', vinayaka2026, vinayaka2027, 'ganesh_chaturthi'));
    test('Masik Shivratri (incl. Maha Shivratri)', () => sameDates('masik_shivratri', masikShivratri2026, masikShivratri2027, 'maha_shivratri'));
    test('Masik Durgashtami (incl. Durga Ashtami)', () => sameDates('masik_durgashtami', masikDurgashtami2026, masikDurgashtami2027, 'durga_ashtami'));
    test('Sankashti Chaturthi (incl. Karwa Chauth)', () => sameDates('sankashti', sankashti2026.keys.toList(), sankashti2027.keys.toList(), 'karwa_chauth'));

    test('Sankashti moonrise within 2 minutes of Drik', () {
      for (final (y, ref) in [(2026, sankashti2026), (2027, sankashti2027)]) {
        for (final o in [...of('sankashti', y), ...of('karwa_chauth', y)]) {
          final want = ref[md(o.date)]!.split(':');
          final expected = DateTime.utc(o.date.year, o.date.month, o.date.day, int.parse(want[0]), int.parse(want[1]));
          final diff = delhi.toLocal(o.moonrise!).difference(expected).inSeconds.abs() / 60;
          expect(diff, lessThanOrEqualTo(2.0), reason: '${o.key} moonrise ${delhi.toLocal(o.moonrise!)} vs $expected');
        }
      }
    });

    test('Ekadashi: Smarta date and name, all 49 (2026 and 2027)', () {
      var bad = <String>[];
      for (final (y, ref) in [(2026, ekadashi2026), (2027, ekadashi2027)]) {
        final got = {for (final o in of('ekadashi', y)) md(o.date): o.variant};
        expect(got.length, ref.length, reason: 'count $y');
        for (final e in ref.entries) {
          if (got[e.key] != e.value) bad = [...bad, '$y ${e.key} ${e.value} -> ${got[e.key]}'];
        }
      }
      expect(bad, isEmpty);
    });
  });

  group('festivals', () {
    test('dates named in the brief', () {
      expect(of('diwali', 2025).map((o) => md(o.date)), ['10-20']);
      expect(of('holi', 2026).map((o) => md(o.date)), ['03-04']);
      expect(of('maha_shivratri', 2026).map((o) => md(o.date)), ['02-15']);
      expect(of('janmashtami', 2025).map((o) => md(o.date)), ['08-16']);
    });

    test('2026 and 2027 festival dates match Drik (all 44)', () {
      final bad = <String>[];
      for (final e in festivals.entries) {
        for (final (y, want) in [(2026, e.value.$1), (2027, e.value.$2)]) {
          final got = of(e.key, y).map((o) => md(o.date)).toList();
          if (got.length != 1 || got.single != want) bad.add('${e.key} $y want $want got $got');
        }
      }
      expect(bad, isEmpty);
    });

    test('Holika Dahan and Bhadra: 2026 is 03-03 (not 03-02), 2027 is 03-21 (not 03-22)', () {
      expect(of('holika_dahan', 2026).single.date, DateTime.utc(2026, 3, 3));
      expect(of('holika_dahan', 2027).single.date, DateTime.utc(2027, 3, 21));
    });

    test('Makar Sankranti is the Sun entering Makara', () {
      expect(of('makar_sankranti', 2026).single.date, DateTime.utc(2026, 1, 14));
      expect(of('makar_sankranti', 2027).single.date, DateTime.utc(2027, 1, 15));
    });

    test('no festival is placed in an adhika month (2026 has Adhika Jyeshtha)', () {
      for (final o in obs.where((o) => o.kind == ObsKind.festival)) {
        expect(o.adhika, isFalse, reason: o.key);
      }
    });
  });

  group('Ekadashi parana', () {
    test('Nirjala 2026-06-25: parana next morning, after Hari Vasara and before Dwadashi ends', () {
      final o = of('ekadashi', 2026).firstWhere((o) => o.variant == 'nirjala');
      final p = o.parana!;
      expect(p.start.isBefore(p.end), isTrue);
      final day = delhi.startOfDay(2026, 6, 26);
      expect(p.start.isBefore(day.add(const Duration(hours: 8))) || p.start.isAfter(day), isTrue);
      expect(p.start.isBefore(day.add(const Duration(hours: 20))), isTrue);
      expect(!p.start.isBefore(o.hariVasaraEnd!), isTrue);
      // The window lies on the day after the fast.
      expect(delhi.toLocal(p.start).day, 26);
    });

    test('every Ekadashi has a parana window on the following day', () {
      for (final o in obs.where((o) => o.id == 'ekadashi')) {
        expect(o.parana, isNotNull, reason: o.key);
        final next = DateTime.utc(o.date.year, o.date.month, o.date.day + 1);
        final local = delhi.toLocal(o.parana!.start);
        expect(DateTime.utc(local.year, local.month, local.day), next, reason: o.key);
        expect(o.parana!.start.isBefore(o.parana!.end) || o.parana!.start == o.parana!.end, isTrue);
      }
    });
  });

  group('catalog', () {
    test('every rule and every Ekadashi name has a text in both languages', () {
      for (final r in [...rules.map((r) => r.id), 'holi', 'makar_sankranti']) {
        final i = catalog[r];
        expect(i, isNotNull, reason: r);
        for (final b in [i!.name, i.about, i.observe]) {
          expect(b.en.isNotEmpty && b.hi.isNotEmpty, isTrue, reason: r);
        }
      }
      for (final v in [...shuklaEkadashi, ...krishnaEkadashi, 'padmini', 'parama']) {
        expect(ekadashiNames[v], isNotNull, reason: v);
      }
      for (final o in obs) {
        expect(infoOf(o).name.en, isNotEmpty);
      }
    });

    test('every festival can be followed', () {
      final ids = obs.where((o) => o.kind == ObsKind.festival).map((o) => o.id).toSet();
      expect(AppModel.allFestivalIds.toSet(), ids);
    });
  });

  test('the calendar also works abroad (London, with summer time)', () {
    const london = Place(name: 'London', region: 'United Kingdom', latitude: 51.51, longitude: -0.13, standardOffsetMinutes: 0);
    final list = VratCalendar(london).build(DateTime.utc(2026, 1, 1), DateTime.utc(2026, 12, 31));
    expect(list.where((o) => o.id == 'ekadashi'), hasLength(24));
    expect(list.where((o) => o.id == 'diwali'), hasLength(1));
  });
}
