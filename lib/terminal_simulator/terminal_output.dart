// filepath: lib/terminal_simulator/terminal_output.dart
import 'package:flutter/material.dart';

class TerminalOutput extends StatelessWidget {
  final List<String> output;

  const TerminalOutput({super.key, required this.output});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: output.length,
        itemBuilder: (context, index) => Text(output[index]),
      ),
    );
  }
}
