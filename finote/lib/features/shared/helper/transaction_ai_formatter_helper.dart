import 'package:finote/features/AddTransaction/model/transation_model.dart';

class TransactionAiFormatterHelper {

  static String format(List<TransationModel> transactions) {

    return transactions.map((t) {
      return """
        Date: ${t.date}
        Category: ${t.category}
        Amount: ₹${t.amount}
        Type: ${t.type}
        """;
    }).join("\n");
  }
}
