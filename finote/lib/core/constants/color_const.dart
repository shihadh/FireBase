import 'package:flutter/material.dart';

class ColorConst {
  //  Base Theme Colors
  static const Color backgroundColor = Color(0xFFF6F6F6);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color blackopacity = Colors.black54;
  static const Color transparent = Colors.transparent;

  //  Alerts & Status
  static const Color danger = Color.fromARGB(255, 255, 88, 76);
  static final Color success = const Color.fromARGB(194, 0, 232, 108);
  static const Color dangerbg = Color.fromARGB(255, 254, 242, 242);

  //  Neutral / Greys
  static final Color grey = Colors.grey.shade500;
  static final Color greyopacity = Colors.grey.shade400;

  //  Positive Accent
  static final Color green = Colors.green.shade700;

  //  Business / Themed Backgrounds
  static final Color premiumBg = const Color.fromARGB(255, 79, 63, 41);
  static final Color premium = const Color.fromARGB(255, 247, 236, 193);

  static final Color blueBg = const Color.fromARGB(255, 239, 246, 255);
  static final Color greenBg = const Color.fromARGB(255, 236, 253, 245);

  //  Accents
  static const Color blueAccent = Colors.blueAccent;
}
