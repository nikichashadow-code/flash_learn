import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/supabase_service.dart';
import 'flashcard_view.dart';

class FlashcardLibraryPage extends StatefulWidget {
  const FlashcardLibraryPage({super.key});

  @override
  State<FlashcardLibraryPage> createState() => _FlashcardLibraryPageState();
}

class _FlashcardLibraryPageState extends State<FlashcardLibraryPage> {
  final SupabaseService _service = SupabaseService();
  late Future<List<Map<String, dynamic>>> _flashcardsFuture;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    _flashcardsFuture = _service.fetchFlashcards();
  }

  Future<void> _createFlashcard() async {
    await Navigator.of(context).pushNamed('/create_set');
    if (!mounted) return;
    setState(_loadFlashcards);
  }

  void _study(List<Map<String, dynamic>> cards) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => FlashcardViewPage(
              setTitle: context.l10n.flashcardsTitle,
              cards: cards,
            ),
      ),
    );
  }

  Future<void> _deleteFlashcard(Map<String, dynamic> card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(context.l10n.deleteAction),
            content: Text(card['question']?.toString() ?? ''),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(context.l10n.deleteAction),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await _service.deleteFlashcard(card['id']);
      if (!mounted) return;
      setState(_loadFlashcards);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errorWithDetails(error.toString())),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.flashcardsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createFlashcard,
        icon: const Icon(Icons.add),
        label: Text(context.l10n.createNewSetTitle),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _flashcardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.errorWithDetails(snapshot.error.toString()),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => setState(_loadFlashcards),
                      icon: const Icon(Icons.refresh),
                      label: Text(context.l10n.connectAction),
                    ),
                  ],
                ),
              ),
            );
          }

          final cards = snapshot.data ?? const <Map<String, dynamic>>[];
          if (cards.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.style_outlined, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.noFlashcards,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.createFirstFlashcard,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _createFlashcard,
                      icon: const Icon(Icons.add),
                      label: Text(context.l10n.createNewSetTitle),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => setState(_loadFlashcards),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.play_circle_outline),
                    title: Text(context.l10n.studyFlashcards),
                    subtitle: Text(
                      context.l10n.flashcardProgress(1, cards.length),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _study(cards),
                  ),
                ),
                const SizedBox(height: 8),
                ...cards.asMap().entries.map(
                  (entry) => Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${entry.key + 1}')),
                      title: Text(entry.value['question']?.toString() ?? ''),
                      subtitle: Text(entry.value['answer']?.toString() ?? ''),
                      trailing: IconButton(
                        tooltip: context.l10n.deleteAction,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteFlashcard(entry.value),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
