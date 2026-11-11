import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

import 'app/app_model.dart';
import 'ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = await AppModel.load();
  runApp(VratApp(model: model));
  // Compute the dates after the first frame; this also schedules reminders.
  model.refresh();
}

class VratApp extends StatelessWidget {
  const VratApp({super.key, required this.model});

  final AppModel model;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      model: model,
      child: UiApp(
        title: 'Vrat',
        themeMode: ThemeMode.system,
        accent: const Color(0xFF9B1C31), // maroon
        home: const HomeScreen(),
      ),
    );
  }
}
