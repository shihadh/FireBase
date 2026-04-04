
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:finote/core/config/app_config.dart';
import 'package:finote/core/constants/ai_constant.dart';
import 'package:finote/core/constants/api_constant.dart';

class ChatAIService {
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

  Future<String> askFinanceQuestion({
    required String question,
    required String financeHistory,
    List<Map<String, String>> historyMessages = const [],
  }) async {
    final systemPrompt = """
You are Finote AI, a smart and friendly finance assistant.

RULES:
- Keep answers short
- Be conversational
- Use emojis occasionally 😊
- Only use provided finance data
- If data is missing, say you don't have enough info

Do NOT return JSON. Respond in plain text.

""";

    try {
      final response = await _dio.post(
        ApiConstant.chat,
        data: {
          "model": AiConstant.chatModel,
          "messages": [
            {"role": "system", "content": systemPrompt},
            {
              "role": "user",
              "content": "Finance Data:\n$financeHistory"
            },
            ...historyMessages.map((m) => {
                  "role": m["role"],
                  "content": m["content"],
                }),
            {"role": "user", "content": question},
          ],
        },
      );

      final content = response.data["choices"][0]["message"]["content"];

      return content?.toString().trim() ??
          "I couldn't analyze that 🤔";
    } on DioException catch (e) {
      log("Chat AI DioError: ${e.response?.statusCode} - ${e.message}");

      if (e.response?.statusCode == 429) {
        return "Too many requests 😵‍💫 Please try again in a moment.";
      }

      return "Something went wrong 😕";
    } catch (e, s) {
      log("Chat AI Error: $e", stackTrace: s);
      return "I'm having trouble analyzing your finances 😕";
    }
  }
}