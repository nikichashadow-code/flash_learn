import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/supabase_service.dart';
import '../models/ecosystem.dart';

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distributions & Ecosystem'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final categories = snapshot.data;
          if (categories == null || categories.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(category.description ?? ''),
                  onTap: () async {
                    final topics = await _service.fetchTopics(category.id);
                    if (mounted) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ListView(
                          padding: const EdgeInsets.all(16),
                          children: topics.isEmpty
                              ? [const Text('No topics found.')]
                              : topics
                                  .map(
                                    (topic) => ListTile(
                                      title: Text(topic.title),
                                      subtitle: Text(
                                        topic.description ?? '',
                                      ),
                                      onTap: () async {
                                        final examples = await _service
                                            .fetchExamples(topic.id);
                                        if (mounted) {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => ListView(
                                              padding:
                                                  const EdgeInsets.all(16),
                                              children: examples.isEmpty
                                                  ? [
                                                    const Text(
                                                      'No examples found.',
                                                    ),
                                                  ]
                                                  : examples
                                                      .map(
                                                        (ex) => Card(
                                                          margin: const EdgeInsets
                                                              .symmetric(
                                                            vertical: 8,
                                                          ),
                                                          child: ListTile(
                                                            title: Text(
                                                              ex.name,
                                                            ),
                                                            subtitle: Text(
                                                              ex.description ??
                                                                  '',
                                                            ),
                                                            trailing:
                                                                ex.link != null
                                                                    ? IconButton(
                                                                      icon: const Icon(
                                                                        Icons.link,
                                                                      ),
                                                                      onPressed:
                                                                          () =>
                                                                              _launchUrl(
                                                                        ex.link!,
                                                                      ),
                                                                    )
                                                                    : null,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                  .toList(),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
