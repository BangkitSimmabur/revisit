import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

enum ItemAction { create, update }

class Constant{
  //border
  static const double MINIMUM_BORDER_RADIUS = 8.0;
  static const double MINIMUM_BORDER_RADIUS_MD = 16.0;
  static const double MINIMUM_BORDER_RADIUS_LG = 28.0;
  static const double MINIMUM_BORDER_WIDTH_XS = 1.0;
  static const double MINIMUM_BORDER_WIDTH = 2.0;
  static const double MINIMUM_DIVIDER_WIDTH = 0.5;

  //font
  static const double MINIMUM_FONT_SIZE_XS = 12.0;
  static const double MINIMUM_FONT_SIZE = 16.0;
  static const double MINIMUM_FONT_SIZE_SM = 22.0;
  static const double MINIMUM_FONT_SIZE_MD = 30.0;

  //elevation
  static const double MINIMUM_ELEVATION = 2.0;
  static const double MINIMUM_ELEVATION_MD = 7.2;

  //color
  static final Color blue01 = Color(0xff3D5AFE);
  static final Color red01 = Colors.red.shade500;
  static final Color red025 = Colors.redAccent.shade200;
  static final Color pink01 = Color(0xffff4081);
  static final Color green01 = Colors.green.shade300;
  static final Color green02 = Colors.green.shade700;
  static final Color BLUE05 = Colors.blue.shade800;
  static final Color BLUE02 = Colors.blue.shade400;
  static final Color BLUE03 = Color(0xff0080ff);
  static final Color BLUE025 = Colors.blue.shade200;
  static final Color GRAY01 = Colors.grey.shade700;
  static final Color GRAY02 = Color(0xffd6d6d6);
  static final Color GRAY_TEXT = Color(0xff595959);
  static final Color GRAY_TEXT2 = Color(0xffa7a8aa);
  static final Color GRAY_TEXT3 = Color(0xffacabab);
  static final Color GRAY_BACKGROUND = Color(0xfff4f2f2);
  static final Color GRAY_BACKGROUND_2 = Color(0xfff9f9f9);
  static final Color GRAY_BACKGROUND_3 = Color(0xfff8f6f7);
  static final Color GRAY_BACKGROUND_4 = Color(0xffedf0f2);
  static final Color GRAY_BACKGROUND_5 = Color(0xffdfe7f0);
  static final Color GRAY_BACKGROUND_6 = Color(0xffe8ebed);
  static final Color GRAY_BACKGROUND_7 = Color(0xfff8f6f6);
  static final Color GRAY_BORDER = Color(0xffdadada);
  static final Color GRAY_Underline = Color(0xffefefef);
  static final Color GRAY025 = Colors.grey.shade100;
  static final Color YELLOW01 = Colors.yellow.shade600;
  static const Color YELLOW02 = Color(0xfffce712);
  static final Color BG_OPACITY = Colors.black.withOpacity(0.15);
  static final Color INACTIVE_TEXT = Color(0xffc2c2c2);

  // SPACING
  static double MINIMUM_SPACING = Platform.isIOS ? 8.0 : 5.0;
  static const double MINIMUM_SPACING_MD = 13.0;
  static const double MINIMUM_SPACING_LG = 21.0;
  static const double MINIMUM_SPACING_XLG = 30.0;

  // SIZE
  static const double ICON_WIDTH_SM = 16.0;
  static const double ICON_WIDTH = 20.0;
  static const double ICON_WIDTH_MD = 28.0;
  static const double ICON_WIDTH_LG = 50.0;
  static const double ICON_WIDTH_XLG = 80.0;
  static const double SOCIAL_BUTTON = 34.0;
  static const double SEARCHBAR_HEIGHT = 45.0;
  static const double BUTTON_WIDTH = 50;
  static const double CATEGORY_BUTTON_WIDTH = 75.0;
  static const double VENDOR_ITEM_HEIGHT = 80.0;
  static const double BANNER_HEIGHT = 110.0;
  static const double BANNER_HEIGHT_MD = 200.0;
  static const double BANNER_HEIGHT_LG = 240.0;
  static const double CAROUSEL_ITEM_HEIGHT = 160.0;
  static const double PHOTO_HEIGHT = 50.0;

  static const double WIDTH_XXLG = 180.0;
  static const double WIDTH_XLG = 120.0;
  static const double WIDTH_LG = 90.0;
  static const double WIDTH_MD = 75.0;

  static const double HEIGHT_XXLG = 420;
  static const double HEIGHT_XLG = 380;
  static const double HEIGHT_LG = 260;
  static const double HEIGHT_MD = 65.0;
  static const double HEIGHT_SM = 30.0;
  static const double HEIGHT_XXSM = 3.2;

  static const double INPUT_HEIGHT = 50;
  static const double INPUT_HEIGHT_BUTTON = 40;

  // PADDING
  static const double DEFAULT_PADDING_MD = 50;
  static const double DEFAULT_PADDING_SM = 20;
  static const double MINIMUM_PADDING_SM = 12;
  static const double MINIMUM_PADDING = 16;
  static const double MINIMUM_PADDING_MD = 28.0;
  static const double MINIMUM_PADDING_LG = 40.0;
  static const double MINIMUM_PADDING_XLG = 56.0;
  static const double MINIMUM_PADDING_BUTTON_MD = 14.0;
  static const double MINIMUM_PADDING_BUTTON = 8.0;
  static double DEFAULT_PADDING_VIEW = Platform.isAndroid ? 10.0 : 15.0;
  static const EdgeInsets DEFAULT_PADDING_CONTENT_XS =
  EdgeInsets.only(top: 2.0, bottom: 2.0);
  static const EdgeInsets DEFAULT_PADDING_CONTENT_SM =
  EdgeInsets.only(top: 5.0, bottom: 5.0);
  static const EdgeInsets DEFAULT_PADDING_CONTENT_MD =
  EdgeInsets.only(top: 13.0, bottom: 13.0);
  static const EdgeInsets DEFAULT_PADDING_CONTENT_XLG =
  EdgeInsets.only(
      left: 20,
      right: 20,
      top: 30,
      bottom: 30
  );
  static const EdgeInsets DEFAULT_PADDING_CONTENT_LG =
  EdgeInsets.only(
      left: 10,
      right: 10,
      top: 15,
      bottom: 15
  );
  static EdgeInsets DEFAULT_PADDING_COMPONENT = EdgeInsets.only(
    top: Constant.MINIMUM_SPACING,
    bottom: Constant.MINIMUM_SPACING,
    left: Constant.MINIMUM_PADDING_BUTTON,
    right: Constant.MINIMUM_PADDING_BUTTON,
  );
  static const EdgeInsets DEFAULT_PADDING_PAGE = EdgeInsets.symmetric(
    horizontal: MINIMUM_SPACING_MD,
    vertical: MINIMUM_SPACING_MD / 1.6,
  );

  static TextStyle inputCommon = TextStyle(color: Colors.grey, fontSize: Constant.MINIMUM_FONT_SIZE);

  static DateTime FIRST_DATE = DateTime(1960, 1, 1);
  static DateTime LAST_DATE = DateTime(2100, 1, 1);

  //duration
  static const double DEFAULT_ZOOM_MAP = 14.0;
  static const double DEFAULT_OPACITY_CUPERTINO_BUTTON = 0.4;
  static const Map<String, Duration> DEFAULT_DURATION_SNACKBAR = {
    "duration": Duration(seconds: 5),
    "animationDuration": Duration(milliseconds: 200),
  };
  static const FAST_DURATION = Duration(milliseconds: 100);
  static Position INIT_LOCATION = Position(
    latitude: 1.1848958,
    longitude: 104.1117605,
  );
  static const String ID_LOCATION_NOW = 'Your Location';
  static const DIGITS = [0, 1, 2, 3, 4, 6, 7, 8, 9];

  //app bar key
  static final List<String> KEY_TAB_APPBAR = [
    "key_tab_appbar_article",
    "key_tab_appbar_story",
    "key_tab_appbar_profile",
  ];

}