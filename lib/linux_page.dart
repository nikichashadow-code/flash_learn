import 'package:flutter/material.dart';

class LinuxPage extends StatefulWidget {
  const LinuxPage({super.key});

  @override
  State<LinuxPage> createState() => _LinuxPageState();
}

class _LinuxPageState extends State<LinuxPage> {
  final List<String> _categories = [
    'File Management',
    'Networking',
    'System Info',
    'Permissions',
    'Process',
    'Text Processing',
    'Other'
  ];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What is Linux?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Linux is a family of open-source Unix-like operating systems based on the Linux kernel. '
                'It is widely used for servers, desktops, and embedded systems. In programming, Linux is popular because it is free, customizable, and supports a wide range of programming languages and tools.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Learning', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Navigate to the first Linux lesson or quiz
                  },
                ),
              ),
              const SizedBox(height: 32),
              CommandOfTheDay(
                command: 'ls',
                description: 'List directory contents.',
                example: 'ls -la',
              ),
              const SizedBox(height: 24),
              const Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _categories.map((cat) {
                  final selected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = val ? cat : null;
                      });
                    },
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey[800],
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search commands...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (query) {
                  // TODO: Filter commands/tutorials based on query
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Interactive Tutorials',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.grey[900],
                child: ListTile(
                  title: const Text('Navigating Directories', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Learn to use cd, ls, and pwd', style: TextStyle(color: Colors.white70)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to tutorial page
                    },
                    child: const Text('Start'),
                  ),
                ),
              ),
              // Example command card (put in your filtered command list)
              Card(
                color: Colors.grey[900],
                child: ListTile(
                  title: Text('ls', style: TextStyle(color: Colors.white)),
                  subtitle: Text('List directory contents', style: TextStyle(color: Colors.white70)),
                  onTap: () {
                    // TODO: Navigate to CommandDetailsPage(command: 'ls')
                  },
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.terminal), label: 'Terminal'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 1, // Set this based on the current page
        onTap: (index) {
          // TODO: Handle navigation
        },
      ),
    );
  }
}

class CommandOfTheDay extends StatelessWidget {
  final String command;
  final String description;
  final String example;

  const CommandOfTheDay({
    super.key,
    required this.command,
    required this.description,
    required this.example,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Command of the Day',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              command,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Example: $example',
              style: const TextStyle(color: Colors.greenAccent),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Open terminal with this command pre-filled
              },
              child: const Text('Try in Terminal'),
            ),
          ],
        ),
      ),
    );
  }
}