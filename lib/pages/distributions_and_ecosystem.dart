import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/supabase_service.dart';
import '../models/ecosystem.dart';
import '../l10n/l10n.dart';

class DistributionsAndEcosystemPage extends StatefulWidget {
  const DistributionsAndEcosystemPage({super.key});

  @override
  State<DistributionsAndEcosystemPage> createState() =>
      _DistributionsAndEcosystemPageState();
}

class _DistributionsAndEcosystemPageState
    extends State<DistributionsAndEcosystemPage> {
  final SupabaseService _service = SupabaseService();
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _service.fetchCategories();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.couldNotLaunchUrl(url))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.distrosEcosystemTitle)),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
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
          final categories = snapshot.data;
          if (categories == null || categories.isEmpty) {
            return Center(child: Text(context.l10n.noCategoriesFound));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: const Icon(Icons.category_outlined),
                  ),
                  title: Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(category.description ?? ''),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final topics = await _service.fetchTopics(category.id);
                    if (!mounted) return;
                    _showTopics(category.name, topics);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showTopics(String categoryName, List<Topic> topics) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder:
          (sheetContext) => _SheetList(
            title: categoryName,
            emptyText: sheetContext.l10n.noTopicsFound,
            children:
                topics
                    .map(
                      (topic) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        leading: const Icon(Icons.menu_book_outlined),
                        title: Text(topic.title),
                        subtitle: Text(topic.description ?? ''),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final examples = await _service.fetchExamples(
                            topic.id,
                          );
                          if (!mounted || !sheetContext.mounted) return;
                          Navigator.pop(sheetContext);
                          _showExamples(topic.title, examples);
                        },
                      ),
                    )
                    .toList(),
          ),
    );
  }

  void _showExamples(String topicTitle, List<Example> examples) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder:
          (sheetContext) => _SheetList(
            title: topicTitle,
            emptyText: sheetContext.l10n.noExamplesFound,
            children:
                examples
                    .map(
                      (example) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.lightbulb_outline),
                          title: Text(example.name),
                          subtitle: Text(example.description ?? ''),
                          trailing:
                              example.link != null
                                  ? IconButton(
                                    tooltip: sheetContext.l10n.settingsGithub,
                                    icon: const Icon(Icons.open_in_new),
                                    onPressed: () => _launchUrl(example.link!),
                                  )
                                  : null,
                        ),
                      ),
                    )
                    .toList(),
          ),
    );
  }
}

class _SheetList extends StatelessWidget {
  final String title;
  final String emptyText;
  final List<Widget> children;

  const _SheetList({
    required this.title,
    required this.emptyText,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child:
                children.isEmpty
                    ? Center(child: Text(emptyText))
                    : ListView(
                      padding: const EdgeInsets.only(bottom: 20),
                      children: children,
                    ),
          ),
        ],
      ),
    );
  }
}
