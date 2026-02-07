import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/ai_chat/controller/ai_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final transactionController =
        context.read<AddTansactionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finote AI Assistant"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          /// ---------------- CHAT LIST ----------------
          Expanded(
            child: Consumer<AiChatController>(
              builder: (_, controller, __) {

                _scrollToBottom();

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 10),

                  itemCount: controller.messages.length +
                      (controller.isLoading ? 1 : 0),

                  itemBuilder: (_, index) {

                    /// Typing Indicator
                    if (index == controller.messages.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "AI is typing...",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }

                    final msg = controller.messages[index];

                    return Align(
                      alignment: msg.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.all(12),

                        constraints: const BoxConstraints(
                          maxWidth: 280,
                        ),

                        decoration: BoxDecoration(
                          color: msg.isUser
                              ? Colors.blue
                              : Colors.grey.shade300,

                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: msg.isUser
                                ? const Radius.circular(16)
                                : const Radius.circular(0),
                            bottomRight: msg.isUser
                                ? const Radius.circular(0)
                                : const Radius.circular(16),
                          ),
                        ),

                        child: Text(
                          msg.message,
                          style: TextStyle(
                            color: msg.isUser
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// ---------------- INPUT AREA ----------------
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                  )
                ],
              ),

              child: Consumer<AiChatController>(
                builder: (_, controller, __) {

                  return Row(
                    children: [

                      /// Text Input
                      Expanded(
                        child: TextField(
                          controller: controller.textController,
                          textCapitalization:
                              TextCapitalization.sentences,

                          decoration: InputDecoration(
                            hintText: "Ask about your expenses...",
                            filled: true,
                            fillColor: ColorConst.greyopacity,

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      /// Send Button
                      IconButton(
                        icon: const Icon(Icons.send),

                        onPressed: controller.isLoading
                            ? null
                            : () {

                                final question =
                                    controller.textController.text.trim();

                                if (question.isEmpty) return;

                                controller.sendMessage(
                                  question,
                                  transactionController
                                      .allTransactions, // important
                                );

                                controller.textController.clear();
                              },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
