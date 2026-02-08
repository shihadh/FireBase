import 'dart:developer';

import 'package:flutter/material.dart';
import '../model/chat_message_model.dart';
import '../../AddTransaction/model/transation_model.dart';
import '../../shared/service/ai_chat_service.dart';
import '../../shared/helper/finance_summary_helper.dart';

class AiChatController extends ChangeNotifier {

  List<ChatMessageModel> messages = [];

  bool isLoading = false;

  final textController = TextEditingController();

  final GeminiAiChatService aiService =
      GeminiAiChatService();

  // ---------------- SEND MESSAGE ----------------

  Future<void> sendMessage(
    String question,
    List<TransationModel> allTransactions,
  ) async {

    if (question.trim().isEmpty) return;

    /// Add user message
    messages.add(
      ChatMessageModel(
        message: question,
        isUser: true,
        time: DateTime.now(),
      ),
    );

    /// Greeting
    if (_isGreeting(question)) {

      messages.add(
        ChatMessageModel(
          message:
              "Hey 👋 Ask me anything about your finances!",
          isUser: false,
          time: DateTime.now(),
        ),
      );

      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {

      if (allTransactions.isEmpty) {

        messages.add(
          ChatMessageModel(
            message:
                "You don't have any transactions yet 📭",
            isUser: false,
            time: DateTime.now(),
          ),
        );

        isLoading = false;
        notifyListeners();
        return;
      }

      /// Build full finance intelligence
      final summary =
          FinanceSummaryHelper.buildFullSummary(
              allTransactions);

      final historyText =
          FinanceSummaryHelper.formatSummaryForAI(
              summary);

      log("Finance History:\n$historyText");

      ///  Call AI
      final aiResponse =
          await aiService.askFinanceQuestion(
        question: question,
        financeHistory: historyText,
      );

      messages.add(
        ChatMessageModel(
          message: aiResponse,
          isUser: false,
          time: DateTime.now(),
        ),
      );

    } catch (e, s) {

      log("AI Chat Error: $e", stackTrace: s);

      messages.add(
        ChatMessageModel(
          message:
              "Something went wrong. Try again.",
          isUser: false,
          time: DateTime.now(),
        ),
      );
    }

    isLoading = false;
    notifyListeners();
  }

  bool _isGreeting(String text) {

    final greetings = [
      "hi",
      "hello",
      "hey",
      "good morning",
      "good evening",
      "good afternoon"
    ];

    return greetings.contains(
      text.toLowerCase().trim(),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
