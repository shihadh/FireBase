import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/AddTransaction/model/transation_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryTile extends StatelessWidget {
  final TransationModel txn;

  const HistoryTile({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    final isIncome = txn.type == "income";
    final provider = context.read<AddTansactionController>();

    return Card(
      color: isIncome ? ColorConst.greenBg : ColorConst.dangerbg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? ColorConst.green.withValues(alpha: 0.15)
              : ColorConst.danger.withValues(alpha: 0.15),
          child: Icon(
            isIncome ? Icons.trending_up : Icons.trending_down,
            color: isIncome ? ColorConst.green : ColorConst.danger,
          ),
        ),
        title: Text(
          txn.category ?? TextConst.nonValue,
          style: const TextStyle(fontWeight: FontWeight.bold, color: ColorConst.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(txn.date ?? TextConst.nonValue, style: const TextStyle(color: ColorConst.blackopacity)),
            Text(txn.note ?? TextConst.nonValue, style: TextStyle(color: ColorConst.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${isIncome ? '+' : '-'}₹${txn.amount}",
              style: TextStyle(
                color: isIncome ? ColorConst.green : ColorConst.danger,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (val) async {
                if (val == 'delete') {
                  await provider.delete(txn.id!);

                  final msg = provider.status
                      ? TextConst.deleteSucess
                      : provider.error ?? "Something went wrong";

                  final bgColor = provider.status ? ColorConst.success : ColorConst.danger;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(msg),
                      backgroundColor: bgColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );

                  if (provider.status) {
                    await provider.get(); // Refresh data
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: ColorConst.danger),
                      SizedBox(width: 8),
                      Text(TextConst.delete),
                    ],
                  ),
                ),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
