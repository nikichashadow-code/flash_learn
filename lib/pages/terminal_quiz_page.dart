import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/command.dart';
import '../services/supabase_service.dart';

class TerminalQuizPage extends StatefulWidget {
  const TerminalQuizPage({super.key});

  @override
  State<TerminalQuizPage> createState() => _TerminalQuizPageState();
}

class _TerminalQuizPageState extends State<TerminalQuizPage> {
  final SupabaseService _service = SupabaseService();
  final Random _random = Random();

  late Future<List<Command>> _commandsFuture;
  List<Command> _commands = const [];
  List<_QuizQuestion> _questions = const [];
  _QuizQuestion? _current;
  List<String> _options = const [];

  int _score = 0;
  int _asked = 0;
  final Set<String> _selectedAnswers = <String>{};
  bool _answered = false;
  bool _revealedAnswer = false;

  @override
  void initState() {
    super.initState();
    _commandsFuture = _service.fetchCommands();
  }

  List<_QuizQuestion> _buildQuestions(List<Command> commands) {
    final grouped = <String, List<Command>>{};

    for (final cmd in commands) {
      final normalizedDescription = cmd.description.trim().toLowerCase();
      final key = normalizedDescription.isEmpty
          ? '__command__${cmd.command.toLowerCase()}'
          : normalizedDescription;
      grouped.putIfAbsent(key, () => <Command>[]).add(cmd);
    }

    return grouped.values.map((items) {
      final description = items.first.description.trim();
      return _QuizQuestion(
        description: description,
        correctCommands: items.map((c) => c.command).toSet(),
        sourceCommands: items,
      );
    }).toList();
  }

  void _startQuiz(List<Command> commands) {
    _commands = commands;
    _questions = _buildQuestions(commands);
    _score = 0;
    _asked = 0;
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_questions.length < 2) return;

    final current = _questions[_random.nextInt(_questions.length)];
    final options = <String>{...current.correctCommands};

    final targetCount = min(
      _commands.length,
      max(4, current.correctCommands.length + 2),
    );
    while (options.length < targetCount) {
      options.add(_commands[_random.nextInt(_commands.length)].command);
    }

    final shuffled = options.toList()..shuffle(_random);
    setState(() {
      _current = current;
      _options = shuffled;
      _selectedAnswers.clear();
      _answered = false;
      _revealedAnswer = false;
    });
  }

  void _toggleOption(String option) {
    if (_answered) return;
    setState(() {
      if (_selectedAnswers.contains(option)) {
        _selectedAnswers.remove(option);
      } else {
        _selectedAnswers.add(option);
      }
    });
  }

  void _selectSingleOption(String option) {
    if (_answered) return;
    setState(() {
      _selectedAnswers
        ..clear()
        ..add(option);
    });
  }

  void _submitSelection() {
    if (_answered || _current == null || _selectedAnswers.isEmpty) return;
    final correct = setEquals(_selectedAnswers, _current!.correctCommands);
    setState(() {
      _answered = true;
      if (!_revealedAnswer) {
        _asked += 1;
        if (correct) _score += 1;
      }
    });
  }

  String? _distroNoteFor(_QuizQuestion question) {
    final commandText = question.correctCommands.join(' ').toLowerCase();
    final descriptionText = question.description.toLowerCase();
    final combined = '$commandText $descriptionText';

    bool hasAny(List<String> patterns) =>
        patterns.any((pattern) => combined.contains(pattern));

    final notes = <String>[];
    if (hasAny(['xbps', 'void linux', 'voidlinux'])) {
      notes.add('Void Linux (xbps)');
    }
    if (hasAny(['pacman', 'makepkg', 'arch linux', 'arch-based'])) {
      notes.add('Arch family');
    }
    if (hasAny(['apt', 'apt-get', 'dpkg', 'debian', 'ubuntu', 'mint'])) {
      notes.add('Debian/Ubuntu family');
    }
    if (hasAny(['dnf', 'yum', 'rpm', 'fedora', 'rhel', 'centos'])) {
      notes.add('Fedora/RHEL family');
    }
    if (hasAny(['zypper', 'opensuse', 'suse'])) {
      notes.add('openSUSE/SUSE');
    }
    if (hasAny(['emerge', 'portage', 'gentoo'])) {
      notes.add('Gentoo');
    }
    if (hasAny(['apk add', ' apk ', 'alpine'])) {
      notes.add('Alpine Linux');
    }

    if (notes.isEmpty) return null;
    return 'Note: This question includes distro-specific commands (${notes.join(', ')}).';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Terminal Quiz')),
      body: FutureBuilder<List<Command>>(
        future: _commandsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final commands = snapshot.data ?? [];
          if (commands.length < 2) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Not enough commands in Supabase to build a quiz yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (_current == null || _commands.isEmpty || _questions.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _startQuiz(commands);
            });
            return const Center(child: CircularProgressIndicator());
          }

          final current = _current!;
          final progress = _asked == 0 ? 0.0 : (_score / _asked);
          final distroNote = _distroNoteFor(current);
          final hasMultipleAnswers = current.correctCommands.length > 1;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Score: $_score / $_asked'),
                        Text('Accuracy: ${(progress * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select all commands that match this description:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _answered
                                  ? null
                                  : () {
                                      setState(() {
                                        _revealedAnswer = true;
                                      });
                                    },
                              icon: const Icon(Icons.visibility),
                              label: const Text('Show answer'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          current.description.isEmpty
                              ? 'No description available for this command.'
                              : current.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        AnimatedSlide(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          offset: distroNote == null
                              ? const Offset(0, -0.18)
                              : Offset.zero,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 220),
                            opacity: distroNote == null ? 0 : 1,
                            child: distroNote == null
                                ? const SizedBox.shrink()
                                : Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withAlpha(
                                        (0.17 * 255).round(),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.amber.withAlpha(
                                          (0.6 * 255).round(),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Icon(
                                            Icons.info_outline,
                                            size: 18,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            distroNote,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        if (_revealedAnswer) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Answers: ${current.correctCommands.join(', ')}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontFamily: 'monospace',
                                  color: scheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'This question is now practice-only and will not change your score.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ..._options.map((option) {
                  final isSelected = _selectedAnswers.contains(option);
                  final isCorrect = current.correctCommands.contains(option);

                  Color? bg;
                  if (_answered && isCorrect) {
                    bg = Colors.green.withAlpha((0.2 * 255).round());
                  } else if (_answered && isSelected && !isCorrect) {
                    bg = scheme.errorContainer;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: hasMultipleAnswers
                          ? CheckboxListTile(
                              value: isSelected,
                              onChanged: _answered
                                  ? null
                                  : (_) => _toggleOption(option),
                              title: Text(
                                option,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              secondary: _answered && isCorrect
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : null,
                            )
                          : ListTile(
                              selected: isSelected,
                              title: Text(
                                option,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                              trailing: _answered && isCorrect
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : null,
                              onTap: _answered
                                  ? null
                                  : () => _selectSingleOption(option),
                            ),
                    ),
                  );
                }),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _startQuiz(commands),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Restart'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _answered
                            ? _nextQuestion
                            : (_selectedAnswers.isEmpty
                                  ? null
                                  : _submitSelection),
                        icon: Icon(_answered ? Icons.arrow_forward : Icons.check),
                        label: Text(_answered ? 'Next' : 'Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuizQuestion {
  const _QuizQuestion({
    required this.description,
    required this.correctCommands,
    required this.sourceCommands,
  });

  final String description;
  final Set<String> correctCommands;
  final List<Command> sourceCommands;
}
