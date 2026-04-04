import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../AddTransaction/controller/add_tansaction_controller.dart';
import '../model/chat_message_model.dart';
import '../service/speech_service.dart';
import '../service/tts_service.dart';
import '../service/voice_ai_service.dart';
import 'package:intl/intl.dart';

class VoiceController extends ChangeNotifier {
  final SpeechService _speechService = SpeechService();
  final TTSService _ttsService = TTSService();
  final VoiceAIService _aiService = VoiceAIService();

  List<ChatMessageModel> messages = [];
  bool isListening = false;
  bool isProcessing = false;
  String currentTranscription = "";
  
  String errorMsg = "";
  BuildContext? _currentContext;
  AddTansactionController? _transactionController;

  void setTransactionController(AddTansactionController controller) {
    _transactionController = controller;
  }

  Future<void> initSpeech() async {
    await _speechService.init((status) {
      log('Speech status: $status');
      if (status == 'listening') {
        isListening = true;
        notifyListeners();
      } else if (status == 'notListening' || status == 'done') {
        isListening = false;
        notifyListeners();
      }
    });
  }

  Future<void> playGreeting() async {
    if (messages.isNotEmpty) return; // Only greet if empty
    
    const greeting = "Hi! I'm Finote Voice AI. How can I help you?";
    _addMessage(greeting, false);
    notifyListeners();
    await _ttsService.speak(greeting);
  }

  Future<void> startListening(BuildContext context) async {
    _currentContext = context;
    currentTranscription = "";
    errorMsg = "";
    await _ttsService.stop(); // Stop previous speech

    await initSpeech();
    
    await _speechService.startListening(
      onResult: (text, isFinal) {
        currentTranscription = text;
        notifyListeners();
        
        if (isFinal && text.trim().isNotEmpty) {
           _onSpeechEnd();
        }
      },
      pauseFor: const Duration(seconds: 12), // Increased to 12 seconds as requested
    );
  }
  
  Future<void> stopListening() async {
    await _speechService.stop();
    isListening = false;
    notifyListeners();
    if (currentTranscription.isNotEmpty) {
        _onSpeechEnd();
    }
  }

  Future<void> _onSpeechEnd() async {
    if (isProcessing) return;
    
    final input = currentTranscription;
    currentTranscription = ""; 
    
    if (input.trim().isEmpty) return;

    _addMessage(input, true);
    await _processInput(input);
  }

  List<Map<String, String>> _getHistory() {
    final recent = messages.length > 5 ? messages.sublist(messages.length - 5) : messages;
    return recent.map((m) {
      return {
        "role": m.isUser ? "user" : "assistant",
        "content": m.message,
      };
    }).toList();
  }

  Future<void> _processInput(String input) async {
    isProcessing = true;
    notifyListeners();

    try {
      final dynamic aiResponse = await _aiService.processVoiceCommand(
        historyMessages: _getHistory(),
        currentInput: input,
      );

      final Map<String, dynamic> responseJson = aiResponse is Map<String, dynamic> 
          ? aiResponse 
          : (aiResponse is String ? jsonDecode(aiResponse) : {});

      await _handleAIResponse(responseJson);

    } catch (e) {
      log("Voice AI Error: $e");
      errorMsg = "Sorry, I encountered an error connecting to the AI.";
      _addMessage(errorMsg, false);
      await _ttsService.speak(errorMsg);
    }

    isProcessing = false;
    notifyListeners();
  }

  Future<void> _handleAIResponse(Map<String, dynamic> data) async {
    final action = data["action"];
    final responseMsg = data["response_message"] ?? "Done.";
    String finalDisplayMsg = responseMsg;

    if (action == "add_transaction") {
       final amount = data["amount"];
       final category = data["category"];
       final type = data["type"];
       final note = data["note"];
       final dateStr = data["date"]; 

       if (_transactionController != null && amount != null && _currentContext != null) {
          log("Adding Transaction via AI: Amount=$amount, Category=$category, Type=$type, Date=$dateStr");
          
          // Clear previous state first to avoid residual values
          _transactionController!.amountController.clear();
          _transactionController!.noteController.clear();
          _transactionController!.setCategory(null);
          
          _transactionController!.amountController.text = amount.toString();
          
          // Strict Category Mapping to prevent Dropdown Button Exception
          String validCategory = _mapCategory(category?.toString());
          _transactionController!.setCategory(validCategory);

          // Force Income/Expense type
          bool isIncome = type.toString().toLowerCase() == "income";
          _transactionController!.setTransactionType(isIncome);
          
          log("Final Controller State: isIncome=${_transactionController!.isIncome}, category=${_transactionController!.selectedCategory}");

          _transactionController!.noteController.text = note?.toString() ?? "";
          
          if (dateStr != null && dateStr.toString().isNotEmpty) {
             _transactionController!.dateController.text = dateStr.toString();
          } else {
             _transactionController!.dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
          }

          if (_currentContext!.mounted) {
             await _transactionController!.add(_currentContext!);
             log("Transaction Add Call completed. Status=${_transactionController!.status}");
             
             if (_transactionController!.status == false && _transactionController!.error != null) {
                errorMsg = "Failed to add transaction: ${_transactionController!.error}";
                _addMessage(errorMsg, false);
                await _ttsService.speak(errorMsg);
                return; // Stop here if failed
             }
          }
       }
    } else if (action == "translate") {
       final translatedText = data["translated_text"];
       if (translatedText != null) {
          finalDisplayMsg = "$responseMsg\n\n**Translation:** $translatedText";
       }
    }

    _addMessage(finalDisplayMsg, false);
    await _ttsService.speak(responseMsg);
  }

  String _mapCategory(String? category) {
    if (category == null) return "Others";
    
    final List<String> allowed = ['Food', 'Transport', 'Bills', 'Salary', 'Others'];
    String cat = category.trim();
    if (cat.isEmpty) return "Others";
    
    // Capitalize first letter
    cat = cat[0].toUpperCase() + cat.substring(1).toLowerCase();
    
    if (allowed.contains(cat)) return cat;
    
    // Fallbacks for common variations
    if (cat.contains("Bill")) return "Bills";
    if (cat.contains("Travel") || cat.contains("Travel")) return "Transport";
    if (cat.contains("Eat") || cat.contains("Grocery")) return "Food";
    if (cat.contains("Income") || cat.contains("Earning")) return "Salary";

    return "Others";
  }

  void _addMessage(String text, bool isUser) {
    messages.add(
      ChatMessageModel(
        message: text,
        isUser: isUser,
        time: DateTime.now(),
      )
    );
  }

  @override
  void dispose() {
    _ttsService.stop();
    _speechService.cancel();
    super.dispose();
  }
}
