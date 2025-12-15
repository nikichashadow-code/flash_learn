import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth/auth_page.dart';
import 'pages/home.dart';
import 'pages/welcome_page.dart';
import 'pages/terminal_comands.dart';
import 'pages/linux_history_page.dart';
import 'pages/Linux_Basics.dart';
import 'pages/distributions_and_ecosystem.dart';
import 'terminal_simulator/terminal_emulator_page.dart' as terminal_simulator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loading = true;
  bool _onboardingDone = false;
  User? _user;

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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    if (!_onboardingDone) {
      return MaterialApp(
        title: 'FlashLearn',
        home: WelcomePage(
          onFinished: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('onboarding_done', true);
            setState(() {
              _onboardingDone = true;
            });
          },
        ),
        routes: {
          '/login': (context) => const AuthPage(),
          '/home': (context) => const HomePage(),
        },
      );
    }
    return MaterialApp(
      title: 'FlashLearn',
      home: _user != null ? const HomePage() : const AuthPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const AuthPage(),
        '/terminal': (context) => const TerminalCommandsPage(),
        '/linux_history': (context) => const LinuxHistoryPage(),
        '/linux_basics': (context) => const LinuxBasicsPage(),
        '/linux_distros': (context) => const DistributionsAndEcosystemPage(),
        '/terminal_emulator':
            (context) => const terminal_simulator.TerminalEmulatorPage(),
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Page')),
    );
  }
}
