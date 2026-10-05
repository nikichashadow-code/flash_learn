import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../main.dart';
import '../services/ollama_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static final Uri _githubUrl = Uri.parse(
    'https://github.com/nikichashadow-code',
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = Supabase.instance.client.auth.currentUser;
    final currentLocale =
        Localizations.maybeLocaleOf(context) ?? const Locale('en');

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSectionCard(
            title: context.l10n.settingsAppearance,
            icon: Icons.palette_outlined,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: DropdownButtonFormField<String>(
                  initialValue: currentLocale.languageCode,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.settingsLanguage,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(context.l10n.english),
                    ),
                    DropdownMenuItem(
                      value: 'bg',
                      child: Text(context.l10n.bulgarian),
                    ),
                    DropdownMenuItem(
                      value: 'sv',
                      child: Text(context.l10n.swedish),
                    ),
                    DropdownMenuItem(
                      value: 'no',
                      child: Text(context.l10n.norwegian),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      MyApp.controllerOf(context).setLocale(Locale(value));
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _TutorSettingsSection(),
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
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (route) => false);
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
                  await launchUrl(
                    _githubUrl,
                    mode: LaunchMode.externalApplication,
                  );
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

class _TutorSettingsSection extends StatefulWidget {
  const _TutorSettingsSection();

  @override
  State<_TutorSettingsSection> createState() => _TutorSettingsSectionState();
}

class _TutorSettingsSectionState extends State<_TutorSettingsSection> {
  late Future<OllamaConfiguration> _configurationFuture;

  @override
  void initState() {
    super.initState();
    _configurationFuture = OllamaConfiguration.load();
  }

  void _reloadConfiguration() {
    setState(() => _configurationFuture = OllamaConfiguration.load());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OllamaConfiguration>(
      future: _configurationFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _TutorConfigurationForm(
            configuration: snapshot.data!,
            onReset: _reloadConfiguration,
          );
        }
        if (snapshot.hasError) {
          return _SettingsSectionCard(
            title: context.l10n.settingsTutor,
            icon: Icons.smart_toy_outlined,
            children: [
              ListTile(
                title: Text(context.l10n.settingsTutorLoadError),
                trailing: IconButton(
                  tooltip: context.l10n.settingsTutorRetry,
                  icon: const Icon(Icons.refresh),
                  onPressed: _reloadConfiguration,
                ),
              ),
            ],
          );
        }
        return _SettingsSectionCard(
          title: context.l10n.settingsTutor,
          icon: Icons.smart_toy_outlined,
          children: const [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        );
      },
    );
  }
}

class _TutorConfigurationForm extends StatefulWidget {
  const _TutorConfigurationForm({
    required this.configuration,
    required this.onReset,
  });

  final OllamaConfiguration configuration;
  final VoidCallback onReset;

  @override
  State<_TutorConfigurationForm> createState() =>
      _TutorConfigurationFormState();
}

class _TutorConfigurationFormState extends State<_TutorConfigurationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _baseUrlController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _baseUrlController = TextEditingController(
      text: widget.configuration.baseUrl,
    );
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final configuration = await OllamaConfiguration.load();
      await OllamaConfiguration.save(
        baseUrl: _baseUrlController.text,
        model: configuration.model,
        thinkingLevel: configuration.thinkingLevel,
      );
      if (mounted) _showMessage(context.l10n.settingsTutorSaved);
    } on Exception {
      if (mounted) _showMessage(context.l10n.settingsTutorSaveError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _reset() async {
    setState(() => _isSaving = true);
    try {
      await OllamaConfiguration.reset();
      final configuration = await OllamaConfiguration.load();
      if (!mounted) return;
      _baseUrlController.text = configuration.baseUrl;
      _showMessage(context.l10n.settingsTutorResetDone);
      widget.onReset();
    } on Exception {
      if (mounted) _showMessage(context.l10n.settingsTutorSaveError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SettingsSectionCard(
      title: l10n.settingsTutor,
      icon: Icons.smart_toy_outlined,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsTutorDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _baseUrlController,
                      enabled: !_isSaving,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.settingsTutorServerUrl,
                        hintText: 'http://192.168.1.10:11434',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.settingsTutorRequired;
                        }
                        return OllamaConfiguration.parseBaseUrl(value) == null
                            ? l10n.settingsTutorInvalidUrl
                            : null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving ? null : _reset,
                    child: Text(l10n.settingsTutorReset),
                  ),
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon:
                        _isSaving
                            ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.save_outlined),
                    label: Text(l10n.settingsTutorSave),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: scheme.primary),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        ...children,
      ],
    );
  }
}
