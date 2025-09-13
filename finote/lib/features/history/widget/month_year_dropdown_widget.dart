import 'package:flutter/material.dart';
import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MonthYearDropdownRow extends StatelessWidget {
  const MonthYearDropdownRow({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddTansactionController>();

    return Row(
      children: [
        // Month Dropdown
        Expanded(
          child: DropdownButtonFormField<int>(
            dropdownColor: ColorConst.backgroundColor,
            initialValue: provider.selectedMonth,
            decoration: InputDecoration(
              labelText: 'Month',
              filled: true,
              fillColor: ColorConst.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            items: List.generate(12, (index) {
              return DropdownMenuItem(
                value: index + 1,
                child: Text(DateFormat.MMMM().format(DateTime(0, index + 1))),
              );
            }),
            onChanged: (val) {
              if (val != null) {
                provider.updateSelectedDate(val, provider.selectedYear);
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        // Year Dropdown (dynamic, safe)
        Expanded(
          child: DropdownButtonFormField<int>(
            dropdownColor: ColorConst.backgroundColor,
            initialValue: provider.selectedYear,
            decoration: InputDecoration(
              labelText: 'Year',
              filled: true,
              fillColor: ColorConst.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            items: [
              // Normal range
              for (int year = provider.maxYear; year >= provider.minYear; year--)
                DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                ),
              // Ensure selectedYear is included even if outside min/max
              if (provider.selectedYear < provider.minYear ||
                  provider.selectedYear > provider.maxYear)
                DropdownMenuItem(
                  value: provider.selectedYear,
                  child: Text(provider.selectedYear.toString()),
                ),
            ],
            onChanged: (val) {
              if (val != null) {
                provider.updateSelectedDate(provider.selectedMonth, val);
              }
            },
          ),
        ),
      ],
    );
  }
}
