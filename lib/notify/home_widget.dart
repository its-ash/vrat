import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/names.dart';
import '../vrat/catalog.dart';
import '../vrat/observance.dart';

/// How many days ahead the home-screen widget gets data for.
const widgetDays = 60;

/// The JSON the Android widget reads: `{"hindi":bool,"items":[{"d":"yyyy-mm-dd","n":name,"l":"Fri, 14 Nov"}]}`.
/// Only [items] on or after [today] and within [widgetDays] are kept, at most 12.
/// The widget works out "Today / Tomorrow / in N days" itself from `d`.
String widgetPayload({required List<Observance> items, required DateTime today, required bool hindi}) {
  final end = today.add(const Duration(days: widgetDays));
  final out = <Map<String, String>>[];
  for (final o in items) {
    if (o.date.isBefore(today) || o.date.isAfter(end)) continue;
    final d = o.date;
    final month = Names.monthNames[d.month - 1].of(hindi);
    out.add({
      'd': '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
      'n': nameOf(o).of(hindi),
      'l': '${Names.vaarShort[d.weekday]!.of(hindi)}, ${d.day} ${hindi ? month : month.substring(0, 3)}',
    });
    if (out.length == 12) break;
  }
  return jsonEncode({'hindi': hindi, 'items': out});
}

/// Hands the upcoming followed observances to the Android home-screen widget.
class HomeWidgetSync {
  const HomeWidgetSync();

  static const _channel = MethodChannel('com.itsash.vrat/widget');

  /// Stores [json] for the widget and asks it to redraw. Never throws.
  Future<void> update(String json) async {
    try {
      await _channel.invokeMethod<void>('update', json);
    } catch (e) {
      debugPrint('Home widget unavailable: $e');
    }
  }
}
