import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/ollama_service.dart';

class OllamaTutorPage extends StatefulWidget {
  const OllamaTutorPage({super.key});

  @override
  State<OllamaTutorPage> createState() => _OllamaTutorPageState();
}

class _OllamaTutorPageState extends State<OllamaTutorPage> {
  final _questionController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_TutorMessage> _messages = [
    const _TutorMessage(text: 'Ask me anything about Linux.', isUser: false),
  ];
  final _service = OllamaService();
  OllamaConfiguration? _configuration;
  List<String> _installedModels = const [];
  List<String> _thinkingValues = const [];
  String? _selectedModel;
  String? _selectedThinkingLevel;
  bool _isDiscoveringModels = false;
  bool _isCheckingThinking = false;
  bool _isSavingModel = false;
  bool _isSavingThinking = false;
  bool _isSending = false;
  int _thinkingRequestId = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadConfiguration());
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConfiguration() async {
    try {
      final configuration = await OllamaConfiguration.load();
      if (!mounted) return;
      setState(() {
        _configuration = configuration;
        _selectedModel =
            configuration.model.isEmpty ? null : configuration.model;
        _selectedThinkingLevel = configuration.thinkingLevel;
      });
    } on Exception {
      if (!mounted) return;
      _showMessage(context.l10n.settingsTutorLoadError);
      return;
    }
    await _refreshInstalledModels();
    await _refreshThinkingOptions();
  }

  Future<void> _refreshInstalledModels() async {
    final configuration = _configuration;
    if (configuration == null) return;

    setState(() => _isDiscoveringModels = true);
    try {
      final models = await _service.fetchInstalledModels(configuration.baseUrl);
      if (!mounted) return;
      final availableModels = [...models];
      final selectedModel = _selectedModel;
      if (selectedModel != null && !availableModels.contains(selectedModel)) {
        availableModels.insert(0, selectedModel);
      }
      setState(() => _installedModels = availableModels);
      if (models.isEmpty) {
        _showMessage(context.l10n.settingsTutorNoModelsFound);
      }
    } on TutorException catch (error) {
      if (mounted) _showMessage(error.message);
    } on Exception {
      if (mounted) _showMessage(context.l10n.settingsTutorModelFetchError);
    } finally {
      if (mounted) setState(() => _isDiscoveringModels = false);
    }
  }

  Future<void> _selectModel(String model) async {
    final configuration = _configuration;
    if (configuration == null || _isSavingModel) return;

    final previousModel = _selectedModel;
    ++_thinkingRequestId;
    setState(() {
      _selectedModel = model;
      _isSavingModel = true;
      _thinkingValues = const [];
      _isCheckingThinking = true;
    });
    try {
      await OllamaConfiguration.save(
        baseUrl: configuration.baseUrl,
        model: model,
        thinkingLevel: configuration.thinkingLevel,
      );
      if (!mounted) return;
      setState(() {
        _configuration = OllamaConfiguration(
          baseUrl: configuration.baseUrl,
          model: model,
          thinkingLevel: configuration.thinkingLevel,
        );
        _selectedModel = model;
      });
      await _refreshThinkingOptions();
    } on Exception {
      if (mounted) {
        setState(() {
          _selectedModel = previousModel;
          _thinkingValues = const [];
        });
        _showMessage(context.l10n.settingsTutorSaveError);
        await _refreshThinkingOptions();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingModel = false;
          _isCheckingThinking = false;
        });
      }
    }
  }

  Future<void> _refreshThinkingOptions() async {
    final configuration = _configuration;
    final model = _selectedModel;
    if (configuration == null || model == null) return;

    final requestId = ++_thinkingRequestId;
    setState(() => _isCheckingThinking = true);
    try {
      final info = await _service.fetchThinkingInfo(
        baseUrl: configuration.baseUrl,
        model: model,
      );
      if (!mounted ||
          requestId != _thinkingRequestId ||
          _selectedModel != model ||
          _configuration?.baseUrl != configuration.baseUrl) {
        return;
      }

      final values =
          info != null && info.supportsThinking
              ? info.values
              : const <String>[];
      final currentLevel = _selectedThinkingLevel;
      final supportedLevel =
          currentLevel != null && values.contains(currentLevel)
              ? currentLevel
              : null;
      setState(() {
        _thinkingValues = values;
        _selectedThinkingLevel = supportedLevel;
      });
      if (currentLevel != supportedLevel) {
        await _saveThinkingLevel(supportedLevel);
        if (currentLevel != null && mounted) {
          _showMessage(context.l10n.settingsTutorThinkingSelectionReset);
        }
      }
    } on TutorException catch (error) {
      if (mounted && requestId == _thinkingRequestId) {
        _showMessage(error.message);
      }
    } on Exception {
      if (mounted && requestId == _thinkingRequestId) {
        _showMessage(context.l10n.settingsTutorThinkingCheckError);
      }
    } finally {
      if (mounted && requestId == _thinkingRequestId) {
        setState(() => _isCheckingThinking = false);
      }
    }
  }

  Future<void> _saveThinkingLevel(String? value) async {
    final configuration = _configuration;
    if (configuration == null) return;

    setState(() => _isSavingThinking = true);
    try {
      await OllamaConfiguration.save(
        baseUrl: configuration.baseUrl,
        model: _selectedModel ?? configuration.model,
        thinkingLevel: value,
      );
      if (!mounted) return;
      setState(() {
        _selectedThinkingLevel = value;
        _configuration = OllamaConfiguration(
          baseUrl: configuration.baseUrl,
          model: _selectedModel ?? configuration.model,
          thinkingLevel: value,
        );
      });
    } on Exception {
      if (mounted) _showMessage(context.l10n.settingsTutorSaveError);
    } finally {
      if (mounted) setState(() => _isSavingThinking = false);
    }
  }

  Future<void> _showModelSelector() async {
    final model = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
                child: Text(
                  context.l10n.settingsTutorSelectModel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ..._installedModels.map(
                (model) => ListTile(
                  title: Text(model),
                  trailing:
                      model == _selectedModel ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.pop(context, model),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (model != null && model != _selectedModel) {
      await _selectModel(model);
    }
  }

  Future<void> _showThinkingSelector() async {
    final choices = <({String? value, String label})>[
      (value: null, label: context.l10n.settingsTutorThinkingOff),
      ..._thinkingValues.map(
        (value) => (value: value, label: _thinkingChoiceLabel(context, value)),
      ),
    ];
    final choice = await showModalBottomSheet<({String? value, String label})>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
                child: Text(
                  context.l10n.settingsTutorThinking,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...choices.map(
                (choice) => ListTile(
                  title: Text(choice.label),
                  trailing:
                      choice.value == _selectedThinkingLevel
                          ? const Icon(Icons.check)
                          : null,
                  onTap: () => Navigator.pop(context, choice),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (choice != null && choice.value != _selectedThinkingLevel) {
      await _saveThinkingLevel(choice.value);
    }
  }

  String _thinkingChoiceLabel(BuildContext context, String value) {
    return switch (value) {
      'true' => context.l10n.settingsTutorThinkingOn,
      'false' => context.l10n.settingsTutorThinkingFalse,
      'low' => context.l10n.settingsTutorThinkingLow,
      'medium' => context.l10n.settingsTutorThinkingMedium,
      'high' => context.l10n.settingsTutorThinkingHigh,
      _ => value,
    };
  }

  Future<void> _sendQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty || _isSending) return;
    final model = _selectedModel;
    if (model == null) {
      _showMessage(context.l10n.settingsTutorSelectModel);
      return;
    }

    _questionController.clear();
    setState(() {
      _messages.add(_TutorMessage(text: question, isUser: true));
      _isSending = true;
    });
    _scrollToBottom();

    try {
      final answer = await _service.ask(question, model: model);
      if (!mounted) return;
      setState(() => _messages.add(_TutorMessage(text: answer, isUser: false)));
    } catch (error) {
      if (!mounted) return;
      setState(
        () => _messages.add(
          _TutorMessage(
            text: _friendlyError(error),
            isUser: false,
            isError: true,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
        _scrollToBottom();
      }
    }
  }

  String _friendlyError(Object error) {
    if (error is TutorException) return error.message;
    return error is StateError
        ? error.message
        : 'Please check your connection and try again.';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final modelLabel = _selectedModel ?? context.l10n.settingsTutorSelectModel;
    final thinkingLabel =
        _isCheckingThinking
            ? context.l10n.settingsTutorCheckingThinking
            : _selectedThinkingLevel == null
            ? context.l10n.settingsTutorThinkingOff
            : _thinkingChoiceLabel(context, _selectedThinkingLevel!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlashLearn AI'),
        actions: [
          IconButton(
            tooltip: 'Clear conversation',
            icon: const Icon(Icons.refresh),
            onPressed:
                _isSending
                    ? null
                    : () => setState(() {
                      _messages
                        ..clear()
                        ..add(
                          const _TutorMessage(
                            text: 'Ask me anything about Linux.',
                            isUser: false,
                          ),
                        );
                    }),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              itemCount: _messages.length + (_isSending ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isSending && index == _messages.length) {
                  return const _TypingIndicator();
                }
                return _MessageBubble(message: _messages[index]);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withAlpha(150),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _questionController,
                        enabled: !_isSending,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendQuestion(),
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Ask a Linux question...',
                          hintStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: SingleChildScrollView(
                              child: _ComposerSelector(
                                icon: Icons.smart_toy_outlined,
                                label: modelLabel,
                                onPressed:
                                    !_isSending &&
                                            !_isSavingModel &&
                                            !_isDiscoveringModels &&
                                            _installedModels.isNotEmpty
                                        ? _showModelSelector
                                        : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            flex: 2,
                            child: _ComposerSelector(
                              icon:
                                  _isCheckingThinking
                                      ? Icons.hourglass_top
                                      : Icons.lightbulb_outline,
                              label: thinkingLabel,
                              onPressed:
                                  !_isSending &&
                                          !_isCheckingThinking &&
                                          !_isSavingThinking &&
                                          _thinkingValues.isNotEmpty
                                      ? _showThinkingSelector
                                      : null,
                            ),
                          ),
                          if (_isDiscoveringModels) ...[
                            const SizedBox(width: 8),
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ],
                          IconButton.filled(
                            tooltip: 'Send question',
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              minimumSize: const Size(52, 52),
                            ),
                            icon: const Icon(Icons.arrow_upward, size: 30),
                            onPressed:
                                !_isSending &&
                                        !_isSavingModel &&
                                        !_isSavingThinking &&
                                        !_isDiscoveringModels
                                    ? _sendQuestion
                                    : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorMessage {
  final String text;
  final bool isUser;
  final bool isError;

  const _TutorMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
  });
}

class _ComposerSelector extends StatelessWidget {
  const _ComposerSelector({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: scheme.primary),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _TutorMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background =
        message.isError
            ? scheme.errorContainer
            : message.isUser
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest;
    final foreground =
        message.isError
            ? scheme.onErrorContainer
            : message.isUser
            ? scheme.onPrimaryContainer
            : scheme.onSurfaceVariant;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 680),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
        ),
        child: SelectableText(
          message.text,
          style: TextStyle(color: foreground, height: 1.4),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12, left: 16),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
