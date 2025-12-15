// filepath: lib/terminal_simulator/terminal_emulator_page.dart
import 'package:flutter/material.dart';
import 'terminal_commands.dart';
import 'terminal_output.dart';
import 'terminal_input.dart';

class TerminalEmulatorPage extends StatefulWidget {
  const TerminalEmulatorPage({super.key});

  @override
  State<TerminalEmulatorPage> createState() => _TerminalEmulatorPageState();
}

class _TerminalEmulatorPageState extends State<TerminalEmulatorPage> {
  final TextEditingController _inputController = TextEditingController();
  final List<String> _output = [];

  void _executeCommand(String command) {
    setState(() {
      _output.add('\$ $command');
      final result = TerminalCommands.execute(command);
      if (result == 'clear') {
        _output.clear();
      } else {
        _output.add(result);
      }
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terminal Simulator')),
      body: Column(
        children: [
          TerminalOutput(output: _output),
          TerminalInput(
            controller: _inputController,
            onSubmitted: _executeCommand,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}