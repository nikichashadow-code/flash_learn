// filepath: lib/terminal_simulator/terminal_input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/l10n.dart';
import 'terminal_commands.dart';

class TerminalInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final String prompt;

  const TerminalInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.prompt,
  });

  @override
  State<TerminalInput> createState() => _TerminalInputState();
}

class _TerminalInputState extends State<TerminalInput> {
  final FocusNode _focusNode = FocusNode();
  int _historyIndex = -1;
  String _draft = '';
  List<String> _suggestions = const [];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    // #region agent log
    TerminalCommands.agentLog?.call({
      'sessionId': '6a4534',
      'hypothesisId': 'C',
      'location': 'terminal_input.dart:_onKey',
      'message': 'key',
      'data': {
        'key': event.logicalKey.debugName,
        'hasParentFocus': _focusNode.hasFocus,
      },
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'runId': 'pre-fix',
    });
    // #endregion

    final history = TerminalCommands.commandHistory;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (history.isEmpty) return KeyEventResult.handled;
      if (_historyIndex == -1) {
        _draft = widget.controller.text;
        _historyIndex = history.length - 1;
      } else if (_historyIndex > 0) {
        _historyIndex--;
      }
      widget.controller.text = history[_historyIndex];
      widget.controller.selection = TextSelection.collapsed(
        offset: widget.controller.text.length,
      );
      _clearSuggestions();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_historyIndex == -1) return KeyEventResult.handled;
      if (_historyIndex < history.length - 1) {
        _historyIndex++;
        widget.controller.text = history[_historyIndex];
      } else {
        _historyIndex = -1;
        widget.controller.text = _draft;
      }
      widget.controller.selection = TextSelection.collapsed(
        offset: widget.controller.text.length,
      );
      _clearSuggestions();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.tab) {
      _complete();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _complete() {
    final text = widget.controller.text;
    final matches = TerminalCommands.complete(text);
    if (matches.isEmpty) return;
    if (matches.length == 1) {
      _applyCompletion(matches.first);
      setState(() => _suggestions = const []);
      return;
    }
    final prefix = _commonPrefix(matches);
    final token = text.endsWith(' ') ? '' : text.split(RegExp(r'\s+')).last;
    if (prefix.length > token.length) {
      _applyCompletion(prefix);
    }
    setState(() => _suggestions = matches.take(12).toList());
  }

  void _applyCompletion(String completion) {
    final text = widget.controller.text;
    final idx = text.lastIndexOf(RegExp(r'\s'));
    final prefix = idx == -1 ? '' : text.substring(0, idx + 1);
    widget.controller.text = '$prefix$completion';
    widget.controller.selection = TextSelection.collapsed(
      offset: widget.controller.text.length,
    );
  }

  String _commonPrefix(List<String> items) {
    var prefix = items.first;
    for (final item in items.skip(1)) {
      while (!item.startsWith(prefix)) {
        if (prefix.isEmpty) return '';
        prefix = prefix.substring(0, prefix.length - 1);
      }
    }
    return prefix;
  }

  void _clearSuggestions() {
    if (_suggestions.isNotEmpty) setState(() => _suggestions = const []);
  }

  void _submit(String value) {
    _historyIndex = -1;
    _draft = '';
    _clearSuggestions();
    widget.onSubmitted(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.prompt,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9D8B6F),
              fontFamily: 'Courier New',
            ),
          ),
          if (_suggestions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 2),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _suggestions
                    .map(
                      (s) => GestureDetector(
                        onTap: () {
                          _applyCompletion(s);
                          _clearSuggestions();
                          _focusNode.requestFocus();
                        },
                        child: Text(
                          s,
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontFamily: 'Courier New',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  '\$ ',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFD4AF37),
                    fontFamily: 'Courier New',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Focus(
                  focusNode: _focusNode,
                  onKeyEvent: _onKey,
                  child: TextField(
                    controller: widget.controller,
                    onSubmitted: _submit,
                    onChanged: (_) {
                      _historyIndex = -1;
                      _clearSuggestions();
                    },
                    cursorColor: const Color(0xFFD4AF37),
                    autocorrect: false,
                    enableSuggestions: false,
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
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 8.0,
                      ),
                      hintText: context.l10n.typeCommandHint,
                      hintStyle: const TextStyle(
                        color: Color(0xFF9D8B6F),
                        fontFamily: 'Courier New',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
