import 'dart:developer';

import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/home/widget/container_widget.dart';
import 'package:finote/features/shared/widgets/bold_text_widget.dart';
import 'package:finote/features/shared/widgets/gap_widget.dart';
import 'package:finote/features/shared/widgets/normal_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(amount);
  }
  @override
  void initState() {
    // TODO: implement initState
      Provider.of<AddTansactionController>(context,listen: false).get();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    log("message");
    final provider = context.watch<AddTansactionController>();
    return Scaffold(
      backgroundColor: ColorConst.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              BoldTextWidget(title: TextConst.signInTitle, size: 20),
              GapWidget(),
              Container(
                height: 165,
                decoration: BoxDecoration(
                  color: ColorConst.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NormalTextWidget(
                                  title: TextConst.totalBalance,
                                  size: 20,
                                  color: ColorConst.grey,
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    formatCurrency(provider.totalBalance),
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
                    )
                  ],
                ),
              ),
              GapWidget(),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: ColorConst.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorConst.greenBg,
                                  ),
                                  child: Icon(
                                    Icons.trending_up,
                                    color: ColorConst.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      NormalTextWidget(
                                        title: TextConst.income,
                                        size: 15,
                                        color: ColorConst.blackopacity,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: BoldTextWidget(
                                          title: formatCurrency(provider.totalIncome),
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            GapWidget(),
                            ContainerWidget(
                              bg: ColorConst.greenBg,
                              color: ColorConst.green,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: ColorConst.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorConst.dangerbg,
                                  ),
                                  child: Icon(
                                    Icons.trending_down,
                                    color: ColorConst.danger,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      NormalTextWidget(
                                        title: TextConst.expence,
                                        size: 15,
                                        color: ColorConst.blackopacity,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: BoldTextWidget(
                                          title: formatCurrency(provider.totalExpense),
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            GapWidget(),
                            ContainerWidget(
                              bg: ColorConst.dangerbg,
                              color: ColorConst.danger,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
