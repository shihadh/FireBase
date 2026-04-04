import 'dart:developer';

import 'package:finote/features/shared/service/ai_chat_service.dart';
import 'package:flutter/material.dart';
import '../model/chat_message_model.dart';
import '../../AddTransaction/model/transation_model.dart';
import '../../shared/helper/finance_summary_helper.dart';

class AiChatController extends ChangeNotifier {
  List<ChatMessageModel> messages = [];

  bool isLoading = false;

  final textController = TextEditingController();

  final ChatAIService aiService = ChatAIService();

  //  SEND MESSAGE 

  Future<void> sendMessage(
    String question,
    List<TransationModel> allTransactions,
  ) async {
    /// Prevent duplicate calls
    if (isLoading) return;

    if (question.trim().isEmpty) return;

    /// Add user message
    messages.add(
      ChatMessageModel(
        message: question,
        isUser: true,
        time: DateTime.now(),
      ),
    );

    /// Clear input field
    textController.clear();

    /// Greeting handling
    if (_isGreeting(question)) {
      messages.add(
        ChatMessageModel(
          message: "Hey 👋 Ask me anything about your finances!",
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
      /// Empty data case
      if (allTransactions.isEmpty) {
        messages.add(
          ChatMessageModel(
            message: "You don't have any transactions yet 📭",
            isUser: false,
            time: DateTime.now(),
          ),
        );

        isLoading = false;
        notifyListeners();
        return;
      }

      /// Build finance summary
      final summary =
          FinanceSummaryHelper.buildFullSummary(allTransactions);

      final historyText =
          FinanceSummaryHelper.formatSummaryForAI(summary);

      log("Finance History:\n$historyText");

      /// Call AI
      final aiResponse = await aiService.askFinanceQuestion(
        question: question,
        financeHistory: historyText,
        historyMessages: _buildHistory(),
      );

      /// Add AI response
      messages.add(
        ChatMessageModel(
          message: aiResponse.toString(),
          isUser: false,
          time: DateTime.now(),
        ),
      );
    } catch (e, s) {
      log("AI Chat Error: $e", stackTrace: s);

      messages.add(
        ChatMessageModel(
          message: "Something went wrong. Try again 😕",
          isUser: false,
          time: DateTime.now(),
        ),
      );
    }

    isLoading = false;
    notifyListeners();
  }

  // CHAT HISTORY 

 List<Map<String, String>> _buildHistory() {
  final recentMessages = messages.length > 6
      ? messages.sublist(messages.length - 6)
      : messages;

  return recentMessages.map((m) => {
        "role": m.isUser ? "user" : "assistant",
        "content": m.message,
      }).toList();
}

  //  GREETING

  bool _isGreeting(String text) {
    final greetings = [
      "hi",
      "hello",
      "hey",
      "good morning",
      "good evening",
      "good afternoon"
    ];

    return greetings.contains(text.toLowerCase().trim());
  }

  // DISPOSE 

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}