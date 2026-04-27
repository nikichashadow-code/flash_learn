import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'l10n/app_localizations.dart';

import 'l10n/l10n.dart';
import 'auth/auth_page.dart';
import 'pages/home.dart';
import 'pages/welcome_page.dart';
import 'pages/terminal_comands.dart';
import 'pages/terminal_quiz_page.dart';
import 'pages/linux_history_page.dart';
import 'pages/Linux_Basics.dart';
import 'pages/distributions_and_ecosystem.dart';
import 'pages/ssh_client_page.dart';
import 'pages/settings_page.dart';
import 'terminal_simulator/terminal_emulator_page.dart' as terminal_simulator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: 'assets/.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppController? maybeControllerOf(BuildContext context) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    return state == null ? null : MyAppController._(state);
  }

  static MyAppController controllerOf(BuildContext context) {
    final controller = maybeControllerOf(context);
    assert(controller != null, 'MyAppState not found in context');
    return controller!;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loading = true;
  bool _onboardingDone = false;
  User? _user;
  static const _fallbackSeedColor = Color(0xFF6750A4);
  Locale? _locale;

  void setLocale(Locale? locale) {
    setState(() => _locale = locale);
  }

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
    // Listen for auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _user = Supabase.instance.client.auth.currentUser;
      });
    });
    // Wait for Supabase to restore session
    Future.microtask(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _user = Supabase.instance.client.auth.currentUser;
        _loading = false;
      });
    });
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingDone = prefs.getBool('onboarding_done') ?? false;
    });
  }

  ThemeData _themeFrom(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surfaceTint,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        shadowColor: scheme.shadow.withAlpha(36),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final lightScheme =
            lightDynamic ?? ColorScheme.fromSeed(seedColor: _fallbackSeedColor);
        final darkScheme = darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: _fallbackSeedColor,
              brightness: Brightness.dark,
            );

        Widget home;
        final homeStateKey = _loading
            ? const ValueKey('loading')
            : (!_onboardingDone
                  ? const ValueKey('welcome')
                  : (_user != null
                        ? const ValueKey('home')
                        : const ValueKey('auth')));
        if (_loading) {
          home = const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (!_onboardingDone) {
          home = WelcomePage(
            onFinished: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('onboarding_done', true);
              setState(() {
                _onboardingDone = true;
              });
            },
          );
        } else {
          home = _user != null ? const HomePage() : const AuthPage();
        }

        return MaterialApp(
          title: 'FlashLearn',
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: _themeFrom(lightScheme),
          darkTheme: _themeFrom(darkScheme),
          themeMode: ThemeMode.system,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _locale,
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: KeyedSubtree(key: homeStateKey, child: home),
          ),
          routes: {
            '/home': (context) => const HomePage(),
            '/login': (context) => const AuthPage(),
            '/terminal': (context) => const TerminalCommandsPage(),
            '/terminal_quiz': (context) => const TerminalQuizPage(),
            '/linux_history': (context) => const LinuxHistoryPage(),
            '/linux_basics': (context) => const LinuxBasicsPage(),
            '/linux_distros': (context) => const DistributionsAndEcosystemPage(),
            '/ssh_client': (context) => const SSHClientPage(),
            '/settings': (context) => const SettingsPage(),
            '/terminal_emulator':
                (context) => const terminal_simulator.TerminalEmulatorPage(),
          },
        );
      },
    );
  }
}

class MyAppController {
  MyAppController._(this._state);
  final _MyAppState _state;

  void setLocale(Locale? locale) => _state.setLocale(locale);
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.login)),
      body: Center(child: Text(context.l10n.login)),
    );
  }
}
