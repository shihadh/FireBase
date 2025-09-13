import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/AddTransaction/widget/button_type_widget.dart';
import 'package:finote/features/shared/widgets/bold_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddTansactionController>(context);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: ColorConst.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorConst.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BoldTextWidget(title: TextConst.amountLabel, size: 20,),
                const SizedBox(height: 6),
                TextFormField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration("₹ 0"),
                ),
                const SizedBox(height: 16),

                BoldTextWidget(title: TextConst.transactionTypeLabel, size: 20),
                
                const SizedBox(height: 6),
                Row(
                  children: [
                  ButtonTypeWidet(
                      label: "+ Income",
                      isSelected: controller.isIncome,
                      onTap: () => controller.setTransactionType(true),
                      color: ColorConst.success,
                    ),
                    const SizedBox(width: 8),
                    ButtonTypeWidet(
                      label: "- Expense",
                      isSelected: !controller.isIncome,
                      onTap: () => controller.setTransactionType(false),
                      color: ColorConst.danger,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BoldTextWidget(title: TextConst.dateLabel, size: 20),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: (){controller.pickDate(context);},
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: controller.dateController,
                      decoration: inputDecoration("DD-MM-YYYY").copyWith(
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BoldTextWidget(title: TextConst.categoryLabel, size: 20),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  dropdownColor: ColorConst.backgroundColor,
                  initialValue: controller.selectedCategory,
                  decoration: inputDecoration("Select category"),
                  items: controller.categories
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: controller.setCategory,
                ),
                const SizedBox(height: 16),

                Row(
                  children: const [
                BoldTextWidget(title: TextConst.noteLabel, size: 20),
                    SizedBox(width: 4),
                    Text("(Optional)", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: controller.noteController,
                  maxLines: 3,
                  decoration: inputDecoration("Add a note about this transaction..."),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      if (formKey.currentState!.validate()) {
                       await controller.add(context);
                        if (controller.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            backgroundColor: ColorConst.danger,
                            content: Text(controller.error.toString()),
                          ),
                        );
                        return;
                      }
                      if(controller.status == true){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            elevation: 10,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            backgroundColor: ColorConst.success,
                            content: Text(TextConst.transactionSucess),
                          ),
                        );
                      }
                    }},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.loading == true ? Center(child: CircularProgressIndicator(color: ColorConst.white,)): Text(
                      TextConst.saveTransactionButton,
                      style: TextStyle(
                        color: ColorConst.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: ColorConst.greyopacity,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
