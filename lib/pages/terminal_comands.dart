import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/command.dart';
import '../services/supabase_service.dart';
import '../l10n/l10n.dart';
import 'terminal_quiz_page.dart';

class TerminalCommandsPage extends StatefulWidget {
  const TerminalCommandsPage({super.key});

  @override
  State<TerminalCommandsPage> createState() => _TerminalCommandsPageState();
}

class _TerminalCommandsPageState extends State<TerminalCommandsPage> {
  final SupabaseService _service = SupabaseService();
  late Future<List<Command>> commandsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    commandsFuture = _service.fetchCommands();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: scheme.surface,
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: scheme.onSurface),
          actions: [
            IconButton(
              tooltip: 'Quiz',
              icon: Icon(Icons.quiz, color: scheme.onSurface),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TerminalQuizPage(),
                  ),
                );
              },
            ),
          ],
          title: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              right: 24.0,
            ), // Add right padding
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: scheme.onSurface),
              decoration: InputDecoration(
                hintText: context.l10n.searchCommandsHint,
                hintStyle: TextStyle(color: scheme.onSurfaceVariant),
                prefixIcon: Icon(Icons.search, color: scheme.onSurfaceVariant),
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Command>>(
        future: commandsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                context.l10n.errorWithDetails(snapshot.error.toString()),
              ),
            );
          }

          final commands = snapshot.data ?? [];

          // Filter commands by search query
          final filtered =
              _searchQuery.isEmpty
                  ? commands
                  : commands
                      .where(
                        (cmd) =>
                            cmd.command.toLowerCase().contains(_searchQuery) ||
                            cmd.description.toLowerCase().contains(
                              _searchQuery,
                            ) ||
                            cmd.flags.keys.any(
                              (k) => k.toLowerCase().contains(_searchQuery),
                            ) ||
                            cmd.flags.values.any(
                              (v) => v.toString().toLowerCase().contains(
                                _searchQuery,
                              ),
                            ),
                      )
                      .toList();

          if (filtered.isEmpty) {
            return Center(child: Text(context.l10n.noCommandsFound));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final cmd = filtered[index];
              return _buildCommandTile(cmd);
            },
          );
        },
      ),
    );
  }

  Widget _buildCommandTile(Command cmd) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.terminal, size: 20),
                const SizedBox(width: 8),
                Text(
                  cmd.command,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(cmd.description),
            if (cmd.flags.isNotEmpty) ...[
              const SizedBox(height: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    cmd.flags.entries
                        .map((e) => Text('• ${e.key} → ${e.value}'))
                        .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
