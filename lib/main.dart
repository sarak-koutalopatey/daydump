import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/notification_service.dart';
import 'state/app_state.dart';
import 'screens/main_scaffold.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const DayDumpApp(),
    ),
  );
}

class DayDumpApp extends StatelessWidget {
  const DayDumpApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return MaterialApp(
      title: 'DayDump',
      debugShowCheckedModeBanner: false,
      locale: state.languageCode != null ? Locale(state.languageCode!) : null,
      supportedLocales: const [Locale('en'), Locale('fr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: state.themeMode,
      home: !state.loaded
          ? const Scaffold()
          : !state.onboardingCompleted
              ? const OnboardingScreen()
              : const MainScaffold(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    const amber = Color(0xFFF59E0B);
    const amberInk = Color(0xFF1A1206);
    final bg = isLight ? const Color(0xFFFFFFFF) : const Color(0xFF111111);
    final onBg = isLight ? const Color(0xFF111111) : const Color(0xFFF5F5F5);

    final baseText = GoogleFonts.figtreeTextTheme().apply(
      bodyColor: onBg,
      displayColor: onBg,
    );

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: amber,
        onPrimary: amberInk,
        secondary: amber,
        onSecondary: amberInk,
        error: const Color(0xFFE53E3E),
        onError: Colors.white,
        surface: bg,
        onSurface: onBg,
      ),
      scaffoldBackgroundColor: bg,
      textTheme: baseText,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: onBg,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
