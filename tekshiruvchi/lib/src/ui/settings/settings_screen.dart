import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../notifications/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sozlamalar')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Kunlik eslatmalar'),
            value: notifications,
            onChanged: (val) async {
              setState(() => notifications = val);
              final svc = ref.read(notificationServiceProvider);
              if (val) {
                final ok = await svc.requestPermission();
                if (ok) {
                  await svc.scheduleDailyReminder();
                }
              } else {
                await svc.cancelDailyReminder();
              }
            },
          ),
        ],
      ),
    );
  }
}

