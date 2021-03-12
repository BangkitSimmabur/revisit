import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:revisit/constant.dart';

abstract class Styles {
  static TextStyle h1 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: Constant.MINIMUM_FONT_SIZE * 3,
  );
  static TextStyle h2 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: Constant.MINIMUM_FONT_SIZE * 2,
  );
  static TextStyle h3 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: Constant.MINIMUM_FONT_SIZE * 1.2,
  );
  static TextStyle inputCommon = TextStyle(color: Constant.GRAY_TEXT, fontSize: Constant.MINIMUM_FONT_SIZE);
  static TextStyle inputCommon2 = TextStyle(
      fontWeight: FontWeight.w500, fontSize: Constant.MINIMUM_FONT_SIZE * 1.2, color: Constant.GRAY_TEXT);
  static TextStyle navbarTextStyle = TextStyle(
//    color: Colors.white,
      color: Constant.GRAY_TEXT,
      fontSize: Constant.MINIMUM_FONT_SIZE_XS +2,
      fontWeight: FontWeight.w600
  );

  // Home Styles
  static TextStyle titleBarStyle = TextStyle(
    fontSize: Constant.MINIMUM_FONT_SIZE / 1.5,
    fontWeight: FontWeight.w700,
  );

  static TextStyle defaultTitleStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle defaultSubtitleStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: Constant.MINIMUM_FONT_SIZE / 1.3, color: Colors.black);

  static TextStyle defaultLabelAppbar = TextStyle(
      color: Colors.white, fontSize: Constant.MINIMUM_FONT_SIZE * 1.6, fontWeight: FontWeight.w800);

  static TextStyle h2Child = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: Constant.MINIMUM_FONT_SIZE * 1.6,
  );
}
