
import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';

class FirebaseAiChatService {

  final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.0-flash',
  );

  
  Future<String> askFinanceQuestion({
    required String question,
    required Map<String, dynamic> summary,
  }) async {
      log(  'Asking AI with question: $question and summary: $summary');
    final prompt = """
      You are Finote AI, a friendly and smart personal finance assistant.

      Speak naturally like a helpful assistant.

      Rules:
      - Keep answers short
      - Be conversational
      - Use emojis occasionally
      - Only talk about finance data provided
      - If user greets, greet back warmly
      - If user asks unrelated questions, politely guide them back to finance

      User Financial Summary:
      Income: ₹${summary['income']}
      Expense: ₹${summary['expense']}
      Transaction Count: ${summary['count']}

      Category Breakdown:
      ${summary['categories']}

      User Question:
      $question

      Answer:
      """;

    log(  'Generated prompt for AI: $prompt');
    final response = await _model.generateContent([
      Content.text(prompt)
    ]);
    log( 'AI Response: ${response.text}');
    return response.text ?? "Sorry, no response.";
  }
}
