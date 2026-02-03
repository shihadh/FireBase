import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/home/widget/balance_card_widget.dart';
import 'package:finote/features/home/widget/income_card_widget.dart';
import 'package:finote/features/home/widget/expense_card_widget.dart';
import 'package:finote/features/home/widget/home_pi_chart_widget.dart';
import 'package:finote/features/shared/widgets/bold_text_widget.dart';
import 'package:finote/features/shared/widgets/gap_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   @override
  void initState() {
    super.initState();
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddTansactionController>(context, listen: false).get();
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: ColorConst.backgroundColor,
    body: RefreshIndicator(
      onRefresh: () async {
        await context.read<AddTansactionController>().get(forceRefresh: true);
      },
      color: ColorConst.black,
      backgroundColor: ColorConst.white,
      child: Consumer<AddTansactionController>(
        builder: (context, provider, _) {
          final transactions = provider.transations; // filtered by selected month/year
          
          return ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              BoldTextWidget(title: TextConst.signInTitle, size: 20),
              GapWidget(),
              BalanceCardWidget(balance: provider.totalBalance),
              GapWidget(),
              Row(
                children: const [
                  Expanded(child: IncomeCardWidget()),
                  Expanded(child: ExpenseCardWidget()),
                ],
              ),
              GapWidget(),
              IncomeExpensePieChart(
                income: provider.totalIncome,
                expense: provider.totalExpense,
              ),
              GapWidget(),
              BoldTextWidget(title: "Recent Transactions", size: 18),
              SizedBox(height: 5,),
              if (transactions.isEmpty)
                const Center(child: Text("No transactions"))
              else
                ...transactions.take(3).map(
                  (tx) => Card(
                    color: ColorConst.white,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                     
                      title: Text(tx.note ?? "No Note"),
                      subtitle: Text("${tx.category} • ${tx.date}"),
                      trailing: Text(
                        "${tx.type == "income" ? "+ " : "- "}${tx.amount}",
                        style: TextStyle(
                          color: tx.type == "income" ? ColorConst.success : ColorConst.danger,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

}
