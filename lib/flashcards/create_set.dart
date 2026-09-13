import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/l10n.dart';

class CreateSetPage extends StatefulWidget {
  const CreateSetPage({super.key});

  @override
  State<CreateSetPage> createState() => _CreateSetPageState();
}

class _CreateSetPageState extends State<CreateSetPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _saveSet() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
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
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.createNewSetTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Text(
              context.l10n.createNewSetTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.createSetSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            TextFormField(
              controller: _questionController,
              maxLines: 3,
              validator:
                  (value) =>
                      value == null || value.trim().isEmpty
                          ? context.l10n.requiredField
                          : null,
              decoration: InputDecoration(
                labelText: context.l10n.frontQuestion,
                hintText: context.l10n.frontQuestionHint,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _answerController,
              maxLines: 5,
              validator:
                  (value) =>
                      value == null || value.trim().isEmpty
                          ? context.l10n.requiredField
                          : null,
              decoration: InputDecoration(
                labelText: context.l10n.backAnswer,
                hintText: context.l10n.backAnswerHint,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child:
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : FilledButton.icon(
                        onPressed: _saveSet,
                        icon: const Icon(Icons.save_outlined),
                        label: Text(context.l10n.saveSet),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
