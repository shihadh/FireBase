import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/history/widget/month_year_dropdown_widget.dart';
import 'package:finote/features/history/widget/transation_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initial fetch once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddTansactionController>().get();
    });

    return Scaffold(
      backgroundColor: ColorConst.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConst.backgroundColor,
        title: const Text(TextConst.historytitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const MonthYearDropdownRow(),
            const SizedBox(height: 20),

            // Add RefreshIndicator 
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<AddTansactionController>().get(forceRefresh: true);
                },
                color: ColorConst.black,
                backgroundColor: ColorConst.white,
                child: const TransactionListView(),
              ),
            ),
          ],
        ),
      ),

      // PDF Export FAB button
      floatingActionButton: Consumer<AddTansactionController>(
        builder: (context, value, child) {
          if (!value.download) return const SizedBox.shrink();

          return FloatingActionButton(
            onPressed: () => value.exportFilteredToPDF(),
            backgroundColor: ColorConst.black,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.download,
              color: ColorConst.white,
            ),
          );
        },
      ),
    );
  }
}
