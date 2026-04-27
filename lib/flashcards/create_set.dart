import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/l10n.dart';

class CreateSetPage extends StatefulWidget {
  const CreateSetPage({super.key});

  @override
  State<CreateSetPage> createState() => _CreateSetPageState();
}

class _CreateSetPageState extends State<CreateSetPage> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _saveSet() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final user = Supabase.instance.client.auth.currentUser;
    try {
      await Supabase.instance.client.from('flashcards').insert({
        'user_id': user?.id,
        'question': _questionController.text,
        'answer': _answerController.text,
      });
      if (mounted) {
        Navigator.pop(context, true); // Return to home and refresh
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.createNewSetTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: context.l10n.frontQuestion),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: context.l10n.backAnswer),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child:
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: _saveSet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF388E3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          context.l10n.saveSet,
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
