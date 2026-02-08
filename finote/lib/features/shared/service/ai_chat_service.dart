import 'dart:developer';

import 'package:finote/core/constants/api_constant.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAiChatService {
  static const String _apiKey = ApiConstant.apiKey;

  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _apiKey,
  );

   Future<String> askFinanceQuestion({
    required String question,
    required String financeHistory,
  }) async {
    try {

      final prompt = """
        You are Finote AI, a smart and friendly finance assistant.

        Rules:
        - Keep answers short
        - Be conversational
        - Use emojis occasionally
        - Only talk using finance data provided
        - If data missing, politely say you don't have info

        User Finance History:
        $financeHistory

        User Question:
        $question

        Answer:
        """;

      log("AI Prompt:\n$prompt");

      final response = await _model.generateContent(
        [Content.text(prompt)],
      );

      return response.text?.trim() ??
          "I couldn't analyze that 🤔";

    } catch (e, s) {
      log("Gemini Error: $e", stackTrace: s);
      return "I'm having trouble analyzing your finances 😕";
    }
  }
}