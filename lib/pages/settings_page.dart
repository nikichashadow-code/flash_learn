import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static final Uri _githubUrl = Uri.parse('https://github.com/nikichashadow-code');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = Supabase.instance.client.auth.currentUser;
    final currentLocale =
        Localizations.maybeLocaleOf(context) ?? const Locale('en');

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsHero(userEmail: user?.email),
          const SizedBox(height: 12),
          _SettingsSectionCard(
            title: context.l10n.settingsAppearance,
            icon: Icons.palette_outlined,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  context.l10n.settingsLanguage,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              RadioListTile<String>(
                title: Text(context.l10n.english),
                value: 'en',
                groupValue: currentLocale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    MyApp.controllerOf(context).setLocale(Locale(value));
                  }
                },
              ),
              RadioListTile<String>(
                title: Text(context.l10n.bulgarian),
                value: 'bg',
                groupValue: currentLocale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    MyApp.controllerOf(context).setLocale(Locale(value));
                  }
                },
              ),
              RadioListTile<String>(
                title: Text(context.l10n.swedish),
                value: 'sv',
                groupValue: currentLocale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    MyApp.controllerOf(context).setLocale(Locale(value));
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSectionCard(
            title: context.l10n.settingsAccount,
            icon: Icons.person_outline,
            children: [
              ListTile(
                leading: const Icon(Icons.alternate_email),
                title: Text(context.l10n.settingsSignedInAs),
                subtitle: Text(user?.email ?? context.l10n.unknown),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () async {
                      await Supabase.instance.client.auth.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(context.l10n.signOut),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSectionCard(
            title: context.l10n.settingsAbout,
            icon: Icons.info_outline,
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined, color: scheme.primary),
                title: Text(context.l10n.appTitle),
                subtitle: Text(context.l10n.settingsAboutDescription),
              ),
              ListTile(
                leading: Icon(Icons.alternate_email, color: scheme.primary),
                title: Text(context.l10n.settingsMadeBy),
                subtitle: const Text('nikichashadow'),
              ),
              ListTile(
                leading: Icon(Icons.code, color: scheme.primary),
                title: Text(context.l10n.settingsGithub),
                subtitle: const Text('nikichashadow-code'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () async {
                  await launchUrl(_githubUrl, mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            context.l10n.settingsFooterCredit,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsHero extends StatelessWidget {
  const _SettingsHero({required this.userEmail});

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 8),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(scheme.primaryContainer, scheme.surface, 0.28)!,
              Color.lerp(scheme.secondaryContainer, scheme.surface, 0.2)!,
            ],
          ),
          border: Border.all(color: scheme.outlineVariant.withAlpha(150)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: scheme.primary,
                  child: Icon(Icons.settings, color: scheme.onPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.settingsTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.settingsHeroSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.28,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.palette_outlined, size: 16),
                  label: Text(context.l10n.settingsAppearance),
                ),
                Chip(
                  avatar: const Icon(Icons.person_outline, size: 16),
                  label: Text(userEmail ?? context.l10n.unknown),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSectionCard extends StatelessWidget {
  const _SettingsSectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 1,
      shadowColor: scheme.shadow.withAlpha(40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: scheme.primary),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}
