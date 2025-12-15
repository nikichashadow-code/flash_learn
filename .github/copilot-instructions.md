# Flash Learn - Copilot Instructions

## Project Overview
**Flash Learn** is a Flutter mobile learning application focused on Linux education. It's a multi-page educational app combining flashcards, terminal command references, and educational content with Supabase backend integration.

## Architecture

### Core Stack
- **Framework**: Flutter (Dart 3.7+)
- **Backend**: Supabase (PostgreSQL + Auth)
- **Key Packages**: `supabase_flutter`, `flutter_animate`, `font_awesome_flutter`, `url_launcher`, `shared_preferences`

### Data Flow & Service Architecture
```
SupabaseService (lib/services/supabase_service.dart)
  ├── fetchCommands() → List<Command>
  ├── fetchCategories() → List<Category>
  ├── fetchTopics(categoryId) → List<Topic>
  ├── fetchExamples(topicId) → List<Example>
  └── addOrUpdateCommand() → manages command_flags merging
```

**Key Pattern**: Service layer (`SupabaseService`) is the ONLY entry point for backend queries. Direct Supabase calls should not appear in UI widgets.

### Data Models
Located in `lib/models/`:
- **Command**: Terminal command with flags (merged on update, not replaced)
- **Category/Topic/Example**: Hierarchical educational content structure (id → categoryId → topicId)

### Navigation & Authentication
- **Entry point**: `main.dart` manages the three-stage flow:
  1. **Onboarding** (WelcomePage) → `shared_preferences` flag `onboarding_done`
  2. **Auth** (AuthPage) → Supabase session restoration
  3. **Home** (HomePage) → authenticated user dashboard

- **Routes** (defined in `_MyAppState.build()`):
  - `/home`: HomePage (dashboard with topic cards)
  - `/login`: AuthPage
  - `/terminal`: TerminalCommandsPage
  - `/linux_history`, `/linux_basics`, `/linux_distros`: Educational pages
  - `/linux`: LinuxPage (placeholder)

### Pages & Their Responsibilities
| File | Type | Role |
|------|------|------|
| `home.dart` | Stateless | Dashboard with topic navigation cards |
| `auth_page.dart` | Stateful | Login/signup with Supabase auth |
| `terminal_comands.dart` | Stateful | Displays Command list via FutureBuilder |
| `linux_page.dart` | Stateful | Contains CommandOfTheDay widget |
| `linux_history_page.dart` | Stateless | Timeline widget with hardcoded Linux history events |
| `Linux_Basics.dart` | Stateless | Educational content page |
| `distributions_and_ecosystem.dart` | Stateless | Distro/ecosystem content page |
| `welcome_page.dart` | Stateless | Onboarding carousel with _TopicIcon widgets |
| `flashcard_view.dart` | TBD | Intended for flashcard UI (check if complete) |
| `create_set.dart` | TBD | Intended for creating study sets |

## Development Conventions

### File Naming
- Dart files use `snake_case` (e.g., `terminal_comands.dart`) — note the spelling quirk "comands"
- UI pages are root-level in `lib/`; models and services are in subdirectories

### Auth State Management
- **Supabase Session**: Restored automatically on app launch in `main.dart` initState
- **User Navigation**: Use `onAuthStateChange.listen()` to trigger state updates
- **Logout**: Call `Supabase.instance.client.auth.signOut()` then navigate to `/login`

### Future & Async Patterns
- Use `FutureBuilder<List<T>>` for async data in UI (see `terminal_comands.dart`)
- Use `Future.microtask()` for post-frame initialization (see `main.dart`)
- All Supabase calls are async—cast results explicitly: `as List<dynamic>`

### Flags/Settings Pattern
- `addOrUpdateCommand()` **merges** flags instead of replacing them (preserves user additions)
- This pattern should be replicated if adding similar update methods

## Supabase Database Schema (Inferred)
```sql
commands (id, command, description, flags: JSONB)
categories (id, name, description)
topics (id, category_id, title, description)
examples (id, topic_id, name, description, link)
```

## Key Implementation Patterns

### Stateful Page with FutureBuilder
```dart
class TerminalCommandsPage extends StatefulWidget {
  late Future<List<Command>> commandsFuture;
  
  @override
  void initState() {
    commandsFuture = SupabaseService().fetchCommands();
  }
}
```

### Navigation with Named Routes
```dart
Navigator.of(context).pushNamed('/terminal');
Navigator.pushReplacementNamed(context, '/home'); // replaces stack
```

### Dismissing Keyboard
UI pages use `SingleChildScrollView` with `SafeArea` for responsive layout.

## Common Issues & Fixes

1. **Supabase Key Exposure**: Hardcoded in `main.dart` (expected for Flutter public keys, but keep in mind)
2. **Command Typo**: File is `terminal_comands.dart` (not "commands") — maintain this naming
3. **Missing Imports**: New pages must be imported in `main.dart` AND added to routes
4. **Category/Topic Hierarchy**: Always filter by parent ID when fetching nested data (see `fetchTopics(categoryId)`)

## Build & Run
```bash
flutter pub get
flutter run
```

Testing and CI/CD not yet configured—no tests exist in repo.

## Areas for Enhancement
- Implement `flashcard_view.dart` and `create_set.dart` with full functionality
- Add unit/widget tests (setup testing infrastructure)
- Consider state management library (Provider, Riverpod) if app grows beyond current scope
- Move hardcoded Supabase credentials to environment variables/secrets
