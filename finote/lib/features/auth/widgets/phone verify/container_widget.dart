import 'package:finote/core/constants/color_const.dart';
import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: ColorConst.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.call,
                    color: ColorConst.white,
                    size: 40,
                  ),
                );
  }
}