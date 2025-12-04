// features/home/widget/balance_card_widget.dart
import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/home/widget/container_widget.dart';
import 'package:finote/features/shared/widgets/normal_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BalanceCardWidget extends StatelessWidget {
  final double balance;
  const BalanceCardWidget({super.key, required this.balance});

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165,
      decoration: BoxDecoration(
        color: ColorConst.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalTextWidget(
                    title: "Total Balance",
                    size: 20,
                    color: ColorConst.grey,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formatCurrency(balance),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: ColorConst.white,
                      ),
                    ),
                  ),
                  ContainerWidget(
                    bg: ColorConst.grey,
                    color: ColorConst.white,
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: ColorConst.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(FontAwesomeIcons.wallet),
            )
          ],
        ),
      ),
    );
  }
}
