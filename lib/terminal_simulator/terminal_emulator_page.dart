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
      backgroundColor: const Color(0xFF1A1410),
      appBar: AppBar(
        title: const Text(
          'Terminal Simulator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2D2420),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF1A1410)),
        child: Column(
          children: [
            TerminalOutput(output: _output),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF3D3530), width: 1),
                ),
              ),
              child: TerminalInput(
                controller: _inputController,
                onSubmitted: _executeCommand,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
