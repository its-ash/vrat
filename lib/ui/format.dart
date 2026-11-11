import '../app/app_model.dart';
import '../data/names.dart';
import '../engine/engine.dart';
import '../vrat/catalog.dart';
import '../vrat/observance.dart';

/// Formatting of times and dates for the current place and language.
extension Formatting on AppModel {
  /// "6:59 AM". When the local date differs from [day] the date is added.
  String clock(DateTime utc, {DateTime? day}) {
    final l = place.toLocal(utc);
    final h12 = l.hour % 12 == 0 ? 12 : l.hour % 12;
    final text = '$h12:${l.minute.toString().padLeft(2, '0')} ${l.hour < 12 ? 'AM' : 'PM'}';
    if (day != null && (l.day != day.day || l.month != day.month)) {
      return '$text, ${l.day} ${bi(Names.monthNames[l.month - 1]).substring(0, hindi ? null : 3)}';
    }
    return text;
  }

  String clockOfMinutes(int minutes) {
    final h = minutes ~/ 60, m = minutes % 60;
    return '${h % 12 == 0 ? 12 : h % 12}:${m.toString().padLeft(2, '0')} ${h < 12 ? 'AM' : 'PM'}';
  }

  String range(TimeWindow w, {DateTime? day}) => '${clock(w.start, day: day)} - ${clock(w.end, day: day)}';

  /// "Sunday, 15 February 2026".
  String longDate(DateTime d) =>
      '${bi(Names.vaar[d.weekday]!).split(' ').first}, ${d.day} ${bi(Names.monthNames[d.month - 1])} ${d.year}';

  String monthYear(int year, int month) => '${bi(Names.monthNames[month - 1])} $year';

  String name(Observance o) => nameOf(o).of(hindi);

  /// "Krishna Trayodashi".
  String tithiWithPaksha(int index) {
    final p = index < 15 ? t('Shukla', 'शुक्ल') : t('Krishna', 'कृष्ण');
    return '$p ${bi(Names.tithiOf(index))}';
  }

  /// "Magha (Adhika)".
  String monthLabel(Observance o) {
    final n = bi(Names.month[o.amantaMonth]);
    return o.adhika ? '${t('Adhika', 'अधिक')} $n' : n;
  }

  /// Days from today to [date]: "Today", "Tomorrow", "in 12 days".
  String inDays(DateTime date) {
    final n = DateTime.now();
    final d = date.difference(DateTime.utc(n.year, n.month, n.day)).inDays;
    if (d == 0) return t('Today', 'आज');
    if (d == 1) return t('Tomorrow', 'कल');
    return t('in $d days', '$d दिन बाद');
  }
}
