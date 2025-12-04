import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/shared/widgets/normal_text_widget.dart';

class IncomeExpensePieChart extends StatelessWidget {
  final double income;
  final double expense;

  const IncomeExpensePieChart({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, double> data = {
      "Income": income > 0 ? income : 1,
      "Expense": expense > 0 ? expense : 1,
    };

    return Card(
      color: ColorConst.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NormalTextWidget(
              title: "Income vs Expense",
              size: 16,
              color: ColorConst.blackopacity,
            ),
            const SizedBox(height: 20),
            PieChart(
              dataMap: data,
              colorList: [ColorConst.green, ColorConst.danger],
              chartRadius: MediaQuery.of(context).size.width / 2.3,
              chartType: ChartType.ring,
              ringStrokeWidth: 45,
              animationDuration: const Duration(milliseconds: 800),
              chartValuesOptions: const ChartValuesOptions(
                showChartValues: true,
                showChartValuesInPercentage: true,
                decimalPlaces: 1,
              ),
              legendOptions: const LegendOptions(
                showLegends: true,
                legendPosition: LegendPosition.right,
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
