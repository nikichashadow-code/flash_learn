import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../l10n/l10n.dart';

class LinuxHistoryPage extends StatelessWidget {
  const LinuxHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final events = [
      _LinuxHistoryEvent(
        year: "1983",
        title: "GNU Project Announced",
        details: '''
Richard Stallman launches the GNU Project, aiming to create a free Unix-like operating system. The GNU Project provided many essential tools and utilities, but the kernel (GNU Hurd) was not ready for widespread use.
''',
      ),
      _LinuxHistoryEvent(
        year: "1991",
        title: "Linux Kernel Created",
        details: '''
Linus Torvalds, a Finnish student, announces the Linux kernel on the comp.os.minix newsgroup. He invites collaboration and quickly attracts a global community of developers. The first version (0.01) is released in September 1991.
''',
      ),
      _LinuxHistoryEvent(
        year: "1992",
        title: "Linux Goes Open Source",
        details: '''
Linux is relicensed under the GNU General Public License (GPL), making it free and open source. This allows anyone to use, modify, and distribute Linux, accelerating its development and adoption.
''',
      ),
      _LinuxHistoryEvent(
        year: "1993",
        title: "First Distributions",
        details: '''
Distributions like Slackware and Debian are released, making Linux easier to install and use. These distributions bundle the Linux kernel with GNU tools and other software, providing a complete operating system.
''',
      ),
      _LinuxHistoryEvent(
        year: "1996",
        title: "Tux the Penguin",
        details: '''
Tux the Penguin is chosen as the official Linux mascot. Designed by Larry Ewing, Tux becomes a symbol of the Linux community's fun and friendly spirit.
''',
      ),
      _LinuxHistoryEvent(
        year: "2004",
        title: "Ubuntu Launches",
        details: '''
Ubuntu is released, focusing on user-friendliness and regular releases. It quickly becomes one of the most popular Linux distributions for desktops and servers.
''',
      ),
      _LinuxHistoryEvent(
        year: "2010s",
        title: "Linux Dominates Servers & Cloud",
        details: '''
Linux becomes the dominant operating system for servers, supercomputers, and cloud infrastructure. Android, based on the Linux kernel, becomes the world's most popular mobile OS.
''',
      ),
      _LinuxHistoryEvent(
        year: "Today",
        title: "Linux Everywhere",
        details: '''
Linux powers smartphones, smart TVs, cars, embedded devices, and the world's fastest supercomputers. The open-source community continues to drive innovation and collaboration.
''',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.linuxHistoryTitle),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white, // <-- Add this line
      ),
      backgroundColor: scheme.surface,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return _TimelineExpansionTile(
            event: event,
            isFirst: index == 0,
            isLast: index == events.length - 1,
          );
        },
      ),
    );
  }
}

class _LinuxHistoryEvent {
  final String year;
  final String title;
  final String details;
  _LinuxHistoryEvent({
    required this.year,
    required this.title,
    required this.details,
  });
}

class _TimelineExpansionTile extends StatefulWidget {
  final _LinuxHistoryEvent event;
  final bool isFirst;
  final bool isLast;
  const _TimelineExpansionTile({
    required this.event,
    required this.isFirst,
    required this.isLast,
  });

  @override
  State<_TimelineExpansionTile> createState() => _TimelineExpansionTileState();
}

class _TimelineExpansionTileState extends State<_TimelineExpansionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline
        Column(
          children: [
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  if (!widget.isFirst)
                    Container(height: 24, width: 2, color: scheme.primary.withAlpha((0.35 * 255).round())),
                  Container(
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: scheme.surface, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.primary.withAlpha((0.3 * 255).round()),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const FaIcon(
                      FontAwesomeIcons.linux,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  if (!widget.isLast)
                    Container(height: 64, width: 2, color: scheme.primary.withAlpha((0.35 * 255).round())),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // Event card with ExpansionTile
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: 32),
            elevation: _expanded ? 8 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: false,
                onExpansionChanged: (val) => setState(() => _expanded = val),
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                title: Row(
                  children: [
                    Text(
                      widget.event.year,
                      style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.event.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.expand_more, size: 28),
                ),
                children: [
                  Text(
                    widget.event.details,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
