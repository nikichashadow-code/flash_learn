// filepath: lib/terminal_simulator/terminal_output.dart
import 'package:flutter/material.dart';

class TerminalOutput extends StatelessWidget {
  final List<String> output;
  final ScrollController scrollController;

  const TerminalOutput({
    super.key,
    required this.output,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xFF1A1410),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: ListView.builder(
          controller: scrollController,
          itemCount: output.length,
          itemBuilder: (context, index) {
            final line = output[index];
            final isPrompt = line.startsWith('\$ ');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: SelectableText(
                line,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.35,
                  color: isPrompt
                      ? const Color(0xFFE8C547)
                      : const Color(0xFFD4AF37),
                  fontFamily: 'Courier New',
                  fontWeight: isPrompt ? FontWeight.w600 : FontWeight.normal,
                  letterSpacing: 0.3,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
