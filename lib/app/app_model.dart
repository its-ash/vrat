import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/names.dart';
import '../engine/engine.dart';
import '../notify/home_widget.dart';
import '../notify/reminders.dart';
import '../vrat/calendar.dart';
import '../vrat/observance.dart';

/// Which observances can be followed: each festival on its own, and the
/// monthly vrats by kind.
String followKey(Observance o) => o.kind == ObsKind.festival ? o.id : o.kind.name;

/// App state: language, place, what to follow, reminder times, and the
/// computed observances. Saved in `shared_preferences`.
class AppModel extends ChangeNotifier {
  AppModel._(this._prefs, this._hindi, this._place, this._follow, this._eveningMinutes, this._morningMinutes,
      this._remindEvening, this._remindMorning, this.reminders);

  final SharedPreferences _prefs;
  final Reminders reminders;
  final HomeWidgetSync widget = const HomeWidgetSync();
  bool _hindi;
  Place _place;
  final Set<String> _follow;
  int _eveningMinutes, _morningMinutes;
  bool _remindEvening, _remindMorning;

  /// Everything computed for this year and the next at the current place.
  List<Observance> _all = const [];
  bool _loading = true;
  int _generation = 0;

  /// Monthly vrats followed by default. Festivals are all followed.
  static const defaultKinds = {'ekadashi', 'pradosh', 'purnima', 'amavasya', 'sankashti', 'masikShivratri'};

  static Future<AppModel> load({SharedPreferences? prefs, Reminders? reminders}) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    Place? place;
    final raw = p.getString('place');
    if (raw != null) {
      try {
        place = Place.fromJson(jsonDecode(raw));
      } on FormatException {
        place = null;
      }
    }
    final saved = p.getStringList('follow');
    final model = AppModel._(
      p,
      p.getBool('hindi') ?? false,
      place ?? Place.newDelhi,
      saved?.toSet() ?? {...defaultKinds, ...allFestivalIds},
      p.getInt('eveningMinutes') ?? 20 * 60,
      p.getInt('morningMinutes') ?? 6 * 60 + 30,
      p.getBool('remindEvening') ?? true,
      p.getBool('remindMorning') ?? true,
      reminders ?? Reminders(),
    );
    return model;
  }

  /// The ids of the festivals the calendar can produce.
  static const allFestivalIds = [
    'makar_sankranti', 'vasant_panchami', 'maha_shivratri', 'holika_dahan', 'holi', 'chaitra_navratri',
    'ram_navami', 'hanuman_jayanti', 'akshaya_tritiya', 'guru_purnima', 'raksha_bandhan', 'janmashtami',
    'ganesh_chaturthi', 'sharad_navratri', 'durga_ashtami', 'dussehra', 'karwa_chauth', 'dhanteras', 'diwali',
    'govardhan_puja', 'bhai_dooj', 'chhath',
  ];

  // ---- settings -----------------------------------------------------------

  bool get hindi => _hindi;
  Place get place => _place;
  Set<String> get follow => _follow;
  int get eveningMinutes => _eveningMinutes;
  int get morningMinutes => _morningMinutes;
  bool get remindEvening => _remindEvening;
  bool get remindMorning => _remindMorning;
  bool get loading => _loading;

  set hindi(bool v) {
    if (v == _hindi) return;
    _hindi = v;
    _prefs.setBool('hindi', v);
    notifyListeners();
    _reschedule();
  }

  set place(Place v) {
    _place = v;
    _prefs.setString('place', jsonEncode(v.toJson()));
    refresh();
  }

  void setFollow(String key, bool on) {
    on ? _follow.add(key) : _follow.remove(key);
    _prefs.setStringList('follow', _follow.toList());
    notifyListeners();
    _reschedule();
  }

  set eveningMinutes(int v) {
    _eveningMinutes = v;
    _prefs.setInt('eveningMinutes', v);
    notifyListeners();
    _reschedule();
  }

  set morningMinutes(int v) {
    _morningMinutes = v;
    _prefs.setInt('morningMinutes', v);
    notifyListeners();
    _reschedule();
  }

  set remindEvening(bool v) {
    _remindEvening = v;
    _prefs.setBool('remindEvening', v);
    notifyListeners();
    _reschedule();
  }

  set remindMorning(bool v) {
    _remindMorning = v;
    _prefs.setBool('remindMorning', v);
    notifyListeners();
    _reschedule();
  }

  /// English or Hindi text, depending on the setting.
  String t(String en, String hi) => _hindi ? hi : en;

  String bi(Bi b) => b.of(_hindi);

  // ---- observances --------------------------------------------------------

  /// Followed observances from today on.
  List<Observance> get upcoming {
    final today = _today();
    return [for (final o in visible) if (!o.date.isBefore(today)) o];
  }

  /// Followed observances for the two years.
  List<Observance> get visible => [for (final o in _all) if (_follow.contains(followKey(o))) o];

  List<Observance> get all => _all;

  /// Followed observances on a civil date.
  List<Observance> on(DateTime date) => [for (final o in visible) if (o.date == date) o];

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime.utc(n.year, n.month, n.day);
  }

  /// Computes the current and next year for the place (off the UI thread)
  /// and reschedules the reminders.
  Future<void> refresh() async {
    final gen = ++_generation;
    _loading = true;
    notifyListeners();
    final place = _place;
    final year = DateTime.now().year;
    final result = await Isolate.run(() => VratCalendar(place).build(DateTime.utc(year, 1, 1), DateTime.utc(year + 1, 12, 31)));
    if (gen != _generation) return; // a newer request replaced this one
    _all = result;
    _loading = false;
    notifyListeners();
    _reschedule();
  }

  /// Reminders and the home-screen widget both follow the same settings.
  Future<void> _reschedule() {
    widget.update(widgetPayload(items: upcoming, today: _today(), hindi: _hindi));
    return reminders.schedule(
      items: upcoming,
      place: _place,
      hindi: _hindi,
      eveningMinutes: _remindEvening ? _eveningMinutes : null,
      morningMinutes: _remindMorning ? _morningMinutes : null,
    );
  }
}

/// Makes the [AppModel] available below it and rebuilds dependents on change.
class AppScope extends InheritedNotifier<AppModel> {
  const AppScope({super.key, required AppModel model, required super.child}) : super(notifier: model);

  static AppModel of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
