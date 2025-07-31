import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/shared/widgets/normal_text_widget.dart';
import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final Color bg;
  final Color color;
  const ContainerWidget({super.key,required this.bg,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
              width: 90,
              decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(15)
            ),
              child: Center(child: NormalTextWidget(title: TextConst.thisMonth, size: 15, color: color)));
  }
}