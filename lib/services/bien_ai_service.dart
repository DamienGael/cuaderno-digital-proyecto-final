import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BienAIService {

  Future<String> ask(String prompt, String role) async {
    final apiKey = dotenv.env['BIEN_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      return 'La clave de API de Bien no está configurada. Añade BIEN_API_KEY en tu archivo .env.';
    }

    final uri = Uri.parse('https://generativelanguage.googleapis.com/v1beta2/models/gemini-pro-preview:generateText?key=$apiKey');
    final body = jsonEncode({
      'prompt': {
        'text': 'Responde esta pregunta educativa para un usuario con rol $role: $prompt',
      },
      'temperature': 0.7,
      'maxOutputTokens': 250,
    });

    final response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: body);
    if (response.statusCode != 200) {
      return 'Lo siento, no pude generar una respuesta en este momento.';
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['candidates'] is List && data['candidates'].isNotEmpty) {
      return data['candidates'][0]['output'] as String? ?? 'No se obtuvo respuesta.';
    }
    if (data['result'] != null && data['result']['output'] != null) {
      return data['result']['output'] as String;
    }
    return 'No se obtuvo respuesta válida de Gemini.';
  }
}
