import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'terminal_comands.dart'; // Import the TerminalCommandsPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Learn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                const SizedBox(height: 32),
                // Learning topics as cards
                const Text(
                  'Explore Topics',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _TopicCard(
                      icon: Icons.history,
                      title: 'History of Linux',
                      onTap:
                          () =>
                              Navigator.of(context).pushNamed('/linux_history'),
                    ),
                    _TopicCard(
                      icon: Icons.computer,
                      title: 'Linux OS Basics',
                      onTap:
                          () =>
                              Navigator.of(context).pushNamed('/linux_basics'),
                    ),
                    _TopicCard(
                      icon: FontAwesomeIcons.terminal,
                      title: 'Terminal Commands',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const TerminalCommandsPage(),
                            ),
                          ),
                    ),
                    _TopicCard(
                      icon: Icons.info_outline,
                      title: 'Distributions & Ecosystem',
                      onTap:
                          () =>
                              Navigator.of(context).pushNamed('/linux_distros'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.linux),
                    label: const Text('Start Learning'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 32,
                      ),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/linux');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.linux),
            label: 'Linux',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.of(context).pushNamed('/linux');
          }
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _TopicCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: Colors.black87),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
