import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers.dart';
import '../tips/tips_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Duration _screenTime = Duration.zero;
  double _meters = 0;
  Duration _sleep = Duration.zero;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() => _loading = true);
    final perms = ref.read(permissionsProvider);
    await perms.ensureLocationPermissions();
    await perms.ensureActivityRecognition();
    await perms.ensureUsageAccess();

    // Start distance tracking
    await ref.read(distanceServiceProvider).start();

    await _refresh();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _refresh() async {
    final screenSummary = await ref.read(screenTimeServiceProvider).queryToday();
    final sleepSummary = await ref.read(sleepServiceProvider).estimateLastNight();
    setState(() {
      _screenTime = screenSummary.totalForeground;
      _sleep = sleepSummary.estimatedSleep;
      _meters = ref.read(distanceServiceProvider).metersWalked;
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final mins = d.inMinutes.remainder(60);
    if (hours == 0) return '${mins}m';
    return '${hours}h ${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEKSHIRUVCHI'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Yangilash',
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MetricCard(
            title: 'Ekran vaqti',
            value: _formatDuration(_screenTime),
            subtitle: 'Bugun qancha vaqt telefonda',
            icon: Icons.phone_android,
          ),
          _MetricCard(
            title: 'Bosilgan masofa',
            value: '${NumberFormat.compact().format(_meters)} m',
            subtitle: 'Bugun yurgan masofa',
            icon: Icons.directions_walk,
          ),
          _MetricCard(
            title: 'Uyqu vaqti',
            value: _formatDuration(_sleep),
            subtitle: 'Kecha taxminiy uyqu',
            icon: Icons.nightlight_round,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TipsScreen()),
              );
            },
            icon: const Icon(Icons.tips_and_updates_outlined),
            label: const Text('Tavsiyalar'),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

