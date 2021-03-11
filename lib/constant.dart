import 'dart:io';

import 'package:flutter/material.dart';

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

  //padding
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


}