import 'dart:convert';
import 'dart:io';

import 'package:flash_learn/l10n/app_localizations.dart';
import 'package:flash_learn/terminal_simulator/terminal_commands.dart';
import 'package:flash_learn/terminal_simulator/terminal_emulator_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void _writeLog(Map<String, Object?> payload) {
  File('debug-6a4534.log').writeAsStringSync(
    '${jsonEncode(payload)}\n',
    mode: FileMode.append,
  );
}

void main() {
  setUp(() {
    TerminalCommands.resetSession();
    TerminalCommands.agentLog = (payload) {
      _writeLog(Map<String, Object?>.from(payload));
    };
  });

  test('command engine runs core and new commands', () {
    const cmds = [
      'help',
      'ls',
      'ls -la',
      'pwd',
      'echo hello',
      'echo hi > /tmp/out.txt',
      'cat /tmp/out.txt',
      'cat Documents/notes.txt | grep todo',
      'tree',
      'find ~ -name *.txt',
      'cal',
      'neofetch',
      'mkdir -p practice/lab',
      'cd Documents && pwd',
      'll',
    ];
    for (final cmd in cmds) {
      try {
        final out = TerminalCommands.execute(cmd);
        _writeLog({
          'sessionId': '6a4534',
          'hypothesisId': 'B',
          'location': 'terminal_simulator_debug_test.dart',
          'message': 'cmd result',
          'data': {
            'cmd': cmd,
            'ok': true,
            'outHead': out.length > 80 ? out.substring(0, 80) : out,
          },
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      } catch (e, st) {
        _writeLog({
          'sessionId': '6a4534',
          'hypothesisId': 'B',
          'location': 'terminal_simulator_debug_test.dart',
          'message': 'cmd throw',
          'data': {'cmd': cmd, 'error': e.toString(), 'stack': st.toString()},
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
        fail('execute("$cmd") threw $e');
      }
    }
  });

  testWidgets('terminal page loads and can run ls', (tester) async {
    FlutterError.onError = (details) {
      _writeLog({
        'sessionId': '6a4534',
        'hypothesisId': 'A',
        'location': 'terminal_simulator_debug_test.dart:FlutterError',
        'message': 'flutter error',
        'data': {
          'error': details.exceptionAsString(),
          'stack': details.stack.toString(),
        },
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    };

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: TerminalEmulatorPage(),
      ),
    );
    await tester.pumpAndSettle();

    _writeLog({
      'sessionId': '6a4534',
      'hypothesisId': 'A',
      'location': 'terminal_simulator_debug_test.dart',
      'message': 'page pumped',
      'data': {
        'hasPage': find.byType(TerminalEmulatorPage).evaluate().isNotEmpty,
        'textFields': find.byType(TextField).evaluate().length,
      },
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    expect(find.byType(TerminalEmulatorPage), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'ls');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    _writeLog({
      'sessionId': '6a4534',
      'hypothesisId': 'C',
      'location': 'terminal_simulator_debug_test.dart',
      'message': 'after ls submit',
      'data': {'exception': tester.takeException()?.toString()},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  });
}
