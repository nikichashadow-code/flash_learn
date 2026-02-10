// filepath: lib/terminal_simulator/terminal_output.dart
import 'package:flutter/material.dart';

class TerminalOutput extends StatelessWidget {
  final List<String> output;

  const TerminalOutput({super.key, required this.output});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xFF1A1410),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: output.length,
          itemBuilder:
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  output[index],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFD4AF37),
                    fontFamily: 'Courier New',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
