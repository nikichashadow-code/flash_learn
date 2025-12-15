import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LinuxBasicsPage extends StatelessWidget {
  const LinuxBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      _Section(
        icon: FontAwesomeIcons.linux,
        title: "What is Linux?",
        content: '''
Linux is a family of open-source Unix-like operating systems based on the Linux kernel. It's widely used for servers, desktops, and embedded systems due to its stability, flexibility, and security.
''',
      ),
      _Section(
        icon: Icons.folder_open,
        title: "File System Structure",
        content: '''
Linux uses a hierarchical file system starting at the root /. Common directories:
- /home – User files
- /etc – Configuration files
- /bin – Essential binaries
- /usr – User programs
- /var – Variable data (logs, etc.)
''',
      ),
      _Section(
        icon: Icons.navigation,
        title: "How to Navigate",
        content: '''
- pwd – Show current directory
- ls – List files
- cd <dir> – Change directory
- cd ~ – Go to home
- cd .. – Go up one level
''',
      ),
      _Section(
        icon: Icons.memory,
        title: "Linux Architecture",
        content: '''
- Kernel: Core of the OS, manages hardware
- System Libraries: Provide functions for programs
- Shell: Command-line interface (e.g., bash)
- User Space: Applications and user processes
''',
      ),
      _Section(
        icon: Icons.security,
        title: "Users & Permissions",
        content: '''
- Users: root (admin), normal users
- Permissions: read (r), write (w), execute (x)
- ls -l – Show permissions
- `chmod, chown, chgrp – Change permissions/ownership
  - Example: chmod +x script.sh
''',
      ),
      _Section(
        icon: Icons.settings,
        title: "Processes & Services",
        content: '''
- Processes: Running programs (each has a PID)
- Background Services: Daemons (systemctl)
- Useful commands:
  - ps, top – List processes
  - kill <PID> – Stop process
  - systemctl status <service> – Service status
''',
      ),
      _Section(
        icon: Icons.download,
        title: "Package Management",
        content: '''
- Debian/Ubuntu: apt update, apt install <pkg>
- Arch: pacman -Syu, pacman -S <pkg>
- Void: xbps-install -S, xbps-install <pkg>
- Tip: Always update package lists first!
''',
      ),
      _Section(
        icon: Icons.network_check,
        title: "Networking Basics",
        content: '''
- **IP Address, Hostname, Ports**
- Useful commands:
  - ping <host>
  - ifconfig / ip a – Show interfaces
  - ssh user@host – Remote login
  - netstat / ss – Network connections
''',
      ),
      _Section(
        icon: Icons.work,
        title: "Basic Workflow",
        content: '''
- Create file: touch file.txt
- Edit: nano file.txt` or vim file.txt
- Move: mv file1 file2
- Copy: cp file1 file2
- Delete: rm file.txt
- View logs: cat /var/log/syslog
- Config files: Usually in /etc
''',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Linux OS Basics'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (context, i) => _SectionCard(section: sections[i]),
      ),
    );
  }
}

class _Section {
  final IconData icon;
  final String title;
  final String content;
  const _Section({required this.icon, required this.title, required this.content});
}

class _SectionCard extends StatelessWidget {
  final _Section section;
  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(section.icon, color: Colors.green, size: 28),
                const SizedBox(width: 12),
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              section.content.trim(),
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
