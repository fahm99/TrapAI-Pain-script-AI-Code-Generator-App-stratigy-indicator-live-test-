import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> generatePineScript({
    required String prompt,
    required String type,
    required String version,
  }) async {
    final apiKey = AppConfig.geminiApiKey;

    final systemPrompt = '''You are TrapAI, an expert Pine Script coding assistant. 
Generate Pine Script code for TradingView based on the user's request.

Rules:
- Use $version syntax
- Generate a ${type.toLowerCase()} (not a strategy if indicator requested)
- Include clear comments in the code
- Return the complete code ready to paste in TradingView
- After the code, provide a brief explanation of how it works
- Format your response with markdown: use ```pine for code blocks and **bold** for important text''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': '$systemPrompt\n\nUser request: $prompt'},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 4096,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response generated.';
      } else {
        return 'Error: Failed to generate code (Status: ${response.statusCode}). Please try again.';
      }
    } catch (e) {
      return 'Error: Unable to connect to AI service. Please check your connection and try again.';
    }
  }
}
