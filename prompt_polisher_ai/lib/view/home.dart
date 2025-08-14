import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prompt_polisher_ai/constants/color_constant.dart';
import 'package:prompt_polisher_ai/constants/text_const.dart';
import 'package:prompt_polisher_ai/controller/home_controller.dart';
import 'package:prompt_polisher_ai/widgets/prompt_input.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(TextConst.title),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Input card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PromptInput(
                  controller: provider.promptController,
                  onSubmit: () {
                    context.read<HomeController>().polish(context);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
            if (provider.isloading)
              const Center(child: CircularProgressIndicator()),
            if (!provider.isloading && provider.result.isNotEmpty)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            TextConst.polish,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            tooltip: TextConst.clipboard,
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: provider.result),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  backgroundColor: ColorConstant.bg,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  content: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(),
                                        fillColor: WidgetStatePropertyAll(ColorConstant.success),
                                        value: true, onChanged: null),
                                      Text(TextConst.copyed, style: TextStyle(color: ColorConstant.content),),
                                    ],
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        provider.result,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
