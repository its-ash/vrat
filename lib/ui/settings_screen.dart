import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

import '../app/app_model.dart';
import 'follow_screen.dart';
import 'format.dart';
import 'location_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? _allowed;

  @override
  void initState() {
    super.initState();
    AppScope.of(context).reminders.enabled.then((v) {
      if (mounted) setState(() => _allowed = v);
    });
  }

  Future<void> _pickTime(AppModel m, bool evening) async {
    final current = evening ? m.eveningMinutes : m.morningMinutes;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60));
    if (t == null) return;
    final minutes = t.hour * 60 + t.minute;
    evening ? m.eveningMinutes = minutes : m.morningMinutes = minutes;
  }

  Future<void> _allow(AppModel m) async {
    final ok = await m.reminders.requestPermission();
    await m.reminders.requestExactAlarms();
    if (!mounted) return;
    setState(() => _allowed = ok);
    if (ok) await m.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final m = AppScope.of(context);
    return UiScaffold(
      appBar: UiAppBar(title: m.t('Settings', 'सेटिंग')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UiSection(
            title: m.t('Language', 'भाषा'),
            child: UiSegmentedControl<bool>(
              const [UiSegment(false, label: 'English'), UiSegment(true, label: 'हिन्दी')],
              value: m.hindi,
              expand: true,
              onChanged: (v) => m.hindi = v,
            ),
          ),
          const UiGap(UiSpace.lg),
          UiListGroup(
            header: m.t('Location', 'स्थान'),
            footer: m.t('Dates, moonrise and parana times are worked out for this city.',
                'तिथियाँ, चंद्रोदय और पारण का समय इसी शहर के लिए निकाले जाते हैं।'),
            children: [
              UiListTile(
                m.place.name,
                subtitle: m.place.region,
                icon: Icons.place_rounded,
                chevron: true,
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const LocationScreen())),
              ),
              UiListTile(
                m.t('What to follow', 'क्या फ़ॉलो करें'),
                subtitle: m.t('${m.follow.length} selected', '${m.follow.length} चुने गए'),
                icon: Icons.checklist_rounded,
                chevron: true,
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const FollowScreen())),
              ),
            ],
          ),
          const UiGap(UiSpace.lg),
          UiListGroup(
            header: m.t('Reminders', 'अनुस्मारक'),
            footer: m.t('Reminders are for the observances you follow, at your city\'s local time.',
                'अनुस्मारक आपके चुने हुए व्रत-पर्वों के लिए, आपके शहर के स्थानीय समय पर आते हैं।'),
            children: [
              if (_allowed == false)
                UiListTile(
                  m.t('Allow notifications', 'सूचनाओं की अनुमति दें'),
                  subtitle: m.t('Needed to show reminders.', 'अनुस्मारक दिखाने के लिए आवश्यक।'),
                  icon: Icons.notifications_off_rounded,
                  iconStatus: UiStatus.warning,
                  chevron: true,
                  onTap: () => _allow(m),
                ),
              UiSwitchTile(
                m.t('Evening before', 'पिछली शाम'),
                subtitle: m.clockOfMinutes(m.eveningMinutes),
                value: m.remindEvening,
                icon: Icons.nights_stay_rounded,
                onChanged: (v) => m.remindEvening = v,
              ),
              UiListTile(
                m.t('Evening time', 'शाम का समय'),
                icon: Icons.schedule_rounded,
                value: m.clockOfMinutes(m.eveningMinutes),
                enabled: m.remindEvening,
                onTap: () => _pickTime(m, true),
              ),
              UiSwitchTile(
                m.t('Morning of the day', 'उसी दिन सुबह'),
                subtitle: m.clockOfMinutes(m.morningMinutes),
                value: m.remindMorning,
                icon: Icons.wb_sunny_rounded,
                onChanged: (v) => m.remindMorning = v,
              ),
              UiListTile(
                m.t('Morning time', 'सुबह का समय'),
                icon: Icons.schedule_rounded,
                value: m.clockOfMinutes(m.morningMinutes),
                enabled: m.remindMorning,
                onTap: () => _pickTime(m, false),
              ),
            ],
          ),
          const UiGap(UiSpace.lg),
          const UiAppearanceSection(),
          const UiGap(UiSpace.lg),
          UiUpdateSection(storeId: 'vrat', header: m.t('Updates', 'अपडेट')),
          const UiGap(UiSpace.lg),
          UiDeveloperSection(header: m.t('Developer', 'डेवलपर')),
        ],
      ),
    );
  }
}
