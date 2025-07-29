import 'package:flutter/material.dart';

class NormalTextWidget extends StatelessWidget {
  final  String title;
  final  double size;
  final  Color color;

  const NormalTextWidget({super.key,required this.title,required this.size,required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(color: color,fontSize: size));
  }
}