import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

import '../app/app_model.dart';
import 'calendar_page.dart';
import 'settings_screen.dart';
import 'upcoming_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    return UiShell(
      appBar: UiAppBar(
        title: m.t('Vrat', 'व्रत'),
        subtitle: m.place.name,
        actions: [
          UiIconButton(
            Icons.settings_rounded,
            tooltip: m.t('Settings', 'सेटिंग'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      items: [
        UiNavItem(Icons.event_outlined, m.t('Upcoming', 'आगामी'), selectedIcon: Icons.event_rounded),
        UiNavItem(Icons.calendar_month_outlined, m.t('Calendar', 'कैलेंडर'), selectedIcon: Icons.calendar_month_rounded),
      ],
      index: _tab,
      onChanged: (i) => setState(() => _tab = i),
      pages: const [UpcomingPage(), CalendarPage()],
    );
  }
}
