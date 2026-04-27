// filepath: lib/terminal_simulator/terminal_commands.dart

class TerminalCommands {
  static String _cwd = '/home/user';
  static final List<String> _history = [];
  static final Map<String, String> _env = {
    'USER': 'user',
    'HOME': '/home/user',
    'SHELL': '/bin/bash',
    'HOSTNAME': 'flash-learn',
    'PATH': '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin',
    'PWD': '/home/user',
    'LANG': 'en_US.UTF-8',
  };

  static final Set<String> _availableCommands = {
    'help',
    'clear',
    'history',
    'pwd',
    'cd',
    'ls',
    'mkdir',
    'touch',
    'cat',
    'rm',
    'mv',
    'cp',
    'head',
    'tail',
    'grep',
    'wc',
    'sort',
    'uniq',
    'basename',
    'dirname',
    'whoami',
    'id',
    'date',
    'uname',
    'hostname',
    'uptime',
    'env',
    'export',
    'which',
    'man',
  };

  // A tiny in-memory filesystem for the simulator.
  // Keys are absolute POSIX-like paths.
  static final Map<String, _Node> _fs = {
    '/': _Node.dir(),
    '/home': _Node.dir(),
    '/home/user': _Node.dir(),
    '/home/user/Desktop': _Node.dir(),
    '/home/user/Documents': _Node.dir(),
    '/home/user/Downloads': _Node.dir(),
    '/home/user/file1.txt': _Node.file('Hello from file1.txt\n'),
    '/home/user/file2.txt': _Node.file('Another sample file.\n'),
    '/home/user/Documents/notes.txt': _Node.file(
      'todo:\n- learn ls\n- learn cd\n- learn grep\n',
    ),
  };

  static String execute(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return '';

    _history.add(trimmed);
    if (trimmed == 'clear') return 'clear';

    return _executeLine(trimmed);
  }

  static String _executeLine(String line) {
    final parts = _splitByOperator(line, ';');
    final outputs = <String>[];

    for (final part in parts) {
      final andParts = _splitByOperator(part, '&&');
      var lastOk = true;
      for (final andPart in andParts) {
        if (!lastOk) continue;
        final result = _executeSingle(andPart.trim());
        if (result.output.isNotEmpty && result.output != 'clear') {
          outputs.add(result.output);
        }
        if (result.output == 'clear') return 'clear';
        lastOk = result.success;
      }
    }

    return outputs.join('\n');
  }

  static _ExecResult _executeSingle(String input) {
    final argv = _tokenize(input);
    if (argv.isEmpty) return const _ExecResult('', true);

    final cmd = argv.first;
    final args = _expandArgs(argv.skip(1).toList(growable: false));

    switch (cmd) {
      case 'help':
        return _ok(_help());
      case 'pwd':
        return _ok(_cwd);
      case 'whoami':
        return _ok(_env['USER'] ?? 'user');
      case 'id':
        return _ok('uid=1000(user) gid=1000(user) groups=1000(user),27(sudo)');
      case 'date':
        return _ok(DateTime.now().toLocal().toString());
      case 'echo':
        final noNewline = args.isNotEmpty && args.first == '-n';
        final payload = noNewline ? args.skip(1).join(' ') : args.join(' ');
        return _ok(payload + (noNewline ? '' : '\n'));
      case 'history':
        return _ok(
          _history
              .asMap()
              .entries
              .map((e) => '${e.key + 1}  ${e.value}')
              .join('\n'),
        );
      case 'uname':
        return _ok(
          args.contains('-a')
              ? 'Linux ${_env['HOSTNAME']} 6.0.0 x86_64 GNU/Linux'
              : 'Linux',
        );
      case 'hostname':
        return _ok(_env['HOSTNAME'] ?? 'flash-learn');
      case 'uptime':
        return _ok('up 1 day, 2:34, 1 user, load average: 0.08, 0.06, 0.05');
      case 'env':
        return _ok(_env.entries.map((e) => '${e.key}=${e.value}').join('\n'));
      case 'export':
        return _export(args);
      case 'which':
        return _which(args);
      case 'ls':
        return _wrap(_ls(args));
      case 'cd':
        return _wrap(_cd(args));
      case 'mkdir':
        return _wrap(_mkdir(args));
      case 'touch':
        return _wrap(_touch(args));
      case 'cat':
        return _wrap(_cat(args));
      case 'rm':
        return _wrap(_rm(args));
      case 'mv':
        return _wrap(_mv(args));
      case 'cp':
        return _wrap(_cp(args));
      case 'head':
        return _wrap(_head(args));
      case 'tail':
        return _wrap(_tail(args));
      case 'grep':
        return _wrap(_grep(args));
      case 'wc':
        return _wrap(_wc(args));
      case 'sort':
        return _wrap(_sort(args));
      case 'uniq':
        return _wrap(_uniq(args));
      case 'basename':
        return _wrap(_basenameCmd(args));
      case 'dirname':
        return _wrap(_dirnameCmd(args));
      case 'man':
        return _wrap(_man(args));
      default:
        return _err('Command not found: $cmd');
    }
  }

  static _ExecResult _ok(String out) => _ExecResult(out.trimRight(), true);
  static _ExecResult _err(String out) => _ExecResult(out, false);

  static _ExecResult _wrap(String out) {
    final isError = _looksLikeError(out);
    return _ExecResult(out.trimRight(), !isError);
  }

  static bool _looksLikeError(String out) {
    if (out.isEmpty) return false;
    return out.contains(': No such file or directory') ||
        out.contains(': Is a directory') ||
        out.contains('missing operand') ||
        out.contains('cannot') ||
        out.startsWith('Command not found');
  }

  static String _help() {
    return [
      'Available commands:',
      '  ls, cd, pwd, mkdir, touch, cat, rm, mv, cp',
      '  head, tail, grep, wc, sort, uniq',
      '  basename, dirname',
      '  whoami, id, date, uname, hostname, uptime',
      '  env, export, which',
      '  history, man, clear, help',
      '',
      'Operators:',
      '  ;   run commands sequentially',
      '  &&  run next command only if previous succeeded',
      '',
      'Tip: try `man ls`, `export EDITOR=vim`, or `which grep`',
    ].join('\n');
  }

  static _ExecResult _export(List<String> args) {
    if (args.isEmpty) {
      return _ok(_env.entries.map((e) => 'declare -x ${e.key}="${e.value}"').join('\n'));
    }

    final errors = <String>[];
    for (final arg in args) {
      final idx = arg.indexOf('=');
      if (idx <= 0) {
        errors.add('export: `$arg`: not a valid assignment');
        continue;
      }
      final key = arg.substring(0, idx).trim();
      final value = arg.substring(idx + 1);
      _env[key] = value;
    }

    if (errors.isNotEmpty) return _err(errors.join('\n'));
    return _ok('');
  }

  static _ExecResult _which(List<String> args) {
    if (args.isEmpty) return _err('which: missing command operand');
    final out = <String>[];
    var hasMissing = false;
    for (final cmd in args) {
      if (_availableCommands.contains(cmd)) {
        out.add('/usr/bin/$cmd');
      } else {
        out.add('$cmd not found');
        hasMissing = true;
      }
    }
    return _ExecResult(out.join('\n'), !hasMissing);
  }

  static String _ls(List<String> args) {
    final showAll = args.contains('-a') || args.contains('--all');
    final long = args.contains('-l');

    final pathArg = args.where((a) => !a.startsWith('-')).toList();
    final target = _resolve(pathArg.isEmpty ? '.' : pathArg.first);

    final node = _fs[target];
    if (node == null) return 'ls: cannot access $target: No such file or directory';
    if (node.type == _NodeType.file) {
      return long ? _formatLong(target, node) : _basename(target);
    }

    final children = _childrenOf(target)
        .where((p) => showAll || !_basename(p).startsWith('.'))
        .toList()
      ..sort();

    if (children.isEmpty) return '';

    if (!long) {
      return children.map((p) {
        final n = _fs[p]!;
        final name = _basename(p);
        return n.type == _NodeType.dir ? '$name/' : name;
      }).join('  ');
    }

    return children.map((p) => _formatLong(p, _fs[p]!)).join('\n');
  }

  static String _cd(List<String> args) {
    final targetArg = args.isEmpty ? (_env['HOME'] ?? '/home/user') : args.first;
    final target = _resolve(targetArg);

    final node = _fs[target];
    if (node == null) return 'cd: $target: No such file or directory';
    if (node.type != _NodeType.dir) return 'cd: $target: Not a directory';

    _cwd = target;
    _env['PWD'] = _cwd;
    return '';
  }

  static String _mkdir(List<String> args) {
    if (args.isEmpty) return 'mkdir: missing operand';
    final out = <String>[];
    for (final a in args) {
      if (a.startsWith('-')) continue;
      final p = _resolve(a);
      if (_fs.containsKey(p)) {
        out.add('mkdir: cannot create directory $p: File exists');
        continue;
      }
      final parent = _dirname(p);
      if (!_isDir(parent)) {
        out.add('mkdir: cannot create directory $p: No such file or directory');
        continue;
      }
      _fs[p] = _Node.dir();
    }
    return out.join('\n');
  }

  static String _touch(List<String> args) {
    if (args.isEmpty) return 'touch: missing file operand';
    for (final a in args) {
      if (a.startsWith('-')) continue;
      final p = _resolve(a);
      final parent = _dirname(p);
      if (!_isDir(parent)) return 'touch: cannot touch $p: No such file or directory';
      _fs.putIfAbsent(p, () => _Node.file(''));
    }
    return '';
  }

  static String _cat(List<String> args) {
    if (args.isEmpty) return 'cat: missing file operand';
    final out = <String>[];
    for (final a in args.where((v) => !v.startsWith('-'))) {
      final p = _resolve(a);
      final n = _fs[p];
      if (n == null) {
        out.add('cat: $p: No such file or directory');
      } else if (n.type != _NodeType.file) {
        out.add('cat: $p: Is a directory');
      } else {
        out.add(n.content);
      }
    }
    return out.join('');
  }

  static String _rm(List<String> args) {
    if (args.isEmpty) return 'rm: missing operand';
    final recursive = args.contains('-r') || args.contains('-R');
    final force = args.contains('-f') || args.contains('--force');

    final targets = args.where((a) => !a.startsWith('-')).toList();
    if (targets.isEmpty) return 'rm: missing operand';

    final out = <String>[];
    for (final t in targets) {
      final p = _resolve(t);
      final n = _fs[p];
      if (n == null) {
        if (!force) out.add('rm: cannot remove $p: No such file or directory');
        continue;
      }
      if (n.type == _NodeType.dir) {
        if (!recursive) {
          out.add('rm: cannot remove $p: Is a directory');
          continue;
        }
        for (final child in _descendantsOf(p)) {
          _fs.remove(child);
        }
      }
      _fs.remove(p);
    }
    return out.join('\n');
  }

  static String _mv(List<String> args) {
    if (args.length < 2) return 'mv: missing file operand';
    final src = _resolve(args[0]);
    final dst = _resolve(args[1]);

    final srcNode = _fs[src];
    if (srcNode == null) return 'mv: cannot stat $src: No such file or directory';

    final dstParent = _dirname(dst);
    if (!_isDir(dstParent)) return 'mv: cannot move to $dst: No such file or directory';

    if (srcNode.type == _NodeType.dir) {
      final mapping = <String, _Node>{};
      for (final p in _descendantsOf(src, includeSelf: true)) {
        final rel = p.substring(src.length);
        mapping['$dst$rel'] = _fs[p]!;
      }
      for (final p in mapping.keys) {
        _fs[p] = mapping[p]!;
      }
      for (final p in _descendantsOf(src, includeSelf: true)) {
        _fs.remove(p);
      }
    } else {
      _fs[dst] = srcNode;
      _fs.remove(src);
    }
    return '';
  }

  static String _cp(List<String> args) {
    if (args.length < 2) return 'cp: missing file operand';
    final recursive = args.contains('-r') || args.contains('-R');
    final filtered = args.where((a) => !a.startsWith('-')).toList();
    if (filtered.length < 2) return 'cp: missing file operand';

    final src = _resolve(filtered[0]);
    final dst = _resolve(filtered[1]);

    final srcNode = _fs[src];
    if (srcNode == null) return 'cp: cannot stat $src: No such file or directory';

    final dstParent = _dirname(dst);
    if (!_isDir(dstParent)) return 'cp: cannot copy to $dst: No such file or directory';

    if (srcNode.type == _NodeType.dir) {
      if (!recursive) return 'cp: -r not specified; omitting directory $src';
      for (final p in _descendantsOf(src, includeSelf: true)) {
        final rel = p.substring(src.length);
        _fs['$dst$rel'] = _fs[p]!.clone();
      }
      return '';
    }

    _fs[dst] = srcNode.clone();
    return '';
  }

  static String _head(List<String> args) {
    if (args.isEmpty) return 'head: missing file operand';
    var lines = 10;
    final nIdx = args.indexOf('-n');
    if (nIdx != -1 && nIdx + 1 < args.length) {
      lines = int.tryParse(args[nIdx + 1]) ?? lines;
    }
    final fileArg = args.where((a) => !a.startsWith('-')).last;
    final p = _resolve(fileArg);
    final n = _fs[p];
    if (n == null) return 'head: cannot open $p: No such file or directory';
    if (n.type != _NodeType.file) return 'head: error reading $p: Is a directory';
    return n.content.split('\n').take(lines).join('\n');
  }

  static String _tail(List<String> args) {
    if (args.isEmpty) return 'tail: missing file operand';
    var lines = 10;
    final nIdx = args.indexOf('-n');
    if (nIdx != -1 && nIdx + 1 < args.length) {
      lines = int.tryParse(args[nIdx + 1]) ?? lines;
    }
    final fileArg = args.where((a) => !a.startsWith('-')).last;
    final p = _resolve(fileArg);
    final n = _fs[p];
    if (n == null) return 'tail: cannot open $p: No such file or directory';
    if (n.type != _NodeType.file) return 'tail: error reading $p: Is a directory';
    final all = n.content.split('\n');
    final start = (all.length - lines).clamp(0, all.length);
    return all.sublist(start).join('\n');
  }

  static String _grep(List<String> args) {
    if (args.length < 2) return 'grep: missing pattern or file operand';
    final ignoreCase = args.contains('-i');
    final filtered = args.where((a) => !a.startsWith('-')).toList();
    if (filtered.length < 2) return 'grep: missing pattern or file operand';

    final pattern = filtered[0];
    final file = _resolve(filtered[1]);
    final n = _fs[file];
    if (n == null) return 'grep: $file: No such file or directory';
    if (n.type != _NodeType.file) return 'grep: $file: Is a directory';

    final needle = ignoreCase ? pattern.toLowerCase() : pattern;
    final out = <String>[];
    for (final line in n.content.split('\n')) {
      final hay = ignoreCase ? line.toLowerCase() : line;
      if (hay.contains(needle)) out.add(line);
    }
    return out.join('\n');
  }

  static String _wc(List<String> args) {
    if (args.isEmpty) return 'wc: missing file operand';
    final filtered = args.where((a) => !a.startsWith('-')).toList();
    if (filtered.isEmpty) return 'wc: missing file operand';
    final p = _resolve(filtered.first);
    final n = _fs[p];
    if (n == null) return 'wc: $p: No such file or directory';
    if (n.type != _NodeType.file) return 'wc: $p: Is a directory';

    final lines = '\n'.allMatches(n.content).length;
    final words =
        n.content.trim().isEmpty ? 0 : n.content.trim().split(RegExp(r'\s+')).length;
    final bytes = n.content.length;
    return '$lines $words $bytes ${_basename(p)}';
  }

  static String _sort(List<String> args) {
    if (args.isEmpty) return 'sort: missing file operand';
    final reverse = args.contains('-r');
    final filtered = args.where((a) => !a.startsWith('-')).toList();
    if (filtered.isEmpty) return 'sort: missing file operand';
    final p = _resolve(filtered.first);
    final n = _fs[p];
    if (n == null) return 'sort: cannot read: $p: No such file or directory';
    if (n.type != _NodeType.file) return 'sort: $p: Is a directory';

    final lines = n.content.split('\n')..sort();
    if (reverse) {
      return lines.reversed.join('\n');
    }
    return lines.join('\n');
  }

  static String _uniq(List<String> args) {
    if (args.isEmpty) return 'uniq: missing file operand';
    final filtered = args.where((a) => !a.startsWith('-')).toList();
    if (filtered.isEmpty) return 'uniq: missing file operand';
    final p = _resolve(filtered.first);
    final n = _fs[p];
    if (n == null) return 'uniq: $p: No such file or directory';
    if (n.type != _NodeType.file) return 'uniq: $p: Is a directory';

    final lines = n.content.split('\n');
    final out = <String>[];
    String? prev;
    for (final line in lines) {
      if (line != prev) out.add(line);
      prev = line;
    }
    return out.join('\n');
  }

  static String _basenameCmd(List<String> args) {
    if (args.isEmpty) return 'basename: missing operand';
    return _basename(_resolve(args.first));
  }

  static String _dirnameCmd(List<String> args) {
    if (args.isEmpty) return 'dirname: missing operand';
    return _dirname(_resolve(args.first));
  }

  static String _man(List<String> args) {
    if (args.isEmpty) return 'What manual page do you want?';
    final topic = args.first;
    final pages = <String, String>{
      'ls': 'ls - list directory contents\n\nTry:\n  ls\n  ls -a\n  ls -l\n',
      'cd': 'cd - change current directory\n\nTry:\n  cd Documents\n  cd ..\n  cd /\n',
      'grep': 'grep - search for PATTERN in a file\n\nTry:\n  grep todo notes.txt\n',
      'wc': 'wc - print line, word, and byte counts\n\nTry:\n  wc notes.txt\n',
      'sort': 'sort - sort lines of text files\n\nTry:\n  sort notes.txt\n  sort -r notes.txt\n',
      'uniq': 'uniq - report or omit repeated lines\n\nTry:\n  uniq notes.txt\n',
      'export': 'export - set environment variables\n\nTry:\n  export EDITOR=vim\n',
      'which': 'which - locate a command\n\nTry:\n  which grep\n',
    };
    return pages[topic] ?? 'No manual entry for $topic';
  }

  static String _resolve(String path) {
    if (path == '~') return _env['HOME'] ?? '/home/user';
    if (path.startsWith('/')) return _normalize(path);
    if (path == '.') return _cwd;
    if (path == '..') return _dirname(_cwd);
    return _normalize('$_cwd/$path');
  }

  static String _normalize(String path) {
    final parts = path.split('/');
    final out = <String>[];
    for (final p in parts) {
      if (p.isEmpty || p == '.') continue;
      if (p == '..') {
        if (out.isNotEmpty) out.removeLast();
        continue;
      }
      out.add(p);
    }
    return '/${out.join('/')}';
  }

  static String _basename(String path) {
    if (path == '/') return '/';
    final idx = path.lastIndexOf('/');
    return idx == -1 ? path : path.substring(idx + 1);
  }

  static String _dirname(String path) {
    if (path == '/') return '/';
    final idx = path.lastIndexOf('/');
    if (idx <= 0) return '/';
    return path.substring(0, idx);
  }

  static bool _isDir(String path) => _fs[path]?.type == _NodeType.dir;

  static Iterable<String> _childrenOf(String dir) sync* {
    final prefix = dir == '/' ? '/' : '$dir/';
    for (final p in _fs.keys) {
      if (!p.startsWith(prefix) || p == dir) continue;
      final rest = p.substring(prefix.length);
      if (!rest.contains('/')) yield p;
    }
  }

  static Iterable<String> _descendantsOf(
    String dir, {
    bool includeSelf = false,
  }) sync* {
    if (includeSelf) yield dir;
    final prefix = dir == '/' ? '/' : '$dir/';
    final all = _fs.keys.where((p) => p.startsWith(prefix) && p != dir).toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final p in all) {
      yield p;
    }
  }

  static String _formatLong(String path, _Node node) {
    final isDir = node.type == _NodeType.dir;
    final perms = isDir ? 'drwxr-xr-x' : '-rw-r--r--';
    final size = isDir ? 4096 : node.content.length;
    final name = _basename(path);
    return '$perms 1 user user ${size.toString().padLeft(5)} Jan  1 00:00 $name${isDir ? '/' : ''}';
  }

  static List<String> _splitByOperator(String input, String op) {
    final parts = <String>[];
    final buf = StringBuffer();
    String? quote;
    for (var i = 0; i < input.length; i++) {
      final c = input[i];
      if (quote != null) {
        if (c == quote) quote = null;
        buf.write(c);
        continue;
      }
      if (c == '"' || c == "'") {
        quote = c;
        buf.write(c);
        continue;
      }

      final canSplit = op == '&&'
          ? i + 1 < input.length && input.substring(i, i + 2) == '&&'
          : c == ';';
      if (canSplit) {
        parts.add(buf.toString().trim());
        buf.clear();
        if (op == '&&') i++;
        continue;
      }
      buf.write(c);
    }
    if (buf.isNotEmpty) parts.add(buf.toString().trim());
    return parts.where((p) => p.isNotEmpty).toList();
  }

  static List<String> _expandArgs(List<String> args) {
    return args.map((arg) {
      return arg.replaceAllMapped(RegExp(r'\$([A-Za-z_][A-Za-z0-9_]*)'), (m) {
        final key = m.group(1)!;
        return _env[key] ?? '';
      });
    }).toList();
  }

  static List<String> _tokenize(String input) {
    final tokens = <String>[];
    final buf = StringBuffer();
    String? quote;
    for (var i = 0; i < input.length; i++) {
      final c = input[i];
      if (quote != null) {
        if (c == quote) {
          quote = null;
        } else {
          buf.write(c);
        }
        continue;
      }

      if (c == '"' || c == "'") {
        quote = c;
        continue;
      }

      if (c.trim().isEmpty) {
        if (buf.isNotEmpty) {
          tokens.add(buf.toString());
          buf.clear();
        }
        continue;
      }

      buf.write(c);
    }

    if (buf.isNotEmpty) tokens.add(buf.toString());
    return tokens;
  }
}

class _ExecResult {
  const _ExecResult(this.output, this.success);
  final String output;
  final bool success;
}

enum _NodeType { dir, file }

class _Node {
  _Node.dir()
    : type = _NodeType.dir,
      content = '';
  _Node.file(this.content) : type = _NodeType.file;

  final _NodeType type;
  final String content;

  _Node clone() => type == _NodeType.dir ? _Node.dir() : _Node.file(content);
}
