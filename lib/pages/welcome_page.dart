import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../l10n/l10n.dart';

class WelcomePage extends StatelessWidget {
  final Future<void> Function()? onFinished;
  const WelcomePage({super.key, this.onFinished});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              // Linux icon
              FaIcon(
                FontAwesomeIcons.linux,
                color: scheme.primary,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.welcomeTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.welcomeSubtitle,
                style: TextStyle(fontSize: 18, color: scheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withAlpha((0.14 * 255).round()),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.welcomeWhatYouWillLearn,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _TopicIcon(icon: Icons.history, label: context.l10n.welcomeTopicHistory),
                        _TopicIcon(icon: Icons.computer, label: context.l10n.welcomeTopicBasics),
                        _TopicIcon(icon: FontAwesomeIcons.terminal, label: context.l10n.welcomeTopicTerminal),
                        _TopicIcon(icon: Icons.info_outline, label: context.l10n.welcomeTopicDistros),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.arrowRight),
                  label: Text(context.l10n.getStarted),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  onPressed: () async {
                    if (onFinished != null) await onFinished!();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TopicIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, color: scheme.primary, size: 36),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: scheme.onSurface, fontSize: 14)),
      ],
    );
  }
}
