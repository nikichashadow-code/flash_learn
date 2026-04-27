import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'terminal_comands.dart'; // Import the TerminalCommandsPage
import '../l10n/l10n.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: context.l10n.settingsTitle,
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: context.l10n.signOut,
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
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
                Text(
                  context.l10n.exploreTopics,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _TopicCard(
                      index: 0,
                      icon: Icons.history,
                      title: context.l10n.topicHistoryOfLinux,
                      onTap:
                          () =>
                              Navigator.of(context).pushNamed('/linux_history'),
                    ),
                    _TopicCard(
                      index: 1,
                      icon: Icons.computer,
                      title: context.l10n.topicLinuxOsBasics,
                      onTap:
                          () =>
                              Navigator.of(context).pushNamed('/linux_basics'),
                    ),
                    _TopicCard(
                      index: 2,
                      icon: FontAwesomeIcons.terminal,
                      title: context.l10n.topicTerminalCommands,
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
                      index: 3,
                      icon: Icons.info_outline,
                      title: context.l10n.topicDistrosEcosystem,
                      onTap:
                          () =>
                              Navigator.of(context).pushNamed('/linux_distros'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: context.l10n.navHome),
          BottomNavigationBarItem(icon: const Icon(Icons.storage), label: context.l10n.navSsh),
          BottomNavigationBarItem(icon: const Icon(Icons.code), label: context.l10n.navTerminal),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushNamed('/ssh_client');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/terminal_emulator');
          }
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _TopicCard({
    required this.index,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: _InteractiveTopicCard(icon: icon, title: title, onTap: onTap),
      onEnd: () {},
    );
  }
}

class _InteractiveTopicCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _InteractiveTopicCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<_InteractiveTopicCard> createState() => _InteractiveTopicCardState();
}

class _InteractiveTopicCardState extends State<_InteractiveTopicCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _pressed ? scheme.primaryContainer : scheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withAlpha((0.14 * 255).round()),
              blurRadius: _pressed ? 3 : 9,
              offset: Offset(0, _pressed ? 1 : 4),
            ),
          ],
        ),
        transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 160),
              scale: _pressed ? 0.92 : 1,
              child: Icon(widget.icon, size: 36, color: scheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _pressed ? scheme.onPrimaryContainer : scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
