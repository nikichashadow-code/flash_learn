import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OllamaConfiguration {
  const OllamaConfiguration({
    required this.baseUrl,
    required this.model,
    this.thinkingLevel,
  });

  static const _preferenceKey = 'ollama_configuration';
  static const defaultBaseUrl = 'http://localhost:11434';
  static const defaultModel = 'qwen3:4b';

  final String baseUrl;
  final String model;
  final String? thinkingLevel;

  static Future<OllamaConfiguration> load() async {
    final preferences = await SharedPreferences.getInstance();
    final savedValue = preferences.getString(_preferenceKey);
    if (savedValue != null) {
      final savedConfiguration = jsonDecode(savedValue);
      if (savedConfiguration is! Map<String, dynamic> ||
          savedConfiguration['baseUrl'] is! String ||
          savedConfiguration['model'] is! String ||
          (savedConfiguration['thinkingLevel'] != null &&
              (savedConfiguration['thinkingLevel'] is! String ||
                  (savedConfiguration['thinkingLevel'] as String)
                      .trim()
                      .isEmpty))) {
        throw const FormatException('Invalid saved Ollama configuration.');
      }
      return OllamaConfiguration(
        baseUrl: savedConfiguration['baseUrl'] as String,
        model: savedConfiguration['model'] as String,
        thinkingLevel: savedConfiguration['thinkingLevel'] as String?,
      );
    }

    final envBaseUrl = dotenv.env['OLLAMA_BASE_URL']?.trim();
    final envModel = dotenv.env['OLLAMA_MODEL']?.trim();

    return OllamaConfiguration(
      baseUrl:
          envBaseUrl == null || envBaseUrl.isEmpty
              ? defaultBaseUrl
              : envBaseUrl,
      model: envModel == null || envModel.isEmpty ? defaultModel : envModel,
    );
  }

  static Uri? parseBaseUrl(String value) {
    final trimmedValue = value.trim().replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.tryParse(trimmedValue);
    if (uri == null ||
        !const {'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.hasPort && (uri.port < 1 || uri.port > 65535))) {
      return null;
    }
    return uri;
  }

  static Future<void> save({
    required String baseUrl,
    required String model,
    required String? thinkingLevel,
  }) async {
    if (thinkingLevel != null && thinkingLevel.trim().isEmpty) {
      throw ArgumentError.value(thinkingLevel, 'thinkingLevel');
    }
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _preferenceKey,
      jsonEncode({
        'baseUrl': baseUrl.trim().replaceFirst(RegExp(r'/+$'), ''),
        'model': model.trim(),
        'thinkingLevel': thinkingLevel,
      }),
    );
    if (!saved) {
      throw Exception('Could not persist Ollama configuration.');
    }
  }

  static Future<void> reset() async {
    final preferences = await SharedPreferences.getInstance();
    final removed = await preferences.remove(_preferenceKey);
    if (!removed) {
      throw Exception('Could not reset Ollama configuration.');
    }
  }
}

class TutorException implements Exception {
  final int status;
  final String message;

  const TutorException(this.status, this.message);
}

class OllamaThinkingInfo {
  const OllamaThinkingInfo({required this.values});

  final List<String> values;

  bool get supportsThinking => values.any((value) => value != 'false');
}

class OllamaService {
  Future<OllamaThinkingInfo?> fetchThinkingInfo({
    required String baseUrl,
    required String model,
  }) async {
    final normalizedBaseUrl = baseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.parse('$normalizedBaseUrl/api/show');

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'model': model.trim()}),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw _mapHttpError(response.statusCode, response.body);
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const TutorException(
          503,
          'Ollama returned invalid model details.',
        );
      }

      final thinking = decoded['thinking'];
      final values = <String>[];
      if (thinking is Map<String, dynamic> && thinking['values'] is List) {
        for (final value in thinking['values'] as List) {
          if (value is bool) {
            final normalizedValue = value.toString();
            if (!values.contains(normalizedValue)) values.add(normalizedValue);
          } else if (value is String &&
              value.isNotEmpty &&
              !values.contains(value)) {
            values.add(value);
          }
        }
        return OllamaThinkingInfo(values: values);
      }

      if (thinking is Map<String, dynamic>) {
        return const OllamaThinkingInfo(values: []);
      }
      return null;
    } on TutorException {
      rethrow;
    } on FormatException {
      throw const TutorException(503, 'Ollama returned invalid model details.');
    } on Exception {
      throw TutorException(
        503,
        'Could not check model support at $normalizedBaseUrl. Check that the server is running and reachable from this device.',
      );
    }
  }

  Future<List<String>> fetchInstalledModels(String baseUrl) async {
    final normalizedBaseUrl = baseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.parse('$normalizedBaseUrl/api/tags');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw _mapHttpError(response.statusCode, response.body);
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic> || decoded['models'] is! List) {
        throw const TutorException(
          503,
          'Ollama returned an invalid model list.',
        );
      }

      final models = <String>[];
      for (final model in decoded['models'] as List) {
        if (model is Map<String, dynamic> &&
            model['name'] is String &&
            (model['name'] as String).trim().isNotEmpty) {
          models.add((model['name'] as String).trim());
        }
      }
      models.sort();
      return models;
    } on TutorException {
      rethrow;
    } on FormatException {
      throw const TutorException(503, 'Ollama returned an invalid model list.');
    } on Exception {
      throw TutorException(
        503,
        'Could not fetch models from Ollama at $normalizedBaseUrl. Check that the server is running and reachable from this device.',
      );
    }
  }

  Future<String> ask(
    String question, {
    String? model,
    String? thinkingLevel,
  }) async {
    final trimmedQuestion = question.trim();
    if (trimmedQuestion.isEmpty) {
      throw const TutorException(400, 'Please enter a valid question.');
    }

    final configuration = await OllamaConfiguration.load();
    final baseUrl = configuration.baseUrl.replaceFirst(RegExp(r'/+$'), '');
    final selectedModel = model ?? configuration.model;
    final uri = Uri.parse('$baseUrl/api/chat');
    final body = {
      'model': selectedModel,
      'stream': false,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a Linux tutor. Explain clearly, accurately, and with practical examples. Keep the answer concise but helpful.',
        },
        {'role': 'user', 'content': trimmedQuestion},
      ],
      'options': {'temperature': 0.3, 'top_p': 0.9},
    };
    final selectedThinkingLevel = thinkingLevel ?? configuration.thinkingLevel;
    if (selectedThinkingLevel != null) {
      body['think'] =
          selectedThinkingLevel == 'true'
              ? true
              : selectedThinkingLevel == 'false'
              ? false
              : selectedThinkingLevel;
    }

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw _mapHttpError(response.statusCode, response.body);
      }

      final decoded = jsonDecode(response.body);
      final text = _extractTextFromResponse(decoded);
      if (text == null || text.trim().isEmpty) {
        throw const TutorException(503, 'The tutor returned an empty answer.');
      }

      return text.trim();
    } on TutorException {
      rethrow;
    } on FormatException {
      throw const TutorException(
        503,
        'The tutor returned an invalid response.',
      );
    } on Exception {
      throw TutorException(
        503,
        'Could not reach Ollama at $baseUrl. Check that Ollama is running and the URL is reachable from this device.',
      );
    }
  }

  String? _extractTextFromResponse(dynamic decoded) {
    if (decoded is! Map<String, dynamic>) return null;
    final message = decoded['message'];
    if (message is! Map<String, dynamic>) return null;
    final content = message['content'];
    return content is String ? content : null;
  }

  TutorException _mapHttpError(int statusCode, String body) {
    final payload = jsonDecode(body);
    final error = payload is Map ? payload['error'] : null;
    final message = error is String ? error : _fallbackErrorMessage(statusCode);

    return TutorException(statusCode, message);
  }

  String _fallbackErrorMessage(int statusCode) {
    return switch (statusCode) {
      400 => 'Ollama could not process the question.',
      404 => 'Ollama endpoint or model not found. Check your Ollama settings.',
      500 || 503 => 'The Linux tutor is temporarily unavailable.',
      _ => 'Unable to contact the Linux tutor (HTTP $statusCode).',
    };
  }
}
