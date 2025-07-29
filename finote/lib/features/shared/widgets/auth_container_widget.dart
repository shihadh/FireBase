import 'package:flutter/material.dart';

class AuthContainerWidget extends StatelessWidget {
  final String path;
  final VoidCallback function;
  const AuthContainerWidget({super.key, required this.path,required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(path)),
        ),
      ),
    );
  }
}
