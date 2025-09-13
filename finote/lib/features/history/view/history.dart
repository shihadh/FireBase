import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/history/widget/month_year_dropdown_widget.dart';
import 'package:finote/features/history/widget/transation_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddTansactionController>().get();
    });

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: const [
          MonthYearDropdownRow(),
          SizedBox(height: 20),
          Expanded(child: TransactionListView()),
        ],
      ),
    );
  }
}
