import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

import '../app/app_model.dart';
import '../vrat/catalog.dart';
import '../vrat/observance.dart';
import 'upcoming_page.dart';

/// Choose which vrats and festivals to follow: they appear in the lists and
/// calendar and get reminders.
class FollowScreen extends StatelessWidget {
  const FollowScreen({super.key});

  static const _kinds = [
    ObsKind.ekadashi,
    ObsKind.pradosh,
    ObsKind.purnima,
    ObsKind.amavasya,
    ObsKind.sankashti,
    ObsKind.vinayaka,
    ObsKind.masikShivratri,
    ObsKind.masikDurgashtami,
  ];

  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    return UiScaffold(
      appBar: UiAppBar(title: m.t('What to follow', 'क्या फ़ॉलो करें')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UiListGroup(
            header: m.t('Monthly vrats', 'मासिक व्रत'),
            children: [
              for (final k in _kinds)
                UiSwitchTile(
                  m.bi(kindLabels[k]!),
                  value: m.follow.contains(k.name),
                  icon: Icons.spa_rounded,
                  onChanged: (v) => m.setFollow(k.name, v),
                ),
            ],
          ),
          const UiGap(UiSpace.lg),
          UiListGroup(
            header: m.t('Festivals', 'पर्व'),
            children: [
              for (final id in AppModel.allFestivalIds)
                UiSwitchTile(
                  m.bi(catalog[id]!.name),
                  value: m.follow.contains(id),
                  icon: Icons.celebration_rounded,
                  status: UiStatus.warning,
                  onChanged: (v) => m.setFollow(id, v),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
