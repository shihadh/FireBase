import 'package:flutter/material.dart';
import 'package:prompt_polisher_ai/constants/text_const.dart';

class PromptInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const PromptInput({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: TextConst.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text(TextConst.polish),
        ),
      ],
    );
  }
}