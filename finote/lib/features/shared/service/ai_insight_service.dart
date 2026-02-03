import 'package:firebase_ai/firebase_ai.dart';

class AIInsightService {

  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.0-flash'
  );

  Future<String> generateInsight({
    required double income,
    required double expense,
    required String topCategory,
    required double changePercent,
  }) async {

    final prompt = '''
You are a smart personal finance assistant.

Income: ₹$income
Expense: ₹$expense
Top Category: $topCategory
Expense Change: ${changePercent.toStringAsFixed(1)}%

Give:
• Short spending summary
• One saving tip
Keep answer under 50 words.
''';

    final response = await model.generateContent(
      [Content.text(prompt)],
    );

    return response.text ?? "No insight generated";
  }
}
