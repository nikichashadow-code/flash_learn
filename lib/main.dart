import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_page.dart';
import 'home.dart';
import 'linux_page.dart';
import 'welcome_page.dart';
import 'terminal_comands.dart';
import 'linux_history_page.dart';
import 'Linux_Basics.dart'; // Make sure this import is present
import 'distributions_and_ecosystem.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lqqgaroqmukiszvotkor.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxxcWdhcm9xbXVraXN6dm90a29yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0NzU4MzUsImV4cCI6MjA2MzA1MTgzNX0.CongxH1A09T1w5Mgp86pXjr74Ub4J_EMGPrUlMEKf0k',
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
          '/linux': (context) => const LinuxPage(),
        },
      );
    }
    return MaterialApp(
      title: 'FlashLearn',
      home: _user != null ? const HomePage() : const AuthPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const AuthPage(),
        '/linux': (context) => const LinuxPage(),
        '/terminal': (context) => const TerminalCommandsPage(),
        '/linux_history': (context) => const LinuxHistoryPage(),
        '/linux_basics': (context) => const LinuxBasicsPage(),
        '/linux_distros':
            (context) =>
                const DistributionsAndEcosystemPage(), // <-- Add this line
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
