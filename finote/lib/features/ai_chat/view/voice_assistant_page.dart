import 'dart:ui';
import 'package:finote/core/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/voice_controller.dart';
import '../../AddTransaction/controller/add_tansaction_controller.dart';

class VoiceAssistantPage extends StatefulWidget {
  const VoiceAssistantPage({super.key});

  @override
  State<VoiceAssistantPage> createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<VoiceAssistantPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addTxController = context.read<AddTansactionController>();
      final voiceController = context.read<VoiceController>();
      voiceController.setTransactionController(addTxController);
      voiceController.playGreeting();
    });
  }

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Finote AI", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2,color: ColorConst.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer<VoiceController>(
                builder: (context, controller, child) {
                  _scrollToBottom();
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 20),
                    itemCount: controller.messages.length + (controller.isProcessing ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.messages.length) {
                        return const _ThinkingIndicator();
                      }
                      final msg = controller.messages[index];
                      return _buildModernBubble(msg.message, msg.isUser);
                    },
                  );
                },
              ),
            ),
            _buildModernInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(1), // Gradient border effect
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(24),
          gradient: isUser 
            ? const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA855F7)])
            : LinearGradient(colors: [ColorConst.white.withValues(alpha: 0.01), ColorConst.white.withValues(alpha: 0.01)]),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
              decoration: BoxDecoration(
                color: isUser ? Colors.transparent : Colors.white.withOpacity(0.05),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernInputArea() {
    return Consumer<VoiceController>(
      builder: (context, controller, child) {
        return Container(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40, top: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.currentTranscription.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    controller.currentTranscription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              _MicButton(
                isListening: controller.isListening,
                onTap: () {
                  if (controller.isListening) {
                    controller.stopListening();
                  } else {
                    controller.startListening(context);
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                controller.isListening ? "Listening..." : "Tap to Speak",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _ThinkingIndicator extends StatefulWidget {
  const _ThinkingIndicator();

  @override
  State<_ThinkingIndicator> createState() => _ThinkingIndicatorState();
}

class _ThinkingIndicatorState extends State<_ThinkingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Thinking", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            ...List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double opacity = ((_controller.value * 3 - index) % 3) / 3;
                  return Opacity(
                    opacity: opacity.clamp(0.2, 1.0),
                    child: const Text(".", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;

  const _MicButton({required this.isListening, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isListening)
            const _RippleAnimation(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Icon(
              isListening ? Icons.stop_rounded : Icons.mic_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

class _RippleAnimation extends StatefulWidget {
  const _RippleAnimation();

  @override
  State<_RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<_RippleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 80 + (_controller.value * 60),
          height: 80 + (_controller.value * 60),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF6366F1).withOpacity(1 - _controller.value), width: 2),
          ),
        );
      },
    );
  }
}
