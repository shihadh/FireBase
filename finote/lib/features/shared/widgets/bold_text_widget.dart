import 'package:finote/core/constants/color_const.dart';
import 'package:flutter/material.dart';

class BoldTextWidget extends StatelessWidget {
  final  String title;
  final  double size;
  const BoldTextWidget({super.key,required this.title,required this.size,});

  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(color: ColorConst.black,fontSize: size, fontWeight: FontWeight.bold));

  }
}