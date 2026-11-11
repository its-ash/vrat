import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

import '../app/app_model.dart';
import '../vrat/catalog.dart';
import '../vrat/observance.dart';
import 'format.dart';
import 'upcoming_page.dart';

/// Date, tithi timing, parana, moonrise, significance and how it is observed.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.observance});

  final Observance observance;

  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    final o = observance;
    final info = infoOf(o);
    final day = o.date;
    final c = context.colors;
    final isEkadashi = o.parana != null;
    return UiScaffold(
      appBar: UiAppBar(title: m.t('Details', 'विवरण')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UiCard(
            variant: UiCardVariant.filled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.bi(kindLabels[o.kind]!), style: context.text.labelMedium?.copyWith(color: c.textMuted)),
                const UiGap(UiSpace.xs),
                Text(m.bi(info.name), style: context.text.headlineMedium),
                const UiGap(UiSpace.sm),
                Text(m.longDate(o.date), style: context.text.titleMedium),
                const UiGap(UiSpace.sm),
                UiStatusPill(m.inDays(o.date), status: kindStatus(o.kind)),
              ],
            ),
          ),
          const UiGap(UiSpace.lg),
          UiListGroup(
            header: m.t('Timings', 'समय'),
            footer: m.t('For ${m.place.name}.', '${m.place.name} के लिए।'),
            children: [
              UiListTile(
                m.t('Tithi', 'तिथि'),
                icon: Icons.brightness_2_rounded,
                subtitle: m.tithiWithPaksha(o.tithi.index),
              ),
              UiListTile(m.t('Begins', 'आरंभ'), icon: Icons.play_arrow_rounded, value: m.clock(o.tithi.start, day: day)),
              UiListTile(m.t('Ends', 'समाप्त'), icon: Icons.stop_rounded, value: m.clock(o.tithi.end, day: day)),
              UiListTile(
                m.t('Hindu month', 'हिंदू मास'),
                icon: Icons.calendar_month_rounded,
                subtitle: '${m.monthLabel(o)} (${m.t('Amanta', 'अमांत')})',
              ),
              if (o.moonrise != null)
                UiListTile(
                  m.t('Moonrise', 'चंद्रोदय'),
                  icon: Icons.nightlight_round,
                  iconStatus: UiStatus.info,
                  value: m.clock(o.moonrise!, day: day),
                ),
              if (isEkadashi) ...[
                UiListTile(
                  m.t('Hari Vasara ends', 'हरि वासर समाप्त'),
                  icon: Icons.hourglass_bottom_rounded,
                  value: m.clock(o.hariVasaraEnd!, day: DateTime.utc(day.year, day.month, day.day + 1)),
                ),
                UiListTile(
                  m.t('Parana (break the fast)', 'पारण (व्रत खोलने का समय)'),
                  icon: Icons.restaurant_rounded,
                  iconStatus: UiStatus.success,
                  subtitle: '${m.t('Next day', 'अगले दिन')}, ${m.range(o.parana!, day: DateTime.utc(day.year, day.month, day.day + 1))}',
                ),
              ],
            ],
          ),
          const UiGap(UiSpace.lg),
          _Section(title: m.t('Significance', 'महत्व'), text: m.bi(info.about)),
          const UiGap(UiSpace.lg),
          _Section(title: m.t('How it is observed', 'कैसे मनाएँ'), text: m.bi(info.observe)),
          if (info.rule != null) ...[
            const UiGap(UiSpace.lg),
            _Section(title: m.t('How this date is decided', 'यह तिथि कैसे तय होती है'), text: m.bi(info.rule!)),
          ],
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.text});

  final String title, text;

  @override
  Widget build(BuildContext context) {
    return UiSection(
      title: title,
      child: Text(text, style: context.text.bodyMedium?.copyWith(color: context.colors.textMuted, height: 1.5)),
    );
  }
}
