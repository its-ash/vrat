import '../engine/engine.dart';

/// What sort of observance it is. Used for the "which ones to follow" filter.
enum ObsKind {
  ekadashi,
  pradosh,
  purnima,
  amavasya,
  sankashti,
  vinayaka,
  masikShivratri,
  masikDurgashtami,
  festival,
}

/// One vrat or festival on a civil date at a place.
class Observance {
  const Observance({
    required this.id,
    required this.kind,
    required this.date,
    required this.tithi,
    required this.amantaMonth,
    required this.adhika,
    this.moonrise,
    this.parana,
    this.hariVasaraEnd,
    this.variant,
    this.note,
  });

  /// Catalog id, e.g. `ekadashi`, `diwali`, `masik_shivratri`.
  final String id;
  final ObsKind kind;

  /// Civil date (a UTC midnight [DateTime], fields are the local date).
  final DateTime date;

  /// The tithi that decides the day, with its exact start and end (UTC).
  final Segment tithi;

  /// Amanta month 0 (Chaitra) .. 11 (Phalguna) of the tithi, and whether it
  /// is an adhika month.
  final int amantaMonth;
  final bool adhika;

  /// Moonrise on the day (Sankashti, Karwa Chauth, Purnima).
  final DateTime? moonrise;

  /// Parana window on the following morning (Ekadashi only).
  final TimeWindow? parana;

  /// End of Hari Vasara, the first quarter of Dwadashi (Ekadashi only).
  final DateTime? hariVasaraEnd;

  /// Name variant: the index into the Ekadashi names, or null.
  final String? variant;

  /// Extra remark key shown in the detail, e.g. `smarta`.
  final String? note;

  /// Unique, stable key: `<id>[.<variant>]@yyyy-mm-dd`.
  String get key {
    final d = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '$id${variant == null ? '' : '.$variant'}@$d';
  }

  /// Catalog key: the id plus the variant (so each Ekadashi has its own text).
  String get catalogId => variant == null ? id : '$id.$variant';
}
