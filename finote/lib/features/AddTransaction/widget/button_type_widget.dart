import 'package:finote/core/constants/color_const.dart';
import 'package:flutter/material.dart';

class ButtonTypeWidet extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  const ButtonTypeWidet({
    super.key,required this.label,
      required this.isSelected,
      required this.onTap,
      required this.color
      });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? color : ColorConst.greyopacity,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? ColorConst.white : ColorConst.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}