import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/ssh_connection.dart';
import '../services/ssh_service.dart';

class SSHClientPage extends StatefulWidget {
  const SSHClientPage({super.key});

  @override
  State<SSHClientPage> createState() => _SSHClientPageState();
}

class _SSHClientPageState extends State<SSHClientPage> {
  final SSHService _sshService = SSHService();
  final TextEditingController _commandController = TextEditingController();
  final List<String> _output = [];
  List<SSHConnection> _savedConnections = [];
  SSHConnection? _currentConnection;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadSavedConnections();
  }

  Future<void> _loadSavedConnections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final connectionsJson = prefs.getStringList('ssh_connections') ?? [];

      setState(() {
        _savedConnections =
            connectionsJson
                .map((json) => SSHConnection.fromJson(jsonDecode(json)))
                .toList();
      });
    } catch (e) {
      _showError('Error loading saved connections: $e');
    }
  }

  Future<void> _saveConnection(SSHConnection connection) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final connections = [
        ..._savedConnections.where((c) => c.id != connection.id),
        connection,
      ];

      final connectionsJson =
          connections.map((c) => jsonEncode(c.toJson())).toList();

      await prefs.setStringList('ssh_connections', connectionsJson);

      setState(() {
        _savedConnections = connections;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Connection saved')));
      }
    } catch (e) {
      _showError('Error saving connection: $e');
    }
  }

  Future<void> _connect(SSHConnection connection) async {
    SSHConnection connToUse = connection;

    // If password wasn't saved, prompt for it
    if (connection.password == null || connection.password!.isEmpty) {
      final password = await _showPasswordPrompt(connection);
      if (password == null) return; // User cancelled

      connToUse = SSHConnection(
        id: connection.id,
        name: connection.name,
        host: connection.host,
        port: connection.port,
        username: connection.username,
        password: password,
        savePassword: false,
      );
    }

    try {
      await _sshService.connect(connToUse);

      setState(() {
        _currentConnection = connToUse;
        _isConnected = true;
        _output.clear();
        _output.add('✓ Connected to ${connToUse.host}');
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Connected successfully')));
      }
    } catch (e) {
      _showError('Connection failed: $e');
    }
  }

  Future<String?> _showPasswordPrompt(SSHConnection connection) async {
    final passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Enter Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Password for ${connection.username}@${connection.host}:'),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (passwordController.text.isEmpty) {
                    _showError('Password cannot be empty');
                    return;
                  }
                  Navigator.pop(context, passwordController.text);
                },
                child: const Text('Connect'),
              ),
            ],
          ),
    );
  }

  Future<void> _executeCommand(String command) async {
    if (!_isConnected || _currentConnection == null) {
      _showError('Not connected to any server');
      return;
    }

    // Handle clear command locally
    if (command.trim() == 'clear') {
      setState(() {
        _output.clear();
      });
      _commandController.clear();
      return;
    }

    setState(() {
      _output.add('\$ $command');
    });

    try {
      final result = await _sshService.executeCommand(command);

      setState(() {
        if (result.isEmpty) {
          _output.add('(no output)');
        } else {
          _output.addAll(result.split('\n').where((line) => line.isNotEmpty));
        }
      });
    } catch (e) {
      setState(() {
        _output.add('Error: $e');
      });
    } finally {
      _commandController.clear();
    }
  }

  Future<void> _disconnect() async {
    await _sshService.disconnect();

    setState(() {
      _isConnected = false;
      _currentConnection = null;
      _output.add('\n✗ Disconnected');
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Client'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          if (_isConnected)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  '● Connected',
                  style: TextStyle(color: Colors.green[400]),
                ),
              ),
            ),
        ],
      ),
      body: !_isConnected ? _buildConnectionList() : _buildTerminalInterface(),
    );
  }

  Widget _buildConnectionList() {
    return Column(
      children: [
        Expanded(
          child:
              _savedConnections.isEmpty
                  ? Center(
                    child: Text(
                      'No saved connections\nCreate a new one to get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _savedConnections.length,
                    itemBuilder: (context, index) {
                      final conn = _savedConnections[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.storage),
                          title: Text(conn.name),
                          subtitle: Text(
                            '${conn.username}@${conn.host}:${conn.port}',
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    child: const Text('Connect'),
                                    onTap: () => _connect(conn),
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Delete'),
                                    onTap: () => _deleteConnection(conn.id),
                                  ),
                                ],
                          ),
                          onTap: () => _connect(conn),
                        ),
                      );
                    },
                  ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('New Connection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => _showNewConnectionDialog(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTerminalInterface() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey[900],
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _currentConnection?.name ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout, size: 16),
                label: const Text('Disconnect'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onPressed: _disconnect,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: const Color(0xFF1A1410),
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: _output.length,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      _output[index],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFD4AF37),
                        fontFamily: 'Courier New',
                      ),
                    ),
                  ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey)),
            color: Color(0xFF1A1410),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '\$ ',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFD4AF37),
                  fontFamily: 'Courier New',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _commandController,
                  onSubmitted: _executeCommand,
                  cursorColor: const Color(0xFFD4AF37),
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontFamily: 'Courier New',
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'type command',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9D8B6F),
                      fontFamily: 'Courier New',
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    filled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showNewConnectionDialog() {
    final nameController = TextEditingController();
    final hostController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final portController = TextEditingController(text: '22');
    bool savePassword = false;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('New SSH Connection'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Connection Name',
                            hintText: 'e.g., My Server',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: hostController,
                          decoration: const InputDecoration(
                            labelText: 'Host/IP Address',
                            hintText: 'example.com or 1.2.3.4',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: portController,
                          decoration: const InputDecoration(labelText: 'Port'),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'e.g., root or ubuntu',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your SSH password',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          value: savePassword,
                          onChanged:
                              (val) =>
                                  setState(() => savePassword = val ?? false),
                          title: const Text('Save Password'),
                          subtitle: const Text(
                            'Insecure - only on trusted devices',
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            hostController.text.isEmpty ||
                            usernameController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          _showError(
                            'Please fill all required fields including password',
                          );
                          return;
                        }

                        final connection = SSHConnection(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text,
                          host: hostController.text,
                          port: int.tryParse(portController.text) ?? 22,
                          username: usernameController.text,
                          password: passwordController.text,
                          savePassword: savePassword,
                        );

                        _saveConnection(connection);
                        Navigator.pop(context);
                      },
                      child: const Text('Connect'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _deleteConnection(String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Connection'),
            content: const Text('Are you sure?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _savedConnections.removeWhere((c) => c.id == id);
                  });

                  final prefs = await SharedPreferences.getInstance();
                  final connectionsJson =
                      _savedConnections
                          .map((c) => jsonEncode(c.toJson()))
                          .toList();
                  await prefs.setStringList('ssh_connections', connectionsJson);

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _commandController.dispose();
    _sshService.disconnect();
    super.dispose();
  }
}
