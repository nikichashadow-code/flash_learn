// filepath: lib/terminal_simulator/terminal_emulator_page.dart
import 'package:flutter/material.dart';
import 'terminal_commands.dart';
import 'terminal_output.dart';
import 'terminal_input.dart';
import '../l10n/l10n.dart';

class TerminalEmulatorPage extends StatefulWidget {
  const TerminalEmulatorPage({super.key});

  @override
  State<TerminalEmulatorPage> createState() => _TerminalEmulatorPageState();
}

class _TerminalEmulatorPageState extends State<TerminalEmulatorPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final List<String> _output;

  @override
  void initState() {
    super.initState();
    // #region agent log
    TerminalCommands.agentLog?.call({
      'sessionId': '6a4534',
      'hypothesisId': 'A',
      'location': 'terminal_emulator_page.dart:initState',
      'message': 'page init',
      'data': {'cwd': TerminalCommands.cwd},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'runId': 'pre-fix',
    });
    // #endregion
    _output = [TerminalCommands.welcomeBanner];
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    });
  }

  void _executeCommand(String command) {
    // #region agent log
    TerminalCommands.agentLog?.call({
      'sessionId': '6a4534',
      'hypothesisId': 'D',
      'location': 'terminal_emulator_page.dart:_executeCommand',
      'message': 'submit',
      'data': {'command': command},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'runId': 'pre-fix',
    });
    // #endregion
    try {
      setState(() {
        _output.add('${TerminalCommands.prompt}\$ $command');
        final result = TerminalCommands.execute(command);
        if (result == 'clear') {
          _output
            ..clear()
            ..add(TerminalCommands.welcomeBanner);
        } else if (result == 'exit') {
          Navigator.of(context).maybePop();
        } else if (result.isNotEmpty) {
          _output.add(result);
        }
        _inputController.clear();
      });
      _scrollToEnd();
    } catch (e, st) {
      // #region agent log
      TerminalCommands.agentLog?.call({
        'sessionId': '6a4534',
        'hypothesisId': 'D',
        'location': 'terminal_emulator_page.dart:_executeCommand',
        'message': 'throw',
        'data': {'error': e.toString(), 'stack': st.toString()},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'runId': 'pre-fix',
      });
      // #endregion
      rethrow;
    }
  }

  void _reset() {
    setState(() {
      TerminalCommands.resetSession();
      _output
        ..clear()
        ..add(TerminalCommands.welcomeBanner);
      _inputController.clear();
    });
  }

  void _showCheatsheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF2D2420),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        const groups = <String, List<String>>{
          'Files': ['ls -la', 'cd Documents', 'pwd', 'tree', 'find ~ -name "*.txt"'],
          'Create / edit': [
            'mkdir -p practice/lab',
            'echo hello > notes.txt',
            'cat notes.txt',
            'chmod 755 notes.txt',
          ],
          'Text': [
            'grep -i todo Documents/notes.txt',
            'cat /etc/passwd | cut -d: -f1',
            'sort Documents/names.txt | uniq -c',
            'echo hello | tr a-z A-Z',
          ],
          'System': ['whoami', 'uname -a', 'ps', 'free', 'neofetch', 'cal'],
        };
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              const Text(
                'Try these',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              for (final entry in groups.entries) ...[
                Text(
                  entry.key,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                for (final cmd in entry.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _inputController.text = cmd;
                        _inputController.selection = TextSelection.collapsed(
                          offset: cmd.length,
                        );
                      },
                      child: Text(
                        '  $cmd',
                        style: const TextStyle(
                          color: Color(0xFFE8D5A3),
                          fontFamily: 'Courier New',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1410),
      appBar: AppBar(
        title: Text(
          context.l10n.terminalSimulatorTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2D2420),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Command ideas',
            onPressed: _showCheatsheet,
            icon: const Icon(Icons.lightbulb_outline),
          ),
          IconButton(
            tooltip: 'Reset session',
            onPressed: _reset,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF1A1410)),
        child: Column(
          children: [
            TerminalOutput(
              output: _output,
              scrollController: _scrollController,
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF3D3530), width: 1),
                ),
              ),
              child: TerminalInput(
                controller: _inputController,
                onSubmitted: _executeCommand,
                prompt: TerminalCommands.prompt,
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
    _scrollController.dispose();
    super.dispose();
  }
}
