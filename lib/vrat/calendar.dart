import '../engine/engine.dart';
import 'observance.dart';
import 'rules.dart';

/// Ekadashi names by month. Printed almanacs name them by purnimanta month,
/// so the Krishna paksha Ekadashi of amanta month `m` takes the name of
/// purnimanta month `m + 1`.
const shuklaEkadashi = [
  'kamada', 'mohini', 'nirjala', 'devshayani', 'shravana_putrada', 'parsva', //
  'papankusha', 'devutthana', 'mokshada', 'pausha_putrada', 'jaya', 'amalaki',
];
const krishnaEkadashi = [
  'papmochani', 'varuthini', 'apara', 'yogini', 'kamika', 'aja', //
  'indira', 'rama', 'utpanna', 'saphala', 'shattila', 'vijaya',
];

/// A tithi with the lunar month it belongs to.
class _Tithi {
  _Tithi(this.seg, this.month, this.adhika);

  final Segment seg;
  final int month;
  final bool adhika;
}

typedef _Window = ({DateTime start, DateTime end});

class _Day {
  _Day(this.date, this.sunrise, this.sunset);

  final DateTime date;
  final DateTime sunrise, sunset;
  DateTime? nextSunrise;
  bool? moonriseDone;
  DateTime? moonrise;

  Duration get length => sunset.difference(sunrise);
}

/// Computes the vrats and festivals of a period for one place, using the
/// rules in `rules.dart`.
class VratCalendar {
  VratCalendar(this.place);

  final Place place;

  final _days = <int, _Day>{};

  static int _ordinal(DateTime d) => DateTime.utc(d.year, d.month, d.day).millisecondsSinceEpoch ~/ 86400000;

  DateTime _civil(DateTime utc) {
    final l = place.toLocal(utc);
    return DateTime.utc(l.year, l.month, l.day);
  }

  _Day _day(DateTime date) {
    return _days.putIfAbsent(_ordinal(date), () {
      final r = Sky.sun(place, date.year, date.month, date.day);
      final start = place.startOfDay(date.year, date.month, date.day);
      return _Day(date, r.rise ?? start.add(const Duration(hours: 6)), r.set ?? start.add(const Duration(hours: 18)));
    });
  }

  DateTime _nextSunrise(_Day d) =>
      d.nextSunrise ??= _day(DateTime.utc(d.date.year, d.date.month, d.date.day + 1)).sunrise;

  DateTime? _moonrise(_Day d) {
    if (d.moonriseDone != true) {
      d.moonrise = Sky.moon(place, d.sunrise, _nextSunrise(d)).rise;
      d.moonriseDone = true;
    }
    return d.moonrise;
  }

  static Duration _part(Duration d, int num, int den) => Duration(microseconds: d.inMicroseconds * num ~/ den);

  _Window? _window(Anchor a, DateTime date) {
    final d = _day(date);
    const second = Duration(seconds: 1);
    switch (a) {
      case Anchor.sunrise:
        return (start: d.sunrise, end: d.sunrise.add(second));
      case Anchor.daytime:
        return (start: d.sunrise, end: d.sunset);
      case Anchor.forenoon:
        return (start: d.sunrise, end: d.sunrise.add(_part(d.length, 1, 2)));
      case Anchor.purvahna:
        return (start: d.sunrise, end: d.sunrise.add(_part(d.length, 1, 5)));
      case Anchor.madhyahna:
        return (start: d.sunrise.add(_part(d.length, 2, 5)), end: d.sunrise.add(_part(d.length, 3, 5)));
      case Anchor.aparahna:
        return (start: d.sunrise.add(_part(d.length, 3, 5)), end: d.sunrise.add(_part(d.length, 4, 5)));
      case Anchor.pradosh:
        return (start: d.sunset, end: d.sunset.add(const Duration(hours: 2, minutes: 24)));
      case Anchor.nishita:
        final night = _nextSunrise(d).difference(d.sunset);
        return (start: d.sunset.add(_part(night, 7, 15)), end: d.sunset.add(_part(night, 8, 15)));
      case Anchor.moonrise:
        final m = _moonrise(d);
        return m == null ? null : (start: m, end: m.add(second));
    }
  }

  /// Time inside [seg] and [w] that is not under one of the [exclude] spans.
  static Duration _overlap(Segment seg, _Window w, List<_Window> exclude) {
    final a = seg.start.isAfter(w.start) ? seg.start : w.start;
    final b = seg.end.isBefore(w.end) ? seg.end : w.end;
    if (!b.isAfter(a)) return Duration.zero;
    var total = b.difference(a);
    for (final e in exclude) {
      final x = e.start.isAfter(a) ? e.start : a;
      final y = e.end.isBefore(b) ? e.end : b;
      if (y.isAfter(x)) total -= y.difference(x);
    }
    return total;
  }

  static bool _isVishti(int karana) => karana >= 1 && karana <= 56 && (karana - 1) % 7 == 6;

  /// Spans of Bhadra (Vishti karana) inside a tithi.
  List<_Window> _bhadra(Segment s) {
    final first = 2 * s.index, second = first + 1;
    if (!_isVishti(first) && !_isVishti(second)) return const [];
    final jd = Astro.julianDay(s.start);
    final mid = Astro.fromJulianDay(Sky.crossing(Sky.elongation, s.index * 12.0 + 6, jd + (s.end.difference(s.start).inMicroseconds / 86400e6) / 2));
    return [
      if (_isVishti(first)) (start: s.start, end: mid),
      if (_isVishti(second)) (start: mid, end: s.end),
    ];
  }

  /// The Smarta Ekadashi day as Drik Panchang lists it (null: no sunrise falls
  /// in the tithi, use the general rule).
  ///
  /// - Ekadashi at one sunrise: that day, but when it covers that sunrise
  ///   for less than one muhurta (48 min) and began in the daytime before,
  ///   the day before (Pausha Putrada 2027-01-18: Ekadashi 10:26 to 07:49,
  ///   sunrise 07:14).
  /// - Ekadashi at two sunrises: the first day, unless Dashami is still
  ///   running within three muhurtas (2 h 24 min) before that sunrise
  ///   (viddha), then the second (Padmini 2026-05-27, Vijaya 2027-03-04).
  ///   Drik's own cut-off is not published; 144 min fits both known cases
  ///   (Ekadashi began 13 and 119 min before the sunrise).
  DateTime? _pickEkadashi(Segment seg) {
    final rises = <DateTime>[];
    for (var d = _civil(seg.start).subtract(const Duration(days: 1)); !d.isAfter(_civil(seg.end)); d = DateTime.utc(d.year, d.month, d.day + 1)) {
      final r = _day(d).sunrise;
      if (!r.isBefore(seg.start) && r.isBefore(seg.end)) rises.add(d);
    }
    if (rises.isEmpty) return null;
    if (rises.length >= 2) {
      final viddha = seg.start.isAfter(_day(rises.first).sunrise.subtract(const Duration(minutes: 144)));
      return viddha ? rises[1] : rises.first;
    }
    final d = rises.single;
    final prev = _day(DateTime.utc(d.year, d.month, d.day - 1));
    final short = seg.end.difference(_day(d).sunrise) < const Duration(minutes: 48);
    final beganByDay = seg.start.isAfter(prev.sunrise) && seg.start.isBefore(prev.sunset);
    return short && beganByDay ? prev.date : d;
  }

  /// The civil day on which [rule] is observed for the tithi [seg].
  DateTime _pick(Rule rule, Segment seg) {
    if (rule.id == 'ekadashi') {
      final d = _pickEkadashi(seg);
      if (d != null) return d;
    }
    final firstDay = _civil(seg.start).subtract(const Duration(days: 1));
    final lastDay = _civil(seg.end).add(const Duration(days: 1));
    final exclude = rule.bhadraFree ? _bhadra(seg) : const <_Window>[];

    final atLeast = rule.firstDayAtLeast;
    if (atLeast != null) {
      for (var d = firstDay; !d.isAfter(lastDay); d = DateTime.utc(d.year, d.month, d.day + 1)) {
        final w = _window(rule.anchor, d);
        if (w != null && _overlap(seg, w, const []) >= atLeast) return d;
      }
    }

    DateTime? best;
    var bestOverlap = Duration.zero;
    DateTime? lastPlain; // last day on which the tithi meets the anchor at all
    for (var d = firstDay; !d.isAfter(lastDay); d = DateTime.utc(d.year, d.month, d.day + 1)) {
      final w = _window(rule.anchor, d);
      if (w == null) continue;
      if (_overlap(seg, w, const []) > Duration.zero) lastPlain = d;
      final o = _overlap(seg, w, exclude);
      if (o > bestOverlap) {
        best = d;
        bestOverlap = o;
      }
    }
    if (best != null) return best;
    // Bhadra covers the whole anchor (Holika Dahan, Raksha Bandhan): the next day.
    if (rule.bhadraFree && lastPlain != null) {
      final next = lastPlain.add(const Duration(days: 1));
      // Holika Dahan: the next day only while the Purnima still reaches into
      // its evening (within 96 minutes of sunset). If it ended well before
      // that, the dahan is kept on the day Bhadra covered (in Bhadra's
      // tail), as Drik does: 2026 is 03-03 (Purnima ends 74 min before
      // sunset), 2027 is 03-21 (it ends 139 min before).
      if (rule.anchor == Anchor.pradosh && !seg.end.isAfter(_day(next).sunset.subtract(const Duration(minutes: 96)))) {
        return lastPlain;
      }
      return next;
    }
    // The tithi never meets the anchor: the day with most daylight in it.
    for (var d = firstDay; !d.isAfter(lastDay); d = DateTime.utc(d.year, d.month, d.day + 1)) {
      final w = _window(Anchor.daytime, d)!;
      final o = _overlap(seg, w, const []);
      if (o > bestOverlap) {
        best = d;
        bestOverlap = o;
      }
    }
    return best ?? _civil(seg.start);
  }

  /// Makar Sankranti: the day the Sun enters sidereal Makara; if that
  /// happens after sunset the next day is kept (the punya kala is next day).
  Observance? _makarSankranti(int year, List<_Tithi> tithis) {
    final guess = Astro.julianDay(DateTime.utc(year, 1, 14, 12));
    final t = Astro.fromJulianDay(Sky.crossing(Sky.sunSidereal, 270, guess));
    var date = _civil(t);
    if (t.isAfter(_day(date).sunset)) date = DateTime.utc(date.year, date.month, date.day + 1);
    final host = tithis.firstWhere((x) => x.seg.contains(t), orElse: () => tithis.first);
    return Observance(
      id: 'makar_sankranti',
      kind: ObsKind.festival,
      date: date,
      tithi: host.seg,
      amantaMonth: host.month,
      adhika: host.adhika,
    );
  }

  /// All observances whose date falls in `[from, to]` (civil dates).
  List<Observance> build(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    final t0 = place.startOfDay(from.year, from.month, from.day).subtract(const Duration(days: 45));
    final t1 = place.startOfDay(to.year, to.month, to.day).add(const Duration(days: 50));
    final segs = Elements.tithis(t0, t1);

    // Lunar month of every tithi, from the new moons (tithi 0 starts).
    final tithis = <_Tithi>[];
    final starts = [for (var i = 0; i < segs.length; i++) if (segs[i].index == 0) i];
    for (var k = 0; k + 1 < starts.length; k++) {
      final a = segs[starts[k]].start, b = segs[starts[k + 1]].start;
      final s0 = (Sky.sunSidereal(Astro.julianDay(a)) / 30).floor() % 12;
      final s1 = (Sky.sunSidereal(Astro.julianDay(b)) / 30).floor() % 12;
      for (var i = starts[k]; i < starts[k + 1]; i++) {
        tithis.add(_Tithi(segs[i], (s0 + 1) % 12, s0 == s1));
      }
    }

    final out = <Observance>[];
    bool inRange(DateTime d) => !d.isBefore(from) && !d.isAfter(to);

    for (final t in tithis) {
      for (final rule in rules) {
        if (!rule.tithis.contains(t.seg.index)) continue;
        if (rule.month != null && rule.month != t.month) continue;
        if (rule.exceptMonths.contains(t.month)) continue;
        if (t.adhika && !rule.adhika) continue;
        final date = _pick(rule, t.seg);
        if (!inRange(date) && !(rule.id == 'holika_dahan' && inRange(date.add(const Duration(days: 1))))) continue;
        final obs = _make(rule, t, date, tithis);
        if (inRange(date)) out.add(obs);
        if (rule.id == 'holika_dahan') {
          final holi = DateTime.utc(date.year, date.month, date.day + 1);
          if (inRange(holi)) {
            out.add(Observance(
              id: 'holi',
              kind: ObsKind.festival,
              date: holi,
              tithi: Elements.tithiSegmentAt(_day(holi).sunrise),
              amantaMonth: t.month,
              adhika: false,
            ));
          }
        }
      }
    }
    for (var y = from.year; y <= to.year; y++) {
      final m = _makarSankranti(y, tithis);
      if (m != null && inRange(m.date)) out.add(m);
    }
    out.sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.key.compareTo(b.key);
    });
    return out;
  }

  Observance _make(Rule rule, _Tithi t, DateTime date, List<_Tithi> all) {
    final day = _day(date);
    DateTime? moonrise;
    if (rule.anchor == Anchor.moonrise || rule.id == 'purnima') moonrise = _moonrise(day);

    String? variant;
    TimeWindow? parana;
    DateTime? hariVasara;
    if (rule.id == 'ekadashi') {
      final shukla = t.seg.index < 15;
      variant = t.adhika
          ? (shukla ? 'padmini' : 'parama')
          : (shukla ? shuklaEkadashi[t.month] : krishnaEkadashi[(t.month + 1) % 12]);
      // Dwadashi follows Ekadashi; Hari Vasara is its first quarter.
      final dw = all.where((x) => x.seg.start == t.seg.end).firstOrNull?.seg;
      if (dw != null) {
        final quarter = Duration(microseconds: dw.end.difference(dw.start).inMicroseconds ~/ 4);
        hariVasara = dw.start.add(quarter);
        final next = _day(DateTime.utc(date.year, date.month, date.day + 1));
        final start = next.sunrise.isAfter(hariVasara) ? next.sunrise : hariVasara;
        // Parana in the morning (first fifth of the day) if possible,
        // otherwise up to the end of madhyahna; never after Dwadashi ends.
        final morningEnd = next.sunrise.add(_part(next.length, 1, 5));
        final cap = start.isBefore(morningEnd) ? morningEnd : next.sunrise.add(_part(next.length, 3, 5));
        final end = dw.end.isBefore(cap) ? dw.end : cap;
        parana = TimeWindow(start, end.isAfter(start) ? end : start);
      }
    }
    // Monthly rules renamed by month.
    return Observance(
      id: rule.id,
      kind: rule.kind,
      date: date,
      tithi: t.seg,
      amantaMonth: t.month,
      adhika: t.adhika,
      moonrise: moonrise,
      parana: parana,
      hariVasaraEnd: hariVasara,
      variant: variant,
    );
  }
}
