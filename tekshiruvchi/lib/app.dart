import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'src/ui/home/home_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  ThemeData _lightTheme() {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF2367EC));
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  ThemeData _darkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2367EC),
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'TEKSHIRUVCHI',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

