import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

import '../app/app_model.dart';
import '../data/names.dart';
import '../vrat/observance.dart';
import 'detail_screen.dart';
import 'format.dart';

/// Short names of the kinds, for pills.
const kindLabels = <ObsKind, Bi>{
  ObsKind.ekadashi: Bi('Ekadashi', 'एकादशी'),
  ObsKind.pradosh: Bi('Pradosh', 'प्रदोष'),
  ObsKind.purnima: Bi('Purnima', 'पूर्णिमा'),
  ObsKind.amavasya: Bi('Amavasya', 'अमावस्या'),
  ObsKind.sankashti: Bi('Sankashti', 'संकष्टी'),
  ObsKind.vinayaka: Bi('Vinayaka Chaturthi', 'विनायक चतुर्थी'),
  ObsKind.masikShivratri: Bi('Masik Shivratri', 'मासिक शिवरात्रि'),
  ObsKind.masikDurgashtami: Bi('Masik Durgashtami', 'मासिक दुर्गाष्टमी'),
  ObsKind.festival: Bi('Festival', 'पर्व'),
};

UiStatus kindStatus(ObsKind k) => switch (k) {
      ObsKind.festival => UiStatus.warning,
      ObsKind.ekadashi => UiStatus.success,
      ObsKind.pradosh || ObsKind.masikShivratri => UiStatus.info,
      ObsKind.purnima || ObsKind.amavasya => UiStatus.neutral,
      _ => UiStatus.accent,
    };

void openDetail(BuildContext context, Observance o) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DetailScreen(observance: o)));

/// One row of an observance list.
class ObservanceTile extends StatelessWidget {
  const ObservanceTile(this.o, {super.key, this.showDate = true});

  final Observance o;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    return UiListTile(
      m.name(o),
      subtitle: showDate ? '${m.longDate(o.date)} · ${m.inDays(o.date)}' : m.bi(kindLabels[o.kind]!),
      icon: o.kind == ObsKind.festival ? Icons.celebration_rounded : Icons.spa_rounded,
      iconStatus: kindStatus(o.kind),
      chevron: true,
      onTap: () => openDetail(context, o),
    );
  }
}

/// The next vrats and festivals, with a countdown to the first.
class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    final pad = UiContent.pagePadding(context);
    if (m.loading && m.all.isEmpty) {
      return const Padding(padding: EdgeInsets.all(UiSpace.lg), child: UiSkeletonList(count: 6));
    }
    final list = m.upcoming;
    if (list.isEmpty) {
      return UiEmptyState(
        title: m.t('Nothing to show', 'दिखाने के लिए कुछ नहीं'),
        message: m.t('Choose what to follow in Settings.', 'सेटिंग में चुनें कि क्या फ़ॉलो करना है।'),
        icon: Icons.event_busy_rounded,
      );
    }
    final next = list.first;
    final c = context.colors;
    final startsAt = m.place.startOfDay(next.date.year, next.date.month, next.date.day);
    final rest = list.skip(1).take(80).toList();
    return ListView(
      padding: EdgeInsets.fromLTRB(pad, UiSpace.sm, pad, UiSpace.xxl),
      children: [
        UiCard(
          variant: UiCardVariant.filled,
          onTap: () => openDetail(context, next),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.t('Next', 'अगला'), style: context.text.labelMedium?.copyWith(color: c.textMuted)),
                    const UiGap(UiSpace.xs),
                    Text(m.name(next), style: context.text.headlineSmall),
                    const UiGap(UiSpace.xs),
                    Text(m.longDate(next.date), style: context.text.bodyMedium?.copyWith(color: c.textMuted)),
                    const UiGap(UiSpace.sm),
                    UiStatusPill(m.inDays(next.date), status: kindStatus(next.kind)),
                  ],
                ),
              ),
              const UiGap(UiSpace.md),
              UiCountdown(
                period: const Duration(days: 30),
                endsAt: startsAt,
                diameter: 72,
                showText: false,
              ),
            ],
          ),
        ),
        const UiGap(UiSpace.lg),
        UiListGroup(
          header: m.t('Coming up', 'आगामी'),
          footer: m.t('For ${m.place.name}. Dates are worked out on your phone.', '${m.place.name} के लिए। तिथियाँ आपके फ़ोन पर ही निकाली जाती हैं।'),
          children: [for (final o in rest) ObservanceTile(o)],
        ),
      ],
    );
  }
}
