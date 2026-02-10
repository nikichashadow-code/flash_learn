import 'dart:convert';
import 'dart:async';
import 'package:dartssh2/dartssh2.dart';
import '../models/ssh_connection.dart';

class SSHService {
  SSHClient? _client;
  SSHSession? _shell;
  bool _isConnected = false;
  final StringBuffer _outputBuffer = StringBuffer();
  StreamSubscription? _stdoutSubscription;
  StreamSubscription? _stderrSubscription;

  bool get isConnected => _isConnected;

  Future<bool> connect(SSHConnection connection) async {
    try {
      final socket = await SSHSocket.connect(connection.host, connection.port);

      _client = SSHClient(
        socket,
        username: connection.username,
        onPasswordRequest: () {
          if (connection.password != null && connection.password!.isNotEmpty) {
            return connection.password!;
          }
          throw Exception('Password required but not provided');
        },
      );

      _shell = await _client!.shell();
      _startListeningToShell();

      _isConnected = true;
      return true;
    } catch (e) {
      _isConnected = false;
      rethrow;
    }
  }

  void _startListeningToShell() {
    _stdoutSubscription = _shell!.stdout.listen(
      (chunk) {
        _outputBuffer.write(utf8.decode(chunk, allowMalformed: true));
      },
      onError: (e) {},
      onDone: () {},
    );

    _stderrSubscription = _shell!.stderr.listen(
      (chunk) {
        _outputBuffer.write(utf8.decode(chunk, allowMalformed: true));
      },
      onError: (e) {},
      onDone: () {},
    );
  }

  Future<String> executeCommand(String command) async {
    if (!_isConnected || _shell == null) {
      throw Exception('Not connected to SSH server');
    }

    try {
      _outputBuffer.clear();

      // Use a unique marker that's unlikely to appear in output
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final marker = '___END_MARKER_${timestamp}___';

      // Send command with marker on separate line
      final fullCommand = '$command\necho "$marker"\n';
      _shell!.write(utf8.encode(fullCommand));

      // Wait for marker with timeout
      final startTime = DateTime.now();
      const timeout = Duration(seconds: 15);
      const pollInterval = Duration(milliseconds: 100);

      while (!_outputBuffer.toString().contains(marker)) {
        if (DateTime.now().difference(startTime) > timeout) {
          throw Exception('SSH command execution timeout');
        }
        await Future.delayed(pollInterval);
      }

      // Extract everything between command and marker
      String fullOutput = _outputBuffer.toString();
      final markerIndex = fullOutput.indexOf(marker);

      if (markerIndex == -1) {
        throw Exception('Marker not found in output');
      }

      // Get output before marker
      String result = fullOutput.substring(0, markerIndex);

      // Remove the command line echo that appears at the start
      // The shell echoes back what you type
      if (result.startsWith(command)) {
        result = result.substring(command.length);
      }

      // Clean up
      result = _cleanOutput(result);

      return result.isEmpty ? '✓ Command executed successfully' : result;
    } catch (e) {
      rethrow;
    }
  }

  String _cleanOutput(String output) {
    // Remove ANSI escape codes
    output = output.replaceAll(RegExp(r'\x1b\[[0-9;]*m'), '');
    output = output.replaceAll(RegExp(r'\x1b\[K'), '');

    // Remove carriage returns
    output = output.replaceAll('\r', '');

    // Remove job control numbers like [173041]
    output = output.replaceAll(RegExp(r'\[\d+\]\s*'), '');

    // Remove shell prompts (common patterns)
    output = output.replaceAll(RegExp(r'.*@.*:.*\$\s*'), '');
    output = output.replaceAll(RegExp(r'>\s*$'), '');

    // Remove echo command artifacts
    output = output.replaceAll(RegExp(r'echo\s+"?\s*'), '');
    output = output.replaceAll(RegExp(r'echo\s*$'), '');

    // Normalize newlines
    output = output.replaceAll(RegExp(r'\n+'), '\n');

    // Remove leading/trailing whitespace
    return output.trim();
  }

  Future<void> disconnect() async {
    try {
      await _stdoutSubscription?.cancel();
      await _stderrSubscription?.cancel();
      _shell?.close();
      _client?.close();
    } catch (e) {
      // Handle silently
    } finally {
      _shell = null;
      _client = null;
      _stdoutSubscription = null;
      _stderrSubscription = null;
      _outputBuffer.clear();
      _isConnected = false;
    }
  }
}
