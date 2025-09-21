import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/ui/root_shell.dart';
import 'src/notifications/notification_service.dart';
import 'src/services/auto_persist.dart';
import 'package:dynamic_color/dynamic_color.dart';

class App extends ConsumerWidget {
  const App({super.key});

  ThemeData _lightTheme(ColorScheme? dynamicScheme) {
    final scheme = dynamicScheme ?? ColorScheme.fromSeed(seedColor: const Color(0xFF2367EC));
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  ThemeData _darkTheme(ColorScheme? dynamicDarkScheme) {
    final scheme = dynamicDarkScheme ?? ColorScheme.fromSeed(
      seedColor: const Color(0xFF2367EC),
      brightness: Brightness.dark,
    );
    // AMOLED-friendly background
    final amoled = scheme.copyWith(background: Colors.black, surface: const Color(0xFF0A0A0A));
    return ThemeData(
      useMaterial3: true,
      colorScheme: amoled,
      scaffoldBackgroundColor: Colors.black,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // kick off background helpers lazily when app starts
    ref.read(notificationServiceProvider).initialize();
    ref.read(autoPersistProvider).start();
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'TEKSHIRUVCHI',
          debugShowCheckedModeBanner: false,
          theme: _lightTheme(lightDynamic),
          darkTheme: _darkTheme(darkDynamic),
          themeMode: ThemeMode.system,
          home: const RootShell(),
        );
      },
    );
  }
}

