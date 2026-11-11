import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

import '../app/app_model.dart';
import '../data/names.dart';
import '../vrat/observance.dart';
import 'format.dart';
import 'upcoming_page.dart';

/// A month grid marking the days of followed observances, with the list of
/// the month below. Swipe sideways to change month.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final int _firstYear = DateTime.now().year;
  late final PageController _controller = PageController(initialPage: DateTime.now().month - 1);
  late int _page = DateTime.now().month - 1;

  static const _months = 24;

  void _go(int delta) => _controller.animateToPage(
        (_page + delta).clamp(0, _months - 1),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    final pad = UiContent.pagePadding(context);
    final year = _firstYear + _page ~/ 12, month = _page % 12 + 1;
    return Padding(
      padding: EdgeInsets.fromLTRB(pad, UiSpace.sm, pad, 0),
      child: Column(
        children: [
          Row(
            children: [
              UiIconButton(Icons.chevron_left_rounded, tooltip: m.t('Previous month', 'पिछला महीना'), onPressed: _page > 0 ? () => _go(-1) : null),
              Expanded(
                child: Text(m.monthYear(year, month), style: context.text.titleLarge, textAlign: TextAlign.center),
              ),
              UiIconButton(Icons.chevron_right_rounded, tooltip: m.t('Next month', 'अगला महीना'), onPressed: _page < _months - 1 ? () => _go(1) : null),
            ],
          ),
          const UiGap(UiSpace.sm),
          Row(
            children: [
              for (final w in const [7, 1, 2, 3, 4, 5, 6])
                Expanded(
                  child: Center(
                    child: Text(m.bi(Names.vaarShort[w]!), style: context.text.labelMedium?.copyWith(color: context.colors.textMuted)),
                  ),
                ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _months,
              onPageChanged: (p) => setState(() => _page = p),
              itemBuilder: (context, page) => _MonthPage(year: _firstYear + page ~/ 12, month: page % 12 + 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthPage extends StatelessWidget {
  const _MonthPage({required this.year, required this.month});

  final int year, month;

  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    final c = context.colors;
    final days = DateTime.utc(year, month + 1, 0).day;
    final lead = DateTime.utc(year, month, 1).weekday % 7;
    final byDay = <int, List<Observance>>{};
    for (final o in m.visible) {
      if (o.date.year == year && o.date.month == month) (byDay[o.date.day] ??= []).add(o);
    }
    final now = DateTime.now();
    final cells = <int?>[...List.filled(lead, null), for (var d = 1; d <= days; d++) d];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    final monthList = [for (final e in byDay.entries) ...e.value];
    return ListView(
      padding: const EdgeInsets.only(top: UiSpace.xs, bottom: UiSpace.xxl),
      children: [
        for (var r = 0; r < cells.length ~/ 7; r++)
          SizedBox(
            height: 52,
            child: Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: Builder(builder: (context) {
                      final d = cells[r * 7 + col];
                      if (d == null) return const SizedBox.shrink();
                      final list = byDay[d] ?? const <Observance>[];
                      final isToday = now.year == year && now.month == month && now.day == d;
                      return Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: InkWell(
                          borderRadius: UiRadius.all(UiRadius.sm),
                          onTap: list.isEmpty
                              ? null
                              : () => list.length == 1 ? openDetail(context, list.first) : _pick(context, m, list),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: isToday ? c.accentSoft : (list.isEmpty ? null : c.surfaceMuted),
                              borderRadius: UiRadius.all(UiRadius.sm),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('$d', style: context.text.titleSmall?.copyWith(color: isToday ? c.onAccentSoft : c.text)),
                                const UiGap(UiSpace.xxs),
                                if (list.isEmpty)
                                  const SizedBox(height: 6)
                                else
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (final o in list.take(3))
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: c.tone(kindStatus(o.kind)).color,
                                          ),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
              ],
            ),
          ),
        const UiGap(UiSpace.md),
        if (monthList.isEmpty)
          UiEmptyState(
            compact: true,
            title: m.t('Nothing this month', 'इस महीने कुछ नहीं'),
            icon: Icons.event_available_rounded,
          )
        else
          UiListGroup(
            header: m.t('This month', 'इस महीने'),
            children: [for (final o in monthList) ObservanceTile(o)],
          ),
      ],
    );
  }

  Future<void> _pick(BuildContext context, AppModel m, List<Observance> list) {
    return UiSheet.show<void>(
      context,
      title: m.longDate(list.first.date),
      child: Column(children: [for (final o in list) ObservanceTile(o, showDate: false)]),
    );
  }
}
