class Command {
  final int id;
  final String command;
  final String description;
  final Map<String, dynamic> flags;

  Command({
    required this.id,
    required this.command,
    required this.description,
    required this.flags,
  });

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(
      id: json['id'],
      command: json['command'],
      description: json['description'] ?? '',
      flags: json['flags'] ?? {},
    );
  }
}
