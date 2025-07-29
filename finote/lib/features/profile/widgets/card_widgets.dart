import 'package:finote/core/constants/color_const.dart';
import 'package:flutter/material.dart';

class CardWidgets extends StatelessWidget {
  final String title;
  final Color bg;
  final Color color;
  final String data;
  final IconData icon;
  const CardWidgets({super.key, required this.title, required this.bg,required this.color,required this.data,required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
                elevation: 2,
                color: ColorConst.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: color,),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title),
                        Text(data,style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    )
                  ],
                ),
              );
  }
}