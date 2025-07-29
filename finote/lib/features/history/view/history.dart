import 'dart:developer';

import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddTansactionController>(context, listen: false).get();
    });

    return Consumer<AddTansactionController>(
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.transations.length,
          itemBuilder: (context, index) {
            final txn = value.transations[index];
            bool isIncome = txn.type == "income";

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      isIncome ? Colors.green[100] : Colors.red[100],
                  child: Icon(
                    isIncome ? Icons.trending_up : Icons.trending_down,
                    color: isIncome ? ColorConst.success : ColorConst.danger,
                  ),
                ),
                title: Text(txn.category ?? TextConst.nonValue),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(txn.date ?? TextConst.nonValue),
                    Text(txn.note ?? TextConst.nonValue),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${isIncome ? '+' : '-'}₹${txn.amount}",
                      style: TextStyle(
                        color:
                            isIncome ? ColorConst.success : ColorConst.danger,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: (val) async{
                        log(txn.id.toString());
                        if (val == 'delete') {
                            await  value.delete(txn.id!,);
                             if (value.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            backgroundColor: ColorConst.danger,
                            content: Text(value.error.toString()),
                          ),
                        );
                        return;
                      }
                      if(value.status == true){
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
                            content: Text(TextConst.deleteSucess),
                          ),
                        );
                          await value.get();
                      }
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
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
          },
        );
      },
    );
  }
}
