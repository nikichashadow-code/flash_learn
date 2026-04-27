// filepath: lib/terminal_simulator/terminal_input.dart
import 'package:flutter/material.dart';
import '../l10n/l10n.dart';

class TerminalInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const TerminalInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              '\$ ',
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFFD4AF37),
                fontFamily: 'Courier New',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              cursorColor: const Color(0xFFD4AF37),
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFD4AF37),
                fontFamily: 'Courier New',
              ),
              minLines: 1,
              maxLines: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 8.0,
                ),
                hintText: context.l10n.typeCommandHint,
                hintStyle: const TextStyle(
                  color: Color(0xFF9D8B6F),
                  fontFamily: 'Courier New',
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
