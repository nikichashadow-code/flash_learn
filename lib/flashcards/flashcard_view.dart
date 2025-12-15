import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FlashcardViewPage extends StatefulWidget {
  final String setTitle;
  final List<Map<String, dynamic>> cards;

  const FlashcardViewPage({super.key, required this.setTitle, required this.cards});

  @override
  State<FlashcardViewPage> createState() => _FlashcardViewPageState();
}

class _FlashcardViewPageState extends State<FlashcardViewPage> {
  int _currentIndex = 0;
  bool _showBack = false;
  bool _isFlipping = false;

  void _flipCard() async {
    if (_isFlipping) return;
    setState(() => _isFlipping = true);
    await Future.delayed(300.ms);
    setState(() {
      _showBack = !_showBack;
      _isFlipping = false;
    });
  }

  void _nextCard() {
    setState(() {
      _showBack = false;
      if (_currentIndex < widget.cards.length - 1) {
        _currentIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.setTitle),
        leading: BackButton(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: _showBack ? 1 : 0,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                final isBack = value >= 0.5;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(pi * value),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _flipCard,
                      child: Container(
                        width: 300,
                        height: 220,
                        alignment: Alignment.center,
                        child: isBack
                            ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: Text(
                                  card['answer'] ?? '',
                                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Text(
                                card['question'] ?? '',
                                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('${_currentIndex + 1} of ${widget.cards.length}'),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _nextCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    minimumSize: const Size(120, 48),
                  ),
                  child: const Text('Know'),
                ),
                ElevatedButton(
                  onPressed: _nextCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    minimumSize: const Size(120, 48),
                  ),
                  child: const Text("Don't Know"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}