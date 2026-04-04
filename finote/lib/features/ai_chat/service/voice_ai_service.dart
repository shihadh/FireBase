import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:finote/core/config/app_config.dart';
import 'package:finote/core/constants/ai_constant.dart';
import 'package:finote/core/constants/api_constant.dart';
import 'package:intl/intl.dart';

class VoiceAIService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: {
        "Authorization": "Bearer ${AiConstant.openRouterApiKey}",
        "Content-Type": "application/json",
        "X-Title": "Finote App",
      },
    ),
  );

  Future<dynamic> processVoiceCommand({
    required List<Map<String, String>> historyMessages,
    required String currentInput,
  }) async {
    final String today = DateFormat('EEEE, dd-MM-yyyy').format(DateTime.now());

    final systemPrompt =
        """
You are a smart personal finance AI assistant named Finote Voice AI.
TODAY'S DATE IS: $today.

User Keywords to watch for:
- "buy", "spend", "purchase", "paid", "gave" -> type: "expence"
- "got", "earned", "received", "salary", "income", "profit" -> type: "income"

DATE HANDLING:
- If the user says "yesterday", "today", "last Friday", etc., you MUST calculate the exact DD-MM-YYYY relative to $today.
- Default to TODAY ($today) if no date is mentioned.

If the user wants to:
- Add transaction -> extract amount, category, type (income or expence), date (DD-MM-YYYY), note.
- Translate -> return translated text.
- Answer -> respond concisely.

CRITICAL CATEGORY RULES:
You MUST map the user's category to exactly ONE of these values:
- "Food", "Transport", "Bills", "Salary", "Others".

CRITICAL: ALWAYS return valid JSON only.

{
  "action": "add_transaction" | "translate" | "general_question" | "error",
  "type": "income" | "expence" | null,
  "amount": number | null,
  "category": "Food" | "Transport" | "Bills" | "Salary" | "Others",
  "note": string | null,
  "date": "DD-MM-YYYY",
  "response_message": "A friendly message to speak",
  "translated_text": "Translated text if applicable" | null
}
""";

    try {
      final response = await _dio.post(
        ApiConstant.chat,
        data: {
          "model": AiConstant.voiceModel,
          "messages": [
            {"role": "system", "content": systemPrompt},
            ...historyMessages,
            {"role": "user", "content": currentInput},
          ],
          "response_format": {"type": "json_object"},
        },
      );

      final content = response.data["choices"][0]["message"]["content"];

      // Safe JSON parsing
      try {
        if (content is Map) return content;
        return jsonDecode(content.toString());
      } catch (e) {
        log("JSON Parse Error: $e");
        return {
          "action": "general_question",
          "response_message": content.toString(),
        };
      }
    } on DioException catch (e) {
      log("OpenRouter DioError: ${e.response?.statusCode} - ${e.message}");

      String errorMsg = "Something went wrong.";
      if (e.response?.statusCode == 429) {
        errorMsg = "Rate limit reached. Please wait a moment and try again.";
      }

      return {"action": "error", "response_message": errorMsg};
    } catch (e) {
      log("OpenRouter General Error: $e");
      return {
        "action": "error",
        "response_message": "An unexpected error occurred.",
      };
    }
  }
}
