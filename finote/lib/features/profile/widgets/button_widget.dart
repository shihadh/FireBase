import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/shared/widgets/normal_text_widget.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color iconColor;
  final VoidCallback funtion;
  const ButtonWidget({super.key,required this.icon, required this.title,required this.color,required this.iconColor,required this.funtion});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width, 50)),
                  elevation: WidgetStatePropertyAll(2),
                  backgroundColor: WidgetStatePropertyAll(ColorConst.white)),
                onPressed: (){
                  funtion();
                }, label: NormalTextWidget(title: title, size: 15, color: color),icon: Icon(icon,color: iconColor,),
                );
  }
}