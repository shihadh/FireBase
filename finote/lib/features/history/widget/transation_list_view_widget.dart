import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/history/widget/history_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionListView extends StatelessWidget {
  const TransactionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTansactionController>(
      builder: (context, value, _) {
        final transactions = value.transations;

        if (transactions.isEmpty) {
          return Center(
            child: Text(
              "No history available",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorConst.grey,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return HistoryTile(txn: transactions[index]);
          },
        );
      },
    );
  }
}
