import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/l10n.dart';

class FlashcardViewPage extends StatefulWidget {
  final String setTitle;
  final List<Map<String, dynamic>> cards;

  const FlashcardViewPage({
    super.key,
    required this.setTitle,
    required this.cards,
  });

  @override
  State<FlashcardViewPage> createState() => _FlashcardViewPageState();
}

class _FlashcardViewPageState extends State<FlashcardViewPage> {
  int _currentIndex = 0;
  bool _showBack = false;
  bool _isFlipping = false;
  int _knownCount = 0;
  bool _completed = false;

  void _flipCard() async {
    if (_isFlipping) return;
    setState(() => _isFlipping = true);
    await Future.delayed(300.ms);
    if (!mounted) return;
    setState(() {
      _showBack = !_showBack;
      _isFlipping = false;
    });
  }

  void _rateCard(bool known) {
    if (_completed) return;
    setState(() {
      if (known) _knownCount++;
      _showBack = false;
      if (_currentIndex < widget.cards.length - 1) {
        _currentIndex++;
      } else {
        _completed = true;
      }
    });
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _knownCount = 0;
      _showBack = false;
      _completed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.setTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.celebration_outlined, size: 72),
                const SizedBox(height: 20),
                Text(
                  context.l10n.flashcardComplete,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.flashcardScore(_knownCount, widget.cards.length),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _restart,
                  icon: const Icon(Icons.replay),
                  label: Text(context.l10n.restartStudy),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final card = widget.cards[_currentIndex];
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.setTitle), leading: BackButton()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _showBack ? 1 : 0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                final isBack = value >= 0.5;
                return Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(pi * value),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Card(
                      color: scheme.surfaceContainerHighest,
                      elevation: 6,
                      shadowColor: scheme.primary.withAlpha(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(color: scheme.primary, width: 2),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: _flipCard,
                        child: SizedBox(
                          width: 320,
                          height: 240,
                          child: Center(
                            child:
                                isBack
                                    ? Transform(
                                      alignment: Alignment.center,
                                      transform:
                                          Matrix4.identity()..rotateY(pi),
                                      child: Text(
                                        card['answer'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                    : Text(
                                      card['question'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.flashcardProgress(
                _currentIndex + 1,
                widget.cards.length,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _rateCard(true),
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text(context.l10n.know),
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _rateCard(false),
                      icon: const Icon(Icons.refresh),
                      label: Text(context.l10n.dontKnow),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.error,
                        side: BorderSide(color: scheme.error),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
