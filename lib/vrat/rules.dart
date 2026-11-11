import 'observance.dart';

/// The part of the civil day (or night) in which a tithi must be present for
/// that day to be the observance day.
///
/// Day = sunrise to sunset, split into five equal parts (pratah, sangava,
/// madhyahna, aparahna, sayahna); night = sunset to the next sunrise.
enum Anchor {
  /// The moment of sunrise (udaya tithi).
  sunrise,

  /// Sunrise to sunset.
  daytime,

  /// First fifth of the day (purvahna).
  purvahna,

  /// First half of the day, sunrise to midday (Drik's purvahna for Akshaya
  /// Tritiya).
  forenoon,

  /// Third fifth of the day (madhyahna), about 10:50 to 13:15.
  madhyahna,

  /// Fourth fifth of the day (aparahna), the shraddha period.
  aparahna,

  /// Sunset to 2 h 24 min later (three muhurtas).
  pradosh,

  /// The eighth of the fifteen muhurtas of the night (midnight).
  nishita,

  /// The moment of moonrise.
  moonrise,
}

/// A rule for one vrat or festival: "the day on which [tithis] is present
/// during [anchor]". When the tithi covers the anchor on two days, the day
/// with the longer overlap wins (the first on a tie). When it covers the
/// anchor on no day, the day with the longest overlap with daytime is used.
///
/// Months are amanta (new moon to new moon), 0 = Chaitra ... 11 = Phalguna.
/// A festival that printed almanacs date in the purnimanta month is
/// converted: for example Maha Shivratri, "Phalguna Krishna Chaturdashi" in
/// the north, is Magha Krishna Chaturdashi (month 10) here.
class Rule {
  const Rule(
    this.id,
    this.kind,
    this.tithis,
    this.anchor, {
    this.month,
    this.exceptMonths = const [],
    this.adhika = false,
    this.bhadraFree = false,
    this.firstDayAtLeast,
  });

  /// When set, the first day on which the tithi covers the anchor for at
  /// least this long wins (instead of the day with the longest overlap).
  final Duration? firstDayAtLeast;

  final String id;
  final ObsKind kind;

  /// Tithi indices 0..29 (Shukla Pratipada = 0, Purnima = 14, Krishna
  /// Pratipada = 15, Amavasya = 29).
  final List<int> tithis;
  final Anchor anchor;

  /// Amanta month, or null for every month.
  final int? month;
  final List<int> exceptMonths;

  /// Also observed in an adhika (extra) month. True for the monthly vrats
  /// (Ekadashi, Pradosh, ...), false for festivals, which are kept in the
  /// nija month.
  final bool adhika;

  /// Skip time under Bhadra (Vishti karana): Raksha Bandhan and Holika Dahan.
  final bool bhadraFree;
}

/// Tithi numbers used below.
const _shuklaEkadashi = 10, _krishnaEkadashi = 25, _purnima = 14, _amavasya = 29;

/// The rule table. Every rule is applied to every tithi of the period.
///
/// Where traditions differ the choice made here is noted. Summary:
/// - Ekadashi: the Smarta day as Drik lists it, see `_pickEkadashi` in
///   `calendar.dart` (udaya tithi, with the two-sunrise and short-sunrise
///   adjustments). Vaishnavas (and ISKCON) often fast a day later; the detail
///   page shows when Ekadashi ends so that you can follow your own sampradaya.
/// - Purnima and Amavasya: the day on which the tithi covers aparahna, as
///   printed almanacs give for the vrat and for shraddha.
/// - Dates are for the chosen city. A festival can fall on different days in
///   different cities when a tithi starts or ends near the anchor time.
const rules = <Rule>[
  // ---- monthly vrats ----------------------------------------------------
  Rule('ekadashi', ObsKind.ekadashi, [_shuklaEkadashi, _krishnaEkadashi], Anchor.sunrise, adhika: true),
  Rule('pradosh', ObsKind.pradosh, [12, 27], Anchor.pradosh, adhika: true),
  Rule('purnima', ObsKind.purnima, [_purnima], Anchor.aparahna, adhika: true),
  Rule('amavasya', ObsKind.amavasya, [_amavasya], Anchor.aparahna, adhika: true),
  // Krishna Chaturthi when the Moon rises in it. In Ashwin it is Karwa Chauth.
  Rule('sankashti', ObsKind.sankashti, [18], Anchor.moonrise, exceptMonths: [6], adhika: true),
  // Shukla Chaturthi at midday (Ganesh puja time).
  Rule('vinayaka', ObsKind.vinayaka, [3], Anchor.madhyahna, exceptMonths: [5], adhika: true),
  // Krishna Chaturdashi at midnight. In Magha it is Maha Shivratri.
  Rule('masik_shivratri', ObsKind.masikShivratri, [28], Anchor.nishita, exceptMonths: [10], adhika: true),
  // Shukla Ashtami. In Ashwin it is Durga Ashtami.
  Rule('masik_durgashtami', ObsKind.masikDurgashtami, [7], Anchor.sunrise, exceptMonths: [6], adhika: true),

  // ---- festivals (nija months only) -------------------------------------
  Rule('vasant_panchami', ObsKind.festival, [4], Anchor.purvahna, month: 10),
  Rule('maha_shivratri', ObsKind.festival, [28], Anchor.nishita, month: 10),
  // Holi is the day after Holika Dahan, added in the calendar code.
  Rule('holika_dahan', ObsKind.festival, [_purnima], Anchor.pradosh, month: 11, bhadraFree: true),
  Rule('chaitra_navratri', ObsKind.festival, [0], Anchor.sunrise, month: 0),
  Rule('ram_navami', ObsKind.festival, [8], Anchor.madhyahna, month: 0),
  Rule('hanuman_jayanti', ObsKind.festival, [_purnima], Anchor.sunrise, month: 0),
  // Tritiya in the forenoon; the first day with at least one muhurta (48 min)
  // of it. Fits Drik: 2026-04-19 (Tritiya from 10:50, 80 min of forenoon) and
  // 2027-05-09 (day before has only 34 min).
  Rule('akshaya_tritiya', ObsKind.festival, [2], Anchor.forenoon, month: 1, firstDayAtLeast: Duration(minutes: 48)),
  Rule('guru_purnima', ObsKind.festival, [_purnima], Anchor.sunrise, month: 3),
  Rule('raksha_bandhan', ObsKind.festival, [_purnima], Anchor.daytime, month: 4, bhadraFree: true),
  Rule('janmashtami', ObsKind.festival, [22], Anchor.daytime, month: 4),
  Rule('ganesh_chaturthi', ObsKind.festival, [3], Anchor.madhyahna, month: 5),
  Rule('sharad_navratri', ObsKind.festival, [0], Anchor.sunrise, month: 6),
  Rule('durga_ashtami', ObsKind.festival, [7], Anchor.sunrise, month: 6),
  Rule('dussehra', ObsKind.festival, [9], Anchor.aparahna, month: 6),
  Rule('karwa_chauth', ObsKind.festival, [18], Anchor.moonrise, month: 6),
  Rule('dhanteras', ObsKind.festival, [27], Anchor.pradosh, month: 6),
  Rule('diwali', ObsKind.festival, [_amavasya], Anchor.pradosh, month: 6),
  Rule('govardhan_puja', ObsKind.festival, [0], Anchor.sunrise, month: 7),
  Rule('bhai_dooj', ObsKind.festival, [1], Anchor.aparahna, month: 7),
  Rule('chhath', ObsKind.festival, [5], Anchor.daytime, month: 7),
];
