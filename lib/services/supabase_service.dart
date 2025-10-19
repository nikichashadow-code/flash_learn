import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/command.dart';
import '../models/ecosystem.dart'; // <-- Add this import

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Command>> fetchCommands() async {
    final data =
        await supabase
                .from('commands')
                .select()
                .order('command', ascending: true)
            as List<dynamic>;
    return data.map((json) => Command.fromJson(json)).toList();
  }

  /// Adds a new command or updates flags if it already exists
  Future<void> addOrUpdateCommand(
    String name,
    String description,
    Map<String, String> newFlags,
  ) async {
    final existing =
        await supabase
            .from('commands')
            .select()
            .eq('command', name)
            .maybeSingle();

    if (existing != null) {
      // Merge old flags with new flags
      final oldFlags = Map<String, dynamic>.from(existing['flags'] ?? {});
      final mergedFlags = {...oldFlags, ...newFlags};

      // Update the row
      await supabase
          .from('commands')
          .update({'description': description, 'flags': mergedFlags})
          .eq('command', name);
    } else {
      // Insert if it doesn't exist
      await supabase.from('commands').insert({
        'command': name,
        'description': description,
        'flags': newFlags,
      });
    }
  }

  // --- New additions below ---

  Future<List<Category>> fetchCategories() async {
    final data = await supabase.from('categories').select() as List<dynamic>;
    return data.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Topic>> fetchTopics(int categoryId) async {
    final data =
        await supabase.from('topics').select().eq('category_id', categoryId)
            as List<dynamic>;
    return data.map((json) => Topic.fromJson(json)).toList();
  }

  Future<List<Example>> fetchExamples(int topicId) async {
    final data =
        await supabase.from('examples').select().eq('topic_id', topicId)
            as List<dynamic>;
    return data.map((json) => Example.fromJson(json)).toList();
  }
}
