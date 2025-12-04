// features/home/widget/income_card_widget.dart
import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/home/widget/container_widget.dart';
import 'package:finote/features/shared/widgets/bold_text_widget.dart';
import 'package:finote/features/shared/widgets/normal_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IncomeCardWidget extends StatelessWidget {
  const IncomeCardWidget({super.key});

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddTansactionController>();
    return Card(
      color: ColorConst.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorConst.greenBg,
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: ColorConst.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalTextWidget(
                        title: TextConst.income,
                        size: 15,
                        color: ColorConst.blackopacity,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: BoldTextWidget(
                          title: formatCurrency(provider.totalIncome),
                          size: 25,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            ContainerWidget(
              bg: ColorConst.greenBg,
              color: ColorConst.green,
            )
          ],
        ),
      ),
    );
  }
}
