import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/business%20profile/controller/business_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessProfilePage extends StatelessWidget {
  const BusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = Provider.of<BusinessController>(context);

    return Scaffold(
      backgroundColor: ColorConst.backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              children: [
                // Logo Placeholder
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.apartment, color: ColorConst.white, size: 40),
                ),
                const SizedBox(height: 20),

                // Title & Subtitle
                Text(
                  TextConst.pageTitle,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  TextConst.pageSubtitle,
                  style: const TextStyle(fontSize: 14, color: ColorConst.blackopacity),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Business Name
                          const Text(TextConst.businessNameLabel),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controller.businessNameController,
                            validator: (val) =>
                                val == null || val.isEmpty ? 'Please enter business name' : null,
                            decoration: _inputDecoration(TextConst.businessNameHint),
                          ),
                          const SizedBox(height: 20),

                          // Currency Dropdown
                          const Text(TextConst.currencyLabel),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: controller.selectedCurrency,
                            items: TextConst.currencyList
                                .map((currency) => DropdownMenuItem(
                                      value: currency,
                                      child: Text(currency),
                                    ))
                                .toList(),
                            onChanged: controller.updateCurrency,
                            decoration: _inputDecoration(""),
                          ),
                          const SizedBox(height: 20),

                          // GST ID
                          Row(
                            children: const [
                              Text(TextConst.gstLabel),
                              SizedBox(width: 6),
                              Text(
                                TextConst.gstOptional,
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controller.gstController,
                            decoration: _inputDecoration(TextConst.gstHint),
                          ),
                          const SizedBox(height: 24),

                          // Continue Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Business Profile Created')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConst.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                              child: const Text(
                                TextConst.continueButton,
                                style: TextStyle(fontWeight: FontWeight.bold,color: ColorConst.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: ColorConst.greyopacity,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
