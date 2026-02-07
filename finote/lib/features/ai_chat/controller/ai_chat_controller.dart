import 'dart:developer';

import 'package:finote/features/shared/helper/question_date_parser.dart';
import 'package:finote/features/shared/helper/transaction_filter.dart';
import 'package:finote/features/shared/service/ai_chat_service.dart';
import 'package:flutter/material.dart';
import '../model/chat_message_model.dart';
import '../../AddTransaction/model/transation_model.dart';

class AiChatController extends ChangeNotifier {

  List<ChatMessageModel> messages = [];
  
  bool isLoading = false;
  final TextEditingController textController = TextEditingController();
  final FirebaseAiChatService aiService = FirebaseAiChatService();

  
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

  /// ---------- GREETING CHECK ----------
  if (isGreeting(question)) {
    messages.add(
      ChatMessageModel(
        message: "Hey there! 👋 How can I help with your finances today?",
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

    /// ---------- TIME RANGE ----------
    final range = parseQuestionTime(question);

    /// ---------- FILTER DATA ----------
    final filtered =
        filterByRange(allTransactions, range);

    if (filtered.isEmpty) {
      messages.add(
        ChatMessageModel(
          message:
              "I couldn't find transactions for that time period 📅",
          isUser: false,
          time: DateTime.now(),
        ),
      );

      isLoading = false;
      notifyListeners();
      return;
    }

    /// ---------- BUILD SUMMARY ----------
    final summary = buildMonthlySummary(filtered);

    /// ---------- CALL AI ----------
    final aiResponse =
        await aiService.askFinanceQuestion(
      question: question,
      summary: summary,
    );

    /// ---------- ADD AI MESSAGE ----------
    messages.add(
      ChatMessageModel(
        message: aiResponse,
        isUser: false,
        time: DateTime.now(),
      ),
    );

  } catch (e, stackTrace) {

    log("Error in sendMessage: $e");
    log("Stack trace: $stackTrace");

    messages.add(
      ChatMessageModel(
        message:
            "Something went wrong. Please try again.",
        isUser: false,
        time: DateTime.now(),
      ),
    );
  }

  isLoading = false;
  notifyListeners();
}





  // ---------------- SUMMARY BUILDER ----------------

  Map<String, dynamic> buildMonthlySummary(
    List<TransationModel> transactions,
  ) {

    double expense = 0;
    double income = 0;

    Map<String, double> categoryTotals = {};

    for (var tx in transactions) {

      final amount =
          double.tryParse(tx.amount ?? '0') ?? 0;

      if (tx.type == "income") {
        income += amount;
      } else {

        expense += amount;

        if (tx.category != null) {
          categoryTotals[tx.category!] =
              (categoryTotals[tx.category!] ?? 0) + amount;
        }
      }
    }

    return {
      "income": income,
      "expense": expense,
      "categories": categoryTotals,
      "count": transactions.length,
    };
  }

  bool isGreeting(String text) {
  final greetingWords = [
    'hi',
    'hello',
    'hey',
    'good morning',
    'good evening',
    'good afternoon',
  ];

  return greetingWords.contains(text.toLowerCase().trim());
}


   @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  
}
