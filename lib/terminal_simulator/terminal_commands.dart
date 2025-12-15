// filepath: lib/terminal_simulator/terminal_commands.dart
class TerminalCommands {
  static const Map<String, String> commands = {
    'ls': 'Desktop/ Documents/ Downloads/ file1.txt file2.txt',
    'pwd': '/home/user',
    'whoami': 'user',
    'date': 'Mon Jan 1 12:00:00 UTC 2024',
    'help': 'Available commands: ls, pwd, whoami, date, clear, help',
  };

  static String execute(String command) {
    if (command == 'clear') {
      return 'clear';
    } else if (commands.containsKey(command)) {
      return commands[command]!;
    } else {
      return 'Command not found: $command';
    }
  }
}
