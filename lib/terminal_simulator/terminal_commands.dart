// filepath: lib/terminal_simulator/terminal_commands.dart

class TerminalCommands {
  static String _cwd = '/home/user';
  static final List<String> _history = [];
  static final Map<String, String> _env = Map<String, String>.from(_defaultEnv);
  static final Map<String, String> _aliases = {
    'll': 'ls -l',
    'la': 'ls -la',
  };

  static const Map<String, String> _defaultEnv = {
    'USER': 'user',
    'HOME': '/home/user',
    'SHELL': '/bin/bash',
    'HOSTNAME': 'flash-learn',
    'PATH': '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin',
    'PWD': '/home/user',
    'LANG': 'en_US.UTF-8',
    'TERM': 'xterm-256color',
    'EDITOR': 'nano',
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
    'echo',
    'printf',
    'true',
    'false',
    'test',
    '[',
    'seq',
    'find',
    'tree',
    'cut',
    'tr',
    'rev',
    'tee',
    'diff',
    'file',
    'stat',
    'chmod',
    'chown',
    'du',
    'df',
    'free',
    'ps',
    'cal',
    'ping',
    'alias',
    'unalias',
    'type',
    'reset',
    'exit',
    'neofetch',
    'cowsay',
    'groups',
    'who',
    'less',
    'more',
    'nano',
    'vim',
    'sudo',
  };

  static Map<String, _Node> _fs = _seedFs();

  static Map<String, _Node> _seedFs() {
    return {
      '/': _Node.dir(),
      '/home': _Node.dir(),
      '/home/user': _Node.dir(),
      '/home/user/Desktop': _Node.dir(),
      '/home/user/Documents': _Node.dir(),
      '/home/user/Downloads': _Node.dir(),
      '/tmp': _Node.dir(),
      '/etc': _Node.dir(),
      '/var': _Node.dir(),
      '/var/log': _Node.dir(),
      '/usr': _Node.dir(),
      '/usr/bin': _Node.dir(),
      '/home/user/file1.txt': _Node.file('Hello from file1.txt\n'),
      '/home/user/file2.txt': _Node.file('Another sample file.\n'),
      '/home/user/Documents/notes.txt': _Node.file(
        'todo:\n- learn ls\n- learn cd\n- learn grep\n- learn pipes\n',
      ),
      '/home/user/Documents/names.txt': _Node.file(
        'zeta\nalpha\nalpha\nbeta\ngamma\n',
      ),
      '/etc/hostname': _Node.file('flash-learn\n'),
      '/etc/passwd': _Node.file(
        'root:x:0:0:root:/root:/bin/bash\n'
        'user:x:1000:1000:Learner:/home/user:/bin/bash\n',
      ),
      '/var/log/syslog': _Node.file(
        'Jan  1 00:00:01 flash-learn kernel: Boot complete\n'
        'Jan  1 00:00:02 flash-learn systemd: Started user session\n'
        'Jan  1 00:01:00 flash-learn app: Flash Learn simulator ready\n',
      ),
    };
  }

  static String get cwd => _cwd;

  static String get prompt {
    final home = _env['HOME'] ?? '/home/user';
    final short = _cwd == home
        ? '~'
        : (_cwd.startsWith('$home/') ? '~${_cwd.substring(home.length)}' : _cwd);
    return '${_env['USER']}@${_env['HOSTNAME']}:$short';
  }

  static List<String> get commandHistory => List<String>.unmodifiable(_history);

  static String get welcomeBanner => [
    'Flash Learn Terminal Simulator',
    'Practice Linux without touching a real machine.',
    '',
    '  help          list commands',
    '  man ls        command manual',
    '  ls -la        flags can be combined',
    '  cat a | grep x   pipes',
    '  echo hi > f   redirection',
    '',
    'Keys: Up/Down history, Tab complete',
  ].join('\n');

  static void resetSession() {
    _cwd = '/home/user';
    _history.clear();
    _env
      ..clear()
      ..addAll(_defaultEnv);
    _aliases
      ..clear()
      ..addAll({'ll': 'ls -l', 'la': 'ls -la'});
    _fs = _seedFs();
  }

  static List<String> complete(String input) {
    final raw = input;
    final focus = raw.endsWith(' ') ? '' : raw.split(RegExp(r'\s+')).last;
    final tokens = raw.trim().isEmpty ? <String>[] : _tokenize(raw.trim());
    final completingCommand =
        tokens.isEmpty || (tokens.length == 1 && !raw.endsWith(' '));

    if (completingCommand) {
      final names = {
        ..._availableCommands,
        ..._aliases.keys,
      }.where((c) => c.startsWith(focus)).toList()
        ..sort();
      return names;
    }

    final prefix = focus.contains('/')
        ? focus.substring(0, focus.lastIndexOf('/') + 1)
        : '';
    final namePart = focus.contains('/')
        ? focus.substring(focus.lastIndexOf('/') + 1)
        : focus;
    final dir = _resolve(prefix.isEmpty ? '.' : prefix);
    if (!_isDir(dir)) return const [];

    return _childrenOf(dir)
        .map(_basename)
        .where((name) => name.startsWith(namePart))
        .map((name) {
          final path = dir == '/' ? '/$name' : '$dir/$name';
          final suffix = _isDir(path) ? '/' : '';
          return '$prefix$name$suffix';
        })
        .toList()
      ..sort();
  }

  static void Function(Map<String, Object?> payload)? agentLog;

  static void _agentLog(
    String hypothesisId,
    String location,
    String message, [
    Map<String, Object?>? data,
  ]) {
    // #region agent log
    agentLog?.call({
      'sessionId': '6a4534',
      'hypothesisId': hypothesisId,
      'location': location,
      'message': message,
      'data': data ?? const <String, Object?>{},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'runId': 'pre-fix',
    });
    // #endregion
  }

  static String execute(String input) {
    // #region agent log
    _agentLog('B', 'terminal_commands.dart:execute', 'enter', {'input': input});
    // #endregion
    try {
      final trimmed = input.trim();
      if (trimmed.isEmpty) return '';

      var line = trimmed;
      if (line == '!!') {
        if (_history.isEmpty) return 'bash: !!: event not found';
        line = _history.last;
      }

      _history.add(line);
      if (line == 'clear') return 'clear';
      if (line == 'reset') {
        resetSession();
        return 'Session reset. Type help to begin.';
      }
      if (line == 'exit') return 'exit';

      final out = _executeLine(line);
      // #region agent log
      _agentLog('B', 'terminal_commands.dart:execute', 'ok', {
        'input': input,
        'outLen': out.length,
        'outHead': out.length > 120 ? out.substring(0, 120) : out,
      });
      // #endregion
      return out;
    } catch (e, st) {
      // #region agent log
      _agentLog('B', 'terminal_commands.dart:execute', 'throw', {
        'input': input,
        'error': e.toString(),
        'stack': st.toString(),
      });
      // #endregion
      rethrow;
    }
  }

  static String _executeLine(String line) {
    final parts = _splitByOperator(line, ';');
    final outputs = <String>[];

    for (final part in parts) {
      final result = _executeAndOr(part);
      if (result.output == 'clear' || result.output == 'exit') {
        return result.output;
      }
      if (result.output.isNotEmpty) outputs.add(result.output);
    }

    return outputs.join('\n');
  }

  static _ExecResult _executeAndOr(String line) {
    final chunks = _splitAndOr(line);
    if (chunks.isEmpty) return const _ExecResult('', true);

    var last = _executePipeline(chunks.first.command);
    for (var i = 1; i < chunks.length; i++) {
      final chunk = chunks[i];
      final run = chunk.op == '&&' ? last.success : !last.success;
      if (!run) continue;
      last = _executePipeline(chunk.command);
      if (last.output == 'clear' || last.output == 'exit') return last;
    }
    return last;
  }

  static _ExecResult _executePipeline(String pipeline) {
    final stages = _splitByOperator(pipeline, '|');
    _ExecResult last = const _ExecResult('', true);
    String? stdin;
    for (var i = 0; i < stages.length; i++) {
      last = _executeSingle(stages[i].trim(), stdin: stdin);
      if (last.output == 'clear' || last.output == 'exit') return last;
      stdin = last.output;
    }
    return last;
  }

  static _ExecResult _executeSingle(String input, {String? stdin}) {
    var argv = _tokenize(input);
    if (argv.isEmpty) return const _ExecResult('', true);

    argv = _expandLeadingAlias(argv);
    final parsed = _extractRedirections(argv);
    argv = parsed.argv;
    if (argv.isEmpty) return const _ExecResult('', true);

    var effectiveStdin = stdin;
    if (parsed.stdinPath != null) {
      final p = _resolve(parsed.stdinPath!);
      final n = _fs[p];
      if (n == null) return _err('bash: ${parsed.stdinPath}: No such file or directory');
      if (n.type != _NodeType.file) return _err('bash: ${parsed.stdinPath}: Is a directory');
      effectiveStdin = n.content;
    }

    final cmd = argv.first;
    final args = _expandArgs(argv.skip(1).toList(growable: false));
    final result = _dispatch(cmd, args, effectiveStdin);

    if (parsed.stdoutPath != null && result.success) {
      final err = _writeRedirect(
        parsed.stdoutPath!,
        result.output,
        append: parsed.append,
      );
      if (err != null) return _err(err);
      return const _ExecResult('', true);
    }

    return result;
  }

  static _ExecResult _dispatch(String cmd, List<String> args, String? stdin) {
    switch (cmd) {
      case 'help':
        return _ok(_help());
      case 'pwd':
        return _ok(_cwd);
      case 'whoami':
        return _ok(_env['USER'] ?? 'user');
      case 'id':
        return _ok('uid=1000(user) gid=1000(user) groups=1000(user),27(sudo)');
      case 'groups':
        return _ok('user sudo');
      case 'who':
        return _ok('user     tty1         ${DateTime.now().toLocal()}');
      case 'date':
        return _ok(DateTime.now().toLocal().toString());
      case 'echo':
        return _echo(args);
      case 'printf':
        return _printf(args);
      case 'true':
        return const _ExecResult('', true);
      case 'false':
        return const _ExecResult('', false);
      case 'test':
      case '[':
        return _test(args, cmd == '[');
      case 'history':
        return _historyCmd(args);
      case 'uname':
        return _ok(
          args.contains('-a')
              ? 'Linux ${_env['HOSTNAME']} 6.0.0-flashlearn x86_64 GNU/Linux'
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
      case 'type':
        return _type(args);
      case 'alias':
        return _alias(args);
      case 'unalias':
        return _unalias(args);
      case 'ls':
        return _wrap(_ls(args));
      case 'cd':
        return _wrap(_cd(args));
      case 'mkdir':
        return _wrap(_mkdir(args));
      case 'touch':
        return _wrap(_touch(args));
      case 'cat':
      case 'less':
      case 'more':
        return _wrap(_cat(args, stdin));
      case 'rm':
        return _wrap(_rm(args));
      case 'mv':
        return _wrap(_mv(args));
      case 'cp':
        return _wrap(_cp(args));
      case 'head':
        return _wrap(_head(args, stdin));
      case 'tail':
        return _wrap(_tail(args, stdin));
      case 'grep':
        return _wrap(_grep(args, stdin));
      case 'wc':
        return _wrap(_wc(args, stdin));
      case 'sort':
        return _wrap(_sort(args, stdin));
      case 'uniq':
        return _wrap(_uniq(args, stdin));
      case 'cut':
        return _wrap(_cut(args, stdin));
      case 'tr':
        return _wrap(_tr(args, stdin));
      case 'rev':
        return _wrap(_rev(args, stdin));
      case 'tee':
        return _wrap(_tee(args, stdin));
      case 'diff':
        return _wrap(_diff(args));
      case 'find':
        return _wrap(_find(args));
      case 'tree':
        return _wrap(_tree(args));
      case 'file':
        return _wrap(_fileCmd(args));
      case 'stat':
        return _wrap(_stat(args));
      case 'chmod':
        return _wrap(_chmod(args));
      case 'chown':
        return _wrap(_chown(args));
      case 'du':
        return _wrap(_du(args));
      case 'df':
        return _ok(
          'Filesystem     1K-blocks    Used Available Use% Mounted on\n'
          '/dev/sda1        4194304  524288   3669999  13% /',
        );
      case 'free':
        return _ok(
          '               total        used        free      shared  buff/cache   available\n'
          'Mem:         2048000      512000     1024000           0      512000     1408000\n'
          'Swap:              0           0           0',
        );
      case 'ps':
        return _ok(
          '  PID TTY          TIME CMD\n'
          '    1 ?        00:00:01 systemd\n'
          '   42 tty1     00:00:00 bash\n'
          '   99 tty1     00:00:00 ${_env['SHELL']}',
        );
      case 'cal':
        return _ok(_cal());
      case 'seq':
        return _wrap(_seq(args));
      case 'ping':
        return _ok(_ping(args));
      case 'neofetch':
        return _ok(_neofetch());
      case 'cowsay':
        return _ok(_cowsay(args.join(' ')));
      case 'basename':
        return _wrap(_basenameCmd(args));
      case 'dirname':
        return _wrap(_dirnameCmd(args));
      case 'man':
        return _wrap(_man(args));
      case 'nano':
      case 'vim':
        return _err(
          '$cmd: not a full editor in the simulator. Try: echo text > file.txt',
        );
      case 'sudo':
        return _err('sudo: this simulator already runs as user. Try the command without sudo.');
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
        out.contains(': Not a directory') ||
        out.contains('missing operand') ||
        out.contains('missing file') ||
        out.contains('cannot') ||
        out.contains('invalid') ||
        out.startsWith('Command not found') ||
        out.startsWith('bash:');
  }

  static String _help() {
    return [
      'Available commands:',
      '  Files:     ls cd pwd mkdir touch cat rm mv cp tree find',
      '  Text:      head tail grep wc sort uniq cut tr rev tee diff',
      '  Meta:      file stat chmod chown du basename dirname',
      '  System:    whoami id groups who date uname hostname uptime',
      '  Info:      env export which type alias df free ps cal ping',
      '  Extra:     echo printf seq test true false neofetch cowsay',
      '  Session:   history man clear reset help exit',
      '',
      'Operators:',
      '  |    pipe stdout into the next command',
      '  >    write stdout to a file    >> append',
      '  <    read stdin from a file',
      '  ;    run sequentially          && / || on success / failure',
      '',
      'Aliases: ll="ls -l"  la="ls -la"   History: !!',
      'Tip: man grep   echo \$USER   cat notes.txt | grep todo',
    ].join('\n');
  }

  static _ExecResult _echo(List<String> args) {
    final noNewline = args.isNotEmpty && args.first == '-n';
    final payload = noNewline ? args.skip(1).join(' ') : args.join(' ');
    return _ExecResult(noNewline ? payload : '$payload\n', true);
  }

  static _ExecResult _printf(List<String> args) {
    if (args.isEmpty) return _err('printf: missing operand');
    var format = args.first.replaceAll(r'\n', '\n').replaceAll(r'\t', '\t');
    final values = args.skip(1).toList();
    var i = 0;
    final out = format.replaceAllMapped(RegExp(r'%s|%d'), (m) {
      if (i >= values.length) return '';
      return values[i++];
    });
    return _ExecResult(out, true);
  }

  static _ExecResult _historyCmd(List<String> args) {
    if (args.contains('-c')) {
      _history.clear();
      return _ok('');
    }
    return _ok(
      _history.asMap().entries.map((e) => '${e.key + 1}  ${e.value}').join('\n'),
    );
  }

  static _ExecResult _export(List<String> args) {
    if (args.isEmpty) {
      return _ok(
        _env.entries.map((e) => 'declare -x ${e.key}="${e.value}"').join('\n'),
      );
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
      if (_aliases.containsKey(cmd) || _availableCommands.contains(cmd)) {
        out.add('/usr/bin/$cmd');
      } else {
        out.add('$cmd not found');
        hasMissing = true;
      }
    }
    return _ExecResult(out.join('\n'), !hasMissing);
  }

  static _ExecResult _type(List<String> args) {
    if (args.isEmpty) return _err('type: missing operand');
    final out = <String>[];
    for (final cmd in args) {
      if (_aliases.containsKey(cmd)) {
        out.add('$cmd is aliased to `${_aliases[cmd]}`');
      } else if (_availableCommands.contains(cmd)) {
        out.add('$cmd is /usr/bin/$cmd');
      } else {
        out.add('bash: type: $cmd: not found');
      }
    }
    return _ok(out.join('\n'));
  }

  static _ExecResult _alias(List<String> args) {
    if (args.isEmpty) {
      if (_aliases.isEmpty) return _ok('');
      return _ok(
        _aliases.entries.map((e) => "alias ${e.key}='${e.value}'").join('\n'),
      );
    }
    for (final arg in args) {
      final idx = arg.indexOf('=');
      if (idx <= 0) return _err('alias: `$arg`: invalid alias');
      _aliases[arg.substring(0, idx)] = arg.substring(idx + 1);
    }
    return _ok('');
  }

  static _ExecResult _unalias(List<String> args) {
    if (args.isEmpty) return _err('unalias: missing operand');
    for (final a in args) {
      _aliases.remove(a);
    }
    return _ok('');
  }

  static _ExecResult _test(List<String> args, bool bracket) {
    var a = List<String>.from(args);
    if (bracket) {
      if (a.isEmpty || a.last != ']') return _err('[: missing `]`');
      a = a.sublist(0, a.length - 1);
    }
    if (a.isEmpty) return const _ExecResult('', false);

    bool pass;
    if (a.length == 2 && a.first == '-z') {
      pass = a[1].isEmpty;
    } else if (a.length == 2 && a.first == '-n') {
      pass = a[1].isNotEmpty;
    } else if (a.length == 2 && a.first == '-f') {
      pass = _fs[_resolve(a[1])]?.type == _NodeType.file;
    } else if (a.length == 2 && a.first == '-d') {
      pass = _isDir(_resolve(a[1]));
    } else if (a.length == 2 && a.first == '-e') {
      pass = _fs.containsKey(_resolve(a[1]));
    } else if (a.length == 3 && (a[1] == '=' || a[1] == '==')) {
      pass = a[0] == a[2];
    } else if (a.length == 3 && a[1] == '!=') {
      pass = a[0] != a[2];
    } else if (a.length == 3 && a[1] == '-eq') {
      pass = int.tryParse(a[0]) == int.tryParse(a[2]);
    } else if (a.length == 3 && a[1] == '-gt') {
      pass = (int.tryParse(a[0]) ?? 0) > (int.tryParse(a[2]) ?? 0);
    } else if (a.length == 3 && a[1] == '-lt') {
      pass = (int.tryParse(a[0]) ?? 0) < (int.tryParse(a[2]) ?? 0);
    } else {
      pass = a.first.isNotEmpty;
    }
    return _ExecResult('', pass);
  }

  static String _ls(List<String> args) {
    final flags = _shortFlags(args);
    final showAll = flags.contains('a');
    final long = flags.contains('l');

    final pathArg = _positional(args);
    final target = _resolve(pathArg.isEmpty ? '.' : pathArg.first);

    final node = _fs[target];
    if (node == null) {
      return 'ls: cannot access $target: No such file or directory';
    }
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
    if (_positional(args).isEmpty) return 'mkdir: missing operand';
    final parents = _shortFlags(args).contains('p');
    final out = <String>[];
    for (final a in _positional(args)) {
      final p = _resolve(a);
      if (_fs.containsKey(p)) {
        if (!parents) out.add('mkdir: cannot create directory $p: File exists');
        continue;
      }
      if (parents) {
        _ensureDir(p);
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
    if (_positional(args).isEmpty) return 'touch: missing file operand';
    for (final a in _positional(args)) {
      final p = _resolve(a);
      final parent = _dirname(p);
      if (!_isDir(parent)) {
        return 'touch: cannot touch $p: No such file or directory';
      }
      _fs.putIfAbsent(p, () => _Node.file(''));
    }
    return '';
  }

  static String _cat(List<String> args, String? stdin) {
    final files = _positional(args);
    if (files.isEmpty) {
      if (stdin != null) return stdin;
      return 'cat: missing file operand';
    }
    final out = <String>[];
    for (final a in files) {
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
    if (_positional(args).isEmpty) return 'rm: missing operand';
    final flags = _shortFlags(args);
    final recursive = flags.contains('r') || flags.contains('R');
    final force = flags.contains('f');

    final out = <String>[];
    for (final t in _positional(args)) {
      final p = _resolve(t);
      final n = _fs[p];
      if (n == null) {
        if (!force) out.add('rm: cannot remove $p: No such file or directory');
        continue;
      }
      if (p == '/' || p == '/home' || p == '/home/user') {
        out.add('rm: refusing to remove $p');
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
    final positional = _positional(args);
    if (positional.length < 2) return 'mv: missing file operand';
    final src = _resolve(positional[0]);
    var dst = _resolve(positional[1]);

    final srcNode = _fs[src];
    if (srcNode == null) return 'mv: cannot stat $src: No such file or directory';
    if (_isDir(dst)) dst = '${dst == '/' ? '' : dst}/${_basename(src)}';

    final dstParent = _dirname(dst);
    if (!_isDir(dstParent)) {
      return 'mv: cannot move to $dst: No such file or directory';
    }

    if (srcNode.type == _NodeType.dir) {
      final mapping = <String, _Node>{};
      for (final p in _descendantsOf(src, includeSelf: true)) {
        final rel = p.substring(src.length);
        mapping['$dst$rel'] = _fs[p]!;
      }
      mapping.forEach((k, v) => _fs[k] = v);
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
    final recursive = _shortFlags(args).contains('r') || _shortFlags(args).contains('R');
    final filtered = _positional(args);
    if (filtered.length < 2) return 'cp: missing file operand';

    final src = _resolve(filtered[0]);
    var dst = _resolve(filtered[1]);

    final srcNode = _fs[src];
    if (srcNode == null) return 'cp: cannot stat $src: No such file or directory';
    if (_isDir(dst)) dst = '${dst == '/' ? '' : dst}/${_basename(src)}';

    final dstParent = _dirname(dst);
    if (!_isDir(dstParent)) {
      return 'cp: cannot copy to $dst: No such file or directory';
    }

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

  static String _head(List<String> args, String? stdin) {
    final n = _parseCountFlag(args, defaultValue: 10);
    final text = _readTextInput('head', args, stdin, skipAfterN: true);
    if (text.startsWith('head:')) return text;
    return text.split('\n').take(n).join('\n');
  }

  static String _tail(List<String> args, String? stdin) {
    final n = _parseCountFlag(args, defaultValue: 10);
    final text = _readTextInput('tail', args, stdin, skipAfterN: true);
    if (text.startsWith('tail:')) return text;
    final all = text.split('\n');
    final start = (all.length - n).clamp(0, all.length);
    return all.sublist(start).join('\n');
  }

  static String _grep(List<String> args, String? stdin) {
    final flags = _shortFlags(args);
    final ignoreCase = flags.contains('i');
    final invert = flags.contains('v');
    final countOnly = flags.contains('c');
    final filtered = _positional(args);
    if (filtered.isEmpty) return 'grep: missing pattern or file operand';

    final pattern = filtered[0];
    String text;
    String label = '';
    if (filtered.length >= 2) {
      final file = _resolve(filtered[1]);
      final node = _fs[file];
      if (node == null) return 'grep: $file: No such file or directory';
      if (node.type != _NodeType.file) return 'grep: $file: Is a directory';
      text = node.content;
      label = _basename(file);
    } else if (stdin != null) {
      text = stdin;
    } else {
      return 'grep: missing pattern or file operand';
    }

    final needle = ignoreCase ? pattern.toLowerCase() : pattern;
    final matches = <String>[];
    for (final line in text.split('\n')) {
      final hay = ignoreCase ? line.toLowerCase() : line;
      final hit = hay.contains(needle);
      if (invert ? !hit : hit) matches.add(line);
    }
    if (countOnly) return '${matches.length}${label.isEmpty ? '' : ' $label'}';
    return matches.join('\n');
  }

  static String _wc(List<String> args, String? stdin) {
    final flags = _shortFlags(args);
    final text = _readTextInput('wc', args, stdin);
    if (text.startsWith('wc:')) return text;

    final lines = '\n'.allMatches(text).length;
    final words = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    final bytes = text.length;
    final name = _positional(args).isEmpty ? '' : _basename(_resolve(_positional(args).first));
    if (flags.contains('l')) return '$lines $name'.trim();
    if (flags.contains('w')) return '$words $name'.trim();
    if (flags.contains('c')) return '$bytes $name'.trim();
    return '$lines $words $bytes $name'.trim();
  }

  static String _sort(List<String> args, String? stdin) {
    final reverse = _shortFlags(args).contains('r');
    final unique = _shortFlags(args).contains('u');
    final text = _readTextInput('sort', args, stdin);
    if (text.startsWith('sort:')) return text;
    var lines = text.split('\n')..sort();
    if (unique) lines = lines.toSet().toList()..sort();
    if (reverse) lines = lines.reversed.toList();
    return lines.join('\n');
  }

  static String _uniq(List<String> args, String? stdin) {
    final count = _shortFlags(args).contains('c');
    final text = _readTextInput('uniq', args, stdin);
    if (text.startsWith('uniq:')) return text;
    final lines = text.split('\n');
    final out = <String>[];
    String? prev;
    var n = 0;
    void flush() {
      if (prev == null) return;
      out.add(count ? '${n.toString().padLeft(4)} $prev' : prev);
    }

    for (final line in lines) {
      if (line == prev) {
        n++;
      } else {
        flush();
        prev = line;
        n = 1;
      }
    }
    flush();
    return out.join('\n');
  }

  static String _cut(List<String> args, String? stdin) {
    String delim = '\t';
    String? fields;
    for (var i = 0; i < args.length; i++) {
      if (args[i] == '-d' && i + 1 < args.length) delim = args[i + 1];
      if (args[i].startsWith('-d') && args[i].length > 2) {
        delim = args[i].substring(2);
      }
      if (args[i] == '-f' && i + 1 < args.length) fields = args[i + 1];
      if (args[i].startsWith('-f') && args[i].length > 2) {
        fields = args[i].substring(2);
      }
    }
    if (fields == null) return 'cut: you must specify a list of fields with -f';
    final indexes = fields
        .split(',')
        .map(int.tryParse)
        .whereType<int>()
        .map((n) => n - 1)
        .toList();
    final text = _readTextInput('cut', args, stdin, extraSkip: {'-d', '-f'});
    if (text.startsWith('cut:')) return text;
    return text.split('\n').map((line) {
      final parts = line.split(delim);
      return indexes
          .where((i) => i >= 0 && i < parts.length)
          .map((i) => parts[i])
          .join(delim);
    }).join('\n');
  }

  static String _tr(List<String> args, String? stdin) {
    final filtered = args.where((a) => !a.startsWith('-')).toList();
    if (filtered.length < 2) return 'tr: missing operand';
    if (stdin == null) return 'tr: missing stdin (try: echo hello | tr a-z A-Z)';
    final from = _expandRange(filtered[0]);
    final to = _expandRange(filtered[1]);
    final buf = StringBuffer();
    for (final rune in stdin.runes) {
      final ch = String.fromCharCode(rune);
      final idx = from.indexOf(ch);
      buf.write(idx >= 0 ? (idx < to.length ? to[idx] : to[to.length - 1]) : ch);
    }
    return buf.toString();
  }

  static String _rev(List<String> args, String? stdin) {
    final text = _readTextInput('rev', args, stdin);
    if (text.startsWith('rev:')) return text;
    return text.split('\n').map((l) => l.split('').reversed.join()).join('\n');
  }

  static String _tee(List<String> args, String? stdin) {
    if (stdin == null) return 'tee: missing stdin';
    final append = _shortFlags(args).contains('a');
    for (final a in _positional(args)) {
      final err = _writeRedirect(a, stdin, append: append);
      if (err != null) return err;
    }
    return stdin;
  }

  static String _diff(List<String> args) {
    final files = _positional(args);
    if (files.length < 2) return 'diff: missing file operand';
    final left = _readFile(files[0], 'diff');
    if (left.startsWith('diff:')) return left;
    final right = _readFile(files[1], 'diff');
    if (right.startsWith('diff:')) return right;
    if (left == right) return '';
    final a = left.split('\n');
    final b = right.split('\n');
    final out = <String>[];
    final max = a.length > b.length ? a.length : b.length;
    for (var i = 0; i < max; i++) {
      final la = i < a.length ? a[i] : '';
      final lb = i < b.length ? b[i] : '';
      if (la != lb) {
        if (la.isNotEmpty) out.add('< $la');
        if (lb.isNotEmpty) out.add('> $lb');
      }
    }
    return out.join('\n');
  }

  static String _find(List<String> args) {
    var start = _cwd;
    String? namePat;
    for (var i = 0; i < args.length; i++) {
      if (args[i] == '-name' && i + 1 < args.length) {
        namePat = args[i + 1];
        i++;
        continue;
      }
      if (!args[i].startsWith('-')) start = _resolve(args[i]);
    }
    if (!_fs.containsKey(start)) {
      return 'find: `$start`: No such file or directory';
    }
    final out = <String>[];
    final paths = [start, ..._descendantsOf(start)];
    for (final p in paths) {
      final name = _basename(p);
      if (namePat == null || _matchGlob(name, namePat)) out.add(p);
    }
    out.sort();
    return out.join('\n');
  }

  static String _tree(List<String> args) {
    final target = _resolve(_positional(args).isEmpty ? '.' : _positional(args).first);
    if (!_isDir(target)) return 'tree: $target: Not a directory';
    final lines = <String>[_basename(target) == '/' ? '/' : _basename(target)];
    void walk(String dir, String prefix) {
      final kids = _childrenOf(dir).toList()..sort();
      for (var i = 0; i < kids.length; i++) {
        final last = i == kids.length - 1;
        final p = kids[i];
        final branch = last ? '└── ' : '├── ';
        final name = _basename(p) + (_isDir(p) ? '/' : '');
        lines.add('$prefix$branch$name');
        if (_isDir(p)) walk(p, prefix + (last ? '    ' : '│   '));
      }
    }

    walk(target, '');
    return lines.join('\n');
  }

  static String _fileCmd(List<String> args) {
    if (_positional(args).isEmpty) return 'file: missing file operand';
    final out = <String>[];
    for (final a in _positional(args)) {
      final p = _resolve(a);
      final n = _fs[p];
      if (n == null) {
        out.add('$p: cannot open (No such file or directory)');
      } else if (n.type == _NodeType.dir) {
        out.add('$p: directory');
      } else if (n.content.contains('\n') || n.content.contains(':')) {
        out.add('$p: ASCII text');
      } else {
        out.add('$p: ASCII text, with no line terminators');
      }
    }
    return out.join('\n');
  }

  static String _stat(List<String> args) {
    if (_positional(args).isEmpty) return 'stat: missing operand';
    final p = _resolve(_positional(args).first);
    final n = _fs[p];
    if (n == null) return 'stat: cannot statx $p: No such file or directory';
    final kind = n.type == _NodeType.dir ? 'directory' : 'regular file';
    return [
      '  File: $p',
      '  Size: ${n.type == _NodeType.dir ? 4096 : n.content.length}',
      '  Type: $kind',
      'Access: (${n.mode}) Uid: (1000/user) Gid: (1000/user)',
    ].join('\n');
  }

  static String _chmod(List<String> args) {
    final positional = _positional(args);
    if (positional.length < 2) return 'chmod: missing operand';
    final mode = positional.first;
    if (!RegExp(r'^[0-7]{3}$').hasMatch(mode)) {
      return 'chmod: invalid mode: `$mode`';
    }
    for (final a in positional.skip(1)) {
      final p = _resolve(a);
      final n = _fs[p];
      if (n == null) return 'chmod: cannot access $p: No such file or directory';
      n.mode = mode;
    }
    return '';
  }

  static String _chown(List<String> args) {
    final positional = _positional(args);
    if (positional.length < 2) return 'chown: missing operand';
    for (final a in positional.skip(1)) {
      final p = _resolve(a);
      if (!_fs.containsKey(p)) {
        return 'chown: cannot access $p: No such file or directory';
      }
    }
    return '';
  }

  static String _du(List<String> args) {
    final target = _resolve(_positional(args).isEmpty ? '.' : _positional(args).first);
    if (!_fs.containsKey(target)) {
      return 'du: cannot access $target: No such file or directory';
    }
    var bytes = 0;
    if (_isDir(target)) {
      for (final p in _descendantsOf(target, includeSelf: true)) {
        final n = _fs[p];
        if (n?.type == _NodeType.file) bytes += n!.content.length;
      }
    } else {
      bytes = _fs[target]!.content.length;
    }
    final kb = (bytes / 1024).ceil().clamp(1, 1 << 30);
    return '$kb\t$target';
  }

  static String _seq(List<String> args) {
    if (args.isEmpty) return 'seq: missing operand';
    final nums = args.map(int.tryParse).toList();
    if (nums.any((n) => n == null)) return 'seq: invalid number';
    int start, step, end;
    if (nums.length == 1) {
      start = 1;
      step = 1;
      end = nums[0]!;
    } else if (nums.length == 2) {
      start = nums[0]!;
      step = 1;
      end = nums[1]!;
    } else {
      start = nums[0]!;
      step = nums[1]!;
      end = nums[2]!;
    }
    if (step == 0) return 'seq: invalid step';
    final out = <String>[];
    if (step > 0) {
      for (var i = start; i <= end; i += step) {
        out.add('$i');
      }
    } else {
      for (var i = start; i >= end; i += step) {
        out.add('$i');
      }
    }
    return out.join('\n');
  }

  static String _ping(List<String> args) {
    final host = _positional(args).isEmpty ? 'flash-learn' : _positional(args).first;
    var count = 4;
    final cIdx = args.indexOf('-c');
    if (cIdx != -1 && cIdx + 1 < args.length) {
      count = int.tryParse(args[cIdx + 1]) ?? 4;
    }
    count = count.clamp(1, 8);
    final lines = <String>['PING $host (127.0.0.1) 56(84) bytes of data.'];
    for (var i = 1; i <= count; i++) {
      lines.add('64 bytes from 127.0.0.1: icmp_seq=$i ttl=64 time=0.${i}ms');
    }
    lines.add(
      '\n--- $host ping statistics ---\n'
      '$count packets transmitted, $count received, 0% packet loss',
    );
    return lines.join('\n');
  }

  static String _cal() {
    final now = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final first = DateTime(now.year, now.month, 1);
    final days = DateTime(now.year, now.month + 1, 0).day;
    final header = '${months[now.month - 1]} ${now.year}'.padLeft(20);
    final lines = [header, 'Su Mo Tu We Th Fr Sa'];
    // DateTime.weekday: Mon=1 ... Sun=7. Convert so Sunday=0.
    final lead = first.weekday % 7;
    var row = lead > 0 ? '${List.filled(lead, '  ').join(' ')} ' : '';
    for (var d = 1; d <= days; d++) {
      row += d.toString().padLeft(2);
      final cell = (lead + d) % 7;
      if (cell == 0 || d == days) {
        lines.add(row.trimRight());
        row = '';
      } else {
        row += ' ';
      }
    }
    return lines.join('\n');
  }

  static String _neofetch() {
    return [
      '        .--.        ${_env['USER']}@${_env['HOSTNAME']}',
      '       |o_o |       -----------',
      '       |:_/ |       OS: Flash Learn Linux',
      '      //   \\ \\      Kernel: 6.0.0-flashlearn',
      '     (|     | )     Shell: ${_env['SHELL']}',
      "    /'\\_   _/`\\     Terminal: simulator",
      '    \\___)=(___/     CPU: Virtual Learner',
      '                    Memory: 512MiB / 2048MiB',
    ].join('\n');
  }

  static String _cowsay(String text) {
    final msg = text.isEmpty ? 'moo' : text;
    final w = msg.length;
    final top = ' ${'_' * (w + 2)}';
    final bot = ' ${'-' * (w + 2)}';
    return [
      top,
      '< $msg >',
      bot,
      '        \\   ^__^',
      '         \\  (oo)\\_______',
      '            (__)\\       )\\/\\',
      '                ||----w |',
      '                ||     ||',
    ].join('\n');
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
      'ls': 'ls - list directory contents\n\nTry:\n  ls\n  ls -a\n  ls -l\n  ls -la\n',
      'cd': 'cd - change current directory\n\nTry:\n  cd Documents\n  cd ..\n  cd ~\n',
      'grep':
          'grep - search for PATTERN\n\nTry:\n  grep todo Documents/notes.txt\n  grep -i LEARN Documents/notes.txt\n  cat notes.txt | grep learn\n',
      'wc': 'wc - print line, word, and byte counts\n\nTry:\n  wc notes.txt\n  wc -l notes.txt\n',
      'sort': 'sort - sort lines\n\nTry:\n  sort Documents/names.txt\n  sort -ru Documents/names.txt\n',
      'uniq': 'uniq - omit repeated lines\n\nTry:\n  sort names.txt | uniq\n  uniq -c names.txt\n',
      'export': 'export - set environment variables\n\nTry:\n  export EDITOR=vim\n  echo \$EDITOR\n',
      'which': 'which - locate a command\n\nTry:\n  which grep\n',
      'find': 'find - search the filesystem\n\nTry:\n  find ~ -name "*.txt"\n',
      'tree': 'tree - list contents recursively\n\nTry:\n  tree\n  tree Documents\n',
      'cut': 'cut - extract columns\n\nTry:\n  cut -d: -f1 /etc/passwd\n',
      'tr': 'tr - translate characters\n\nTry:\n  echo hello | tr a-z A-Z\n',
      'chmod': 'chmod - change file mode\n\nTry:\n  chmod 755 file1.txt\n  stat file1.txt\n',
      'test': 'test/[ - evaluate expressions\n\nTry:\n  test -f file1.txt && echo yes\n  [ -d Documents ] && echo dir\n',
      'alias': 'alias - define shortcuts\n\nTry:\n  alias\n  alias gs="echo git status"\n',
    };
    return pages[topic] ??
        'No detailed page for `$topic` yet. It is still available — try `$topic --help` style flags or run `help`.';
  }

  static String _readTextInput(
    String cmd,
    List<String> args,
    String? stdin, {
    bool skipAfterN = false,
    Set<String>? extraSkip,
  }) {
    final files = <String>[];
    for (var i = 0; i < args.length; i++) {
      final a = args[i];
      if (a.startsWith('-')) {
        if (skipAfterN && (a == '-n' || a == '-c') && i + 1 < args.length) i++;
        if (extraSkip != null && extraSkip.contains(a) && i + 1 < args.length) {
          i++;
        }
        continue;
      }
      if (skipAfterN && i > 0 && (args[i - 1] == '-n' || args[i - 1] == '-c')) {
        continue;
      }
      files.add(a);
    }
    if (files.isEmpty) {
      if (stdin != null) return stdin;
      return '$cmd: missing file operand';
    }
    return _readFile(files.first, cmd);
  }

  static String _readFile(String path, String cmd) {
    final p = _resolve(path);
    final n = _fs[p];
    if (n == null) return '$cmd: cannot open $p: No such file or directory';
    if (n.type != _NodeType.file) return '$cmd: error reading $p: Is a directory';
    return n.content;
  }

  static String? _writeRedirect(String path, String content, {required bool append}) {
    final p = _resolve(path);
    final parent = _dirname(p);
    if (!_isDir(parent)) return 'bash: $p: No such file or directory';
    final existing = _fs[p];
    if (existing != null && existing.type == _NodeType.dir) {
      return 'bash: $p: Is a directory';
    }
    if (append && existing != null) {
      existing.content = '${existing.content}$content';
      if (!existing.content.endsWith('\n') && content.isNotEmpty) {
        // keep as-is
      }
    } else {
      _fs[p] = _Node.file(content.endsWith('\n') || content.isEmpty ? content : '$content\n');
    }
    return null;
  }

  static void _ensureDir(String path) {
    if (path == '/') return;
    _ensureDir(_dirname(path));
    _fs.putIfAbsent(path, _Node.dir);
  }

  static int _parseCountFlag(List<String> args, {required int defaultValue}) {
    final nIdx = args.indexOf('-n');
    if (nIdx != -1 && nIdx + 1 < args.length) {
      return int.tryParse(args[nIdx + 1]) ?? defaultValue;
    }
    for (final a in args) {
      if (RegExp(r'^-\d+$').hasMatch(a)) return int.parse(a.substring(1));
    }
    return defaultValue;
  }

  static Set<String> _shortFlags(List<String> args) {
    final flags = <String>{};
    for (final a in args) {
      if (a == '--all') {
        flags.add('a');
        continue;
      }
      if (a == '--force') {
        flags.add('f');
        continue;
      }
      if (!a.startsWith('-') || a == '-' || a.startsWith('--')) continue;
      flags.addAll(a.substring(1).split(''));
    }
    return flags;
  }

  static List<String> _positional(List<String> args) {
    final out = <String>[];
    for (var i = 0; i < args.length; i++) {
      final a = args[i];
      if (a.startsWith('-') && a != '-') {
        if ((a == '-n' || a == '-c' || a == '-d' || a == '-f' || a == '-name') &&
            i + 1 < args.length) {
          i++;
        }
        continue;
      }
      out.add(a);
    }
    return out;
  }

  static String _expandRange(String spec) {
    final m = RegExp(r'^(.)-(.)$').firstMatch(spec);
    if (m == null) return spec;
    final start = m.group(1)!.codeUnitAt(0);
    final end = m.group(2)!.codeUnitAt(0);
    final buf = StringBuffer();
    final step = start <= end ? 1 : -1;
    for (var c = start; step > 0 ? c <= end : c >= end; c += step) {
      buf.writeCharCode(c);
    }
    return buf.toString();
  }

  static bool _matchGlob(String name, String pattern) {
    final regex = RegExp(
      '^${RegExp.escape(pattern).replaceAll('\\*', '.*').replaceAll('\\?', '.')}\$',
    );
    return regex.hasMatch(name);
  }

  static String _resolve(String path) {
    var p = path;
    final home = _env['HOME'] ?? '/home/user';
    if (p == '~') return home;
    if (p.startsWith('~/')) p = '$home/${p.substring(2)}';
    if (p.startsWith('/')) return _normalize(p);
    if (p == '.') return _cwd;
    if (p == '..') return _dirname(_cwd);
    return _normalize('$_cwd/$p');
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
    final perms = _modeToPerms(node.mode, isDir);
    final size = isDir ? 4096 : node.content.length;
    final name = _basename(path);
    return '$perms 1 user user ${size.toString().padLeft(5)} Jan  1 00:00 $name${isDir ? '/' : ''}';
  }

  static String _modeToPerms(String mode, bool isDir) {
    String trio(int n) {
      return '${n & 4 != 0 ? 'r' : '-'}${n & 2 != 0 ? 'w' : '-'}${n & 1 != 0 ? 'x' : '-'}';
    }

    final v = int.tryParse(mode) ?? (isDir ? 755 : 644);
    final o = (v ~/ 100) % 10;
    final g = (v ~/ 10) % 10;
    final t = v % 10;
    return '${isDir ? 'd' : '-'}${trio(o)}${trio(g)}${trio(t)}';
  }

  static List<_AndOrChunk> _splitAndOr(String input) {
    final chunks = <_AndOrChunk>[];
    final buf = StringBuffer();
    String? quote;
    String op = '';
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
      if (i + 1 < input.length) {
        final two = input.substring(i, i + 2);
        if (two == '&&' || two == '||') {
          chunks.add(_AndOrChunk(op, buf.toString().trim()));
          buf.clear();
          op = two;
          i++;
          continue;
        }
      }
      buf.write(c);
    }
    if (buf.isNotEmpty) chunks.add(_AndOrChunk(op, buf.toString().trim()));
    return chunks.where((c) => c.command.isNotEmpty).toList();
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
          : op == '|'
          ? c == '|' && (i + 1 >= input.length || input[i + 1] != '|')
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

  static List<String> _expandLeadingAlias(List<String> argv) {
    if (argv.isEmpty) return argv;
    final alias = _aliases[argv.first];
    if (alias == null) return argv;
    return [..._tokenize(alias), ...argv.skip(1)];
  }

  static List<String> _expandArgs(List<String> args) {
    return args.expand((arg) {
      var expanded = arg.replaceAllMapped(RegExp(r'\$([A-Za-z_][A-Za-z0-9_]*)'), (m) {
        return _env[m.group(1)!] ?? '';
      });
      expanded = expanded.replaceAllMapped(RegExp(r'\$\{([A-Za-z_][A-Za-z0-9_]*)\}'), (m) {
        return _env[m.group(1)!] ?? '';
      });
      if (expanded.contains('*') || expanded.contains('?')) {
        final matches = _glob(expanded);
        if (matches.isNotEmpty) return matches;
      }
      return [expanded];
    }).toList();
  }

  static List<String> _glob(String pattern) {
    final abs = pattern.startsWith('/') || pattern.startsWith('~');
    final resolvedPattern = abs ? _resolve(pattern.replaceAll('*', '__STAR__').replaceAll('?', '__Q__'))
        .replaceAll('__STAR__', '*')
        .replaceAll('__Q__', '?') : pattern;
    final dirPart = resolvedPattern.contains('/')
        ? resolvedPattern.substring(0, resolvedPattern.lastIndexOf('/'))
        : '.';
    final namePat = resolvedPattern.contains('/')
        ? resolvedPattern.substring(resolvedPattern.lastIndexOf('/') + 1)
        : resolvedPattern;
    final dir = _resolve(dirPart.isEmpty ? '/' : dirPart);
    return _childrenOf(dir)
        .map(_basename)
        .where((n) => _matchGlob(n, namePat))
        .map((n) => dir == '/' ? '/$n' : '$dir/$n')
        .toList()
      ..sort();
  }

  static _Redir _extractRedirections(List<String> argv) {
    final out = <String>[];
    String? stdoutPath;
    String? stdinPath;
    var append = false;
    for (var i = 0; i < argv.length; i++) {
      final t = argv[i];
      if (t == '>' || t == '>>') {
        if (i + 1 >= argv.length) break;
        stdoutPath = argv[++i];
        append = t == '>>';
        continue;
      }
      if (t == '<') {
        if (i + 1 >= argv.length) break;
        stdinPath = argv[++i];
        continue;
      }
      out.add(t);
    }
    return _Redir(out, stdoutPath: stdoutPath, stdinPath: stdinPath, append: append);
  }

  static List<String> _tokenize(String input) {
    final tokens = <String>[];
    final buf = StringBuffer();
    String? quote;

    void flush() {
      if (buf.isNotEmpty) {
        tokens.add(buf.toString());
        buf.clear();
      }
    }

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
        flush();
        continue;
      }

      if (c == '>' || c == '<' || c == '|') {
        if (c == '>' && i + 1 < input.length && input[i + 1] == '>') {
          flush();
          tokens.add('>>');
          i++;
          continue;
        }
        if (c == '|' && i + 1 < input.length && input[i + 1] == '|') {
          flush();
          tokens.add('||');
          i++;
          continue;
        }
        flush();
        tokens.add(c);
        continue;
      }

      buf.write(c);
    }

    flush();
    return tokens;
  }
}

class _AndOrChunk {
  const _AndOrChunk(this.op, this.command);
  final String op;
  final String command;
}

class _Redir {
  const _Redir(
    this.argv, {
    this.stdoutPath,
    this.stdinPath,
    this.append = false,
  });
  final List<String> argv;
  final String? stdoutPath;
  final String? stdinPath;
  final bool append;
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
      content = '',
      mode = '755';
  _Node.file(this.content, {this.mode = '644'}) : type = _NodeType.file;

  final _NodeType type;
  String content;
  String mode;

  _Node clone() =>
      type == _NodeType.dir ? _Node.dir() : _Node.file(content, mode: mode);
}
