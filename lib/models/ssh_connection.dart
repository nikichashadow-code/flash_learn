class SSHConnection {
  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String? password;
  final bool savePassword;

  SSHConnection({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    this.password,
    required this.savePassword,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'host': host,
    'port': port,
    'username': username,
    'password': savePassword ? password : null,
    'savePassword': savePassword,
  };

  factory SSHConnection.fromJson(Map<String, dynamic> json) => SSHConnection(
    id: json['id'],
    name: json['name'],
    host: json['host'],
    port: json['port'] ?? 22,
    username: json['username'],
    password: json['password'],
    savePassword: json['savePassword'] ?? false,
  );
}
