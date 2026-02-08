import 'package:intl/intl.dart';
import '../../AddTransaction/model/transation_model.dart';

class FinanceSummaryHelper {

  static Map<String, dynamic> buildFullSummary(
    List<TransationModel> transactions,
  ) {

    Map<String, dynamic> monthlyData = {};

    for (var tx in transactions) {

      if (tx.date == null) continue;

      final date =
          DateFormat('dd-MM-yyyy').parse(tx.date!);

      final key =
          "${date.year}-${date.month.toString().padLeft(2, '0')}";

      final amount =
          double.tryParse(tx.amount ?? '0') ?? 0;

      monthlyData.putIfAbsent(key, () => {
            "income": 0.0,
            "expense": 0.0,
            "categories": <String, double>{},
          });

      if (tx.type == "income") {
        monthlyData[key]["income"] += amount;
      } else {

        monthlyData[key]["expense"] += amount;

        if (tx.category != null) {

          final catMap =
              monthlyData[key]["categories"]
                  as Map<String, double>;

          catMap[tx.category!] =
              (catMap[tx.category!] ?? 0) + amount;
        }
      }
    }

    return monthlyData;
  }

  // Convert summary → AI friendly text
  static String formatSummaryForAI(
    Map<String, dynamic> summary,
  ) {

    String result = "";

    final sortedKeys = summary.keys.toList()..sort();

    // limit last 6 months (quota saver)
    final lastMonths = sortedKeys.length > 6
        ? sortedKeys.sublist(sortedKeys.length - 6)
        : sortedKeys;

    for (var month in lastMonths) {

      final data = summary[month];

      result += "$month\n";
      result += "Income: ₹${data['income']}\n";
      result += "Expense: ₹${data['expense']}\n";

      final categories =
          data['categories'] as Map<String, double>;

      if (categories.isNotEmpty) {
        result += "Categories:\n";

        categories.forEach((cat, value) {
          result += "- $cat: ₹$value\n";
        });
      }

      result += "\n";
    }

    return result;
  }
}
