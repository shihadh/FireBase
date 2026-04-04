import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:finote/core/config/app_config.dart';
import 'package:finote/core/constants/ai_constant.dart';
import 'package:finote/core/constants/api_constant.dart';

class AIInsightService {
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

  Future<String> generateInsight({
    required double income,
    required double expense,
    required String topCategory,
    required double changePercent,
  }) async {
    final prompt = """
You are a smart personal finance assistant.
this is a previous month finance summary
Income: ₹$income  
Expense: ₹$expense  
Top Category: $topCategory  
Expense Change: ${changePercent.toStringAsFixed(1)}%

Give:
• Short spending summary  
• One saving tip  

Keep response under 50 words.
Be clear, friendly, and concise.
""";

    try {
      final response = await _dio.post(
        ApiConstant.chat,
        data: {
          "model": AiConstant.insightModel,
          "messages": [
            {"role": "system", "content": "You are a helpful finance assistant."},
            {"role": "user", "content": prompt},
          ],
        },
      );

      final content = response.data["choices"][0]["message"]["content"];

      return content?.toString().trim() ?? "No insight generated";
    } on DioException catch (e) {
      log("Insight AI DioError: ${e.response?.statusCode} - ${e.message}");

      if (e.response?.statusCode == 429) {
        return "Too many requests 😵‍💫 Try again later.";
      }

      return "Couldn't generate insight 😕";
    } catch (e) {
      log("Insight AI Error: $e");
      return "Something went wrong 😕";
    }
  }
}