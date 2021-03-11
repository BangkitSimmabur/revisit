import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:revisit/components/button_common.dart';
import 'package:revisit/components/text_choose.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/service/navigation_service.dart';

import 'package:revisit/components/date_time_picker.dart';

class MainPlatform {
  static Widget transparentAppbar(
      BuildContext context, {
        Color leadingColor = Colors.white,
        Widget actionElement,
        bool showLeading = true,
      }) {
    var isLeadingVisible = Navigator.canPop(context);
    Widget leadingIcon = isLeadingVisible && showLeading
        ? Platform.isIOS
        ? GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Icon(
        IconData(
          0xF3CF,
          fontFamily: CupertinoIcons.iconFont,
          fontPackage: CupertinoIcons.iconFontPackage,
        ),
        color: leadingColor,
      ),
    )
        : GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Icon(
        Icons.arrow_back,
        color: leadingColor,
      ),
    )
        : Container();

    return Padding(
      padding: EdgeInsets.only(
        top: Constant.MINIMUM_PADDING_LG,
        bottom: Constant.MINIMUM_SPACING,
        left: Constant.MINIMUM_PADDING,
        right: Constant.MINIMUM_PADDING,
      ),
      child: Row(
        children: <Widget>[
          leadingIcon,
          Container(
            width: Constant.MINIMUM_SPACING,
          ),
          Expanded(
            child: actionElement,
          ),
        ],
      ),
    );
  }

  static dynamic transitionToPage(
      BuildContext context,
      dynamic destination, {
        String md: 'ios',
        bool newPage: false,
      }) {

    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (Platform.isAndroid && md != 'ios') {
      if (!newPage) {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => destination));
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => destination));
      }
    } else if (Platform.isIOS || md == 'ios') {
      if (!newPage) {
        return Navigator.push(
            context, CupertinoPageRoute(builder: (context) => destination));
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => destination));
      }
    }
  }

  static dynamic backTransitionPage(
      BuildContext context, {
        dynamic value,
      }) {
    try {
      Navigator.pop(context, value);
      return;
    } catch (e) {
      try {
        var locatorModel = GetIt.I<NavigationService>();
        Navigator.pop(locatorModel.navigatorKey?.currentContext, value);
      } catch (e) {}
      return;
    }
  }

  static Route routeAnimation(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Future<void> showAlert(
      BuildContext context,
      Widget titleWidget,
      Widget subtitleWidget,
      ) {
    if (context == null) return null;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: titleWidget,
            content: subtitleWidget,
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "Tutup",
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          )
              : AlertDialog(
            title: titleWidget,
            content: subtitleWidget,
            actions: <Widget>[
              RaisedButton(
                color: Constant.BLUE03,
                child: new Text(
                  "Tutup",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  static Future<ConfirmAction> showConfirmationAlert(
      BuildContext context,
      Widget titleWidget,
      Widget subtitleWidget, {
        Function onProceedClick,
        String infoLabel = 'Lanjutkan',
      }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: Padding(
              padding: EdgeInsets.only(
                bottom: Constant.MINIMUM_SPACING,
              ),
              child: titleWidget,
            ),
            content: subtitleWidget,
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "Tutup",
                ),
                onPressed: () => Navigator.pop(
                  context,
                  ConfirmAction.CANCEL,
                ),
              ),
              CupertinoDialogAction(
                child: Text(
                  infoLabel ?? 'Lanjutkan',
                ),
                onPressed: () => Navigator.pop(
                  context,
                  ConfirmAction.ACCEPT,
                ),
              ),
            ],
          )
              : AlertDialog(
            title: titleWidget,
            content: subtitleWidget,
            actions: <Widget>[
              TruWorldButtonCommon(
                'Tutup',
                labelColor: Constant.BLUE03,
                color: Colors.white,
                onPress: () => Navigator.pop(
                  context,
                  ConfirmAction.CANCEL,
                ),
              ),
              TruWorldButtonCommon(
                'Lanjutkan',
                labelColor: Colors.white,
                color: Constant.BLUE03,
                onPress: () => Navigator.pop(
                  context,
                  ConfirmAction.ACCEPT,
                ),
              ),
            ],
          );
        });
  }

  static Future<void> showLoadingAlert(
      BuildContext context,
      String textInfo, {
        bool isShowed = true,
      }) {
    if (isShowed) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Platform.isIOS
                ? CupertinoAlertDialog(
              title: CupertinoActivityIndicator(),
              content: Text(
                textInfo,
              ),
            )
                : AlertDialog(
              title: SpinKitFadingCircle(
                color: Constant.BLUE02,
                size: Constant.BUTTON_WIDTH,
              ),
              content: Text(
                textInfo,
              ),
            );
          });
    }

    Navigator.pop(context);
    return null;
  }

  static Future<ImageSource> asyncShowAlertSelectImage(
      BuildContext context) async {
    Widget _alertAction;

    // Android version
    if (Platform.isAndroid) {
      List<DialogMethodProfileItems> dialogItems = List();

      DialogMethodProfileItems cameraItem = DialogMethodProfileItems(
          'Kamera',
          Icons.camera,
          ImageSource.camera,
          Constant.green01);
      dialogItems.add(cameraItem);

      DialogMethodProfileItems galleryItem = DialogMethodProfileItems(
          'Galeri',
          Icons.image,
          ImageSource.gallery,
          Constant.BLUE02);
      dialogItems.add(galleryItem);

      List<Widget> simpleDialogItems = List();
      for (var item in dialogItems) {
        simpleDialogItems.add(SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, item.source);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                item.icon,
                size: Constant.MINIMUM_FONT_SIZE * 2,
                color: item.color,
              ),
              Container(
                width: Constant.MINIMUM_SPACING_LG,
              ),
              Flexible(
                child: Text(
                  item.label,
                  style: TextStyle(
                      fontSize: Constant.MINIMUM_FONT_SIZE * 1.2,
                      fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ));

        simpleDialogItems.add(Padding(
          padding: EdgeInsets.only(
              top: Constant.MINIMUM_PADDING / 3, bottom: Constant.MINIMUM_PADDING / 3),
          child: Container(
            height: 0.5,
            color: Colors.grey,
          ),
        ));
      }
      _alertAction = SimpleDialog(
        title: Text(
          'Dari',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Constant.MINIMUM_FONT_SIZE * 1.5),
        ),
        children: simpleDialogItems,
      );
    } else if (Platform.isIOS) {
      CupertinoActionSheetAction cameraActionSheet = CupertinoActionSheetAction(
        child: Row(
          children: <Widget>[
            Icon(IconData(0xF2D3,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage)),
            Container(
              width: Constant.MINIMUM_SPACING_MD,
            ),
            Text(
              "Kamera",
            )
          ],
        ),
        onPressed: () {
          Navigator.pop(context, ImageSource.camera);
        },
      );
      CupertinoActionSheetAction galleryActionSheet =
      CupertinoActionSheetAction(
        child: Row(
          children: <Widget>[
            Icon(IconData(0xF2E4,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage)),
            Container(
              width: Constant.MINIMUM_SPACING_MD,
            ),
            Text(
              'Galeri',
            )
          ],
        ),
        onPressed: () {
          Navigator.pop(context, ImageSource.gallery);
        },
      );
      _alertAction = CupertinoActionSheet(
        title: Text('Dari',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: Constant.MINIMUM_FONT_SIZE * 1.5)),
        actions: <Widget>[cameraActionSheet, galleryActionSheet],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text('Cancel'),
          isDefaultAction: true,
        ),
      );
    }

    return await showDialog<ImageSource>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _alertAction;
      },
    );
  }

  static Future showSuccessSnackbar(
      BuildContext context,
      String content, ) async {
    String label = content;

    Flushbar(
      message: label,
      duration: Constant.DEFAULT_DURATION_SNACKBAR["duration"],
      animationDuration: Constant.DEFAULT_DURATION_SNACKBAR["animationDuration"],
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      icon: Icon(
        Icons.done,
        color: Colors.white,
      ),
    )..show(context);
  }

  static Future<void> showErrorSnackbar(
      BuildContext context,
      String content) async {
    if (content == null || content.isEmpty) return;

    String label = content;

    if (label.contains("input:")) {
      int i = label.indexOf(':');
      label = label.substring(i + 2);
      if (label.contains(":")) {
        int j = label.indexOf(':');
        label = label.substring(j + 2);
      }
    }

    return Flushbar(
      message: label,
      duration: Constant.DEFAULT_DURATION_SNACKBAR["duration"],
      animationDuration: Constant.DEFAULT_DURATION_SNACKBAR["animationDuration"],
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.GROUNDED,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
    )..show(context);
  }

  static Flushbar showFloatingSnackbar(
      BuildContext context,
      String content, {
        Color color,
        FlushbarPosition position = FlushbarPosition.BOTTOM,
        IconData iconData = Icons.info,
        mainText = 'placeholder_btn_close',
        Function(Flushbar<Object>) onTap,
      }) {
    if (context == null) return null;

    var _locatorModel = GetIt.I<NavigationService>();
    if (_locatorModel.flushbarNavigator != null &&
        _locatorModel.flushbarNavigator.isShowing())
      _locatorModel.flushbarNavigator.dismiss();

    if (content.contains("input:")) {
      var i = content.indexOf(':');
      content = content.substring(i + 2);
      if (content.contains(":")) {
        var j = content.indexOf(':');
        content = content.substring(j + 2);
      }
    }

    Flushbar flush;
    var label = content;

    flush = Flushbar(
      duration: Duration(seconds: 5),
      message: label,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: position,
      animationDuration: Constant.DEFAULT_DURATION_SNACKBAR["animationDuration"],
      margin: EdgeInsets.all(
        Constant.DEFAULT_PADDING_VIEW,
      ),
      borderRadius: Constant.MINIMUM_BORDER_RADIUS_MD,
      onTap: onTap,
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      mainButton: FlatButton(
        onPressed: () {
          flush.dismiss(true);
        },
        child: Text(
          mainText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    )..show(context);
    _locatorModel.flushbarNavigator = flush;

    return flush;
  }

  static PersistentBottomSheetController showBottomSheet(
      BuildContext context, Widget childElement) {
    PersistentBottomSheetController controller;
    controller =
        Scaffold.of(context).showBottomSheet<Null>((BuildContext context) {
          return Container(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: Constant.MINIMUM_SPACING / 2,
                  left: MediaQuery.of(context).size.width / 3.2,
                  child: GestureDetector(
                    onTap: () {
                      controller.close();
                    },
                    child: Container(
                      height: Constant.MINIMUM_PADDING_BUTTON,
                      width: Constant.WIDTH_XLG,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      try {
                        controller.close();
                      } catch (e) {}
                    },
                    child: Icon(
                      Icons.close,
                      size: Constant.MINIMUM_FONT_SIZE * 1.8,
                      color: Constant.GRAY_TEXT,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: Constant.MINIMUM_SPACING_XLG,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                            child: SingleChildScrollView(
                              child: Container(
                                child: childElement,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });

    return controller;
  }

  static Future<dynamic> showAlertOptions(
      BuildContext context,
      String title,
      List<Map<String, String>> options, {
        Color btnColor,
        Color labelColor = Colors.white,
      }) async {
    var textElements = options
        .map(
          (e) => TruWorldButtonCommon(
        e['label'],
        btnWidth: double.maxFinite,
        labelColor: labelColor,
        borderRadius: Constant.MINIMUM_BORDER_RADIUS_LG,
        onPress: () => backTransitionPage(context, value: e['value']),
      ),
    )
        .toList();

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(
                fontSize: Constant.MINIMUM_FONT_SIZE,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: textElements,
            ),
          )
              : AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                fontSize: Constant.MINIMUM_FONT_SIZE,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: textElements,
            ),
          );
        });
  }

  static void showDateTimePicker(
      BuildContext context,
      SavedDateTime onChanged, {
        bool onlyDate = false,
        DateTime initDateTime,
      }) async {
    const double _kPickerSheetHeight = 216.0;

    DateTime _dateTimeSelected;
    DateTime _fromDate;
    TimeOfDay _fromTime;
    if (initDateTime != null) {
      _dateTimeSelected = initDateTime;
      _fromDate = initDateTime;
      _fromTime = TimeOfDay(hour: _fromDate.hour, minute: _fromDate.minute);
    } else {
      // dummy
      _fromDate = DateTime.now();
      _fromTime = const TimeOfDay(hour: 7, minute: 0);
      _dateTimeSelected = DateTime(
        _fromDate.year,
        _fromDate.month,
        _fromDate.day,
        _fromTime.hour,
        _fromTime.minute,
      );
    }

    Widget _buildBottomPicker(Widget picker) {
      return Container(
        height: _kPickerSheetHeight,
        padding: const EdgeInsets.only(top: 6.0),
        color: CupertinoColors.white,
        child: DefaultTextStyle(
          style: const TextStyle(
            color: CupertinoColors.black,
            fontSize: 22.0,
          ),
          child: GestureDetector(
            onTap: () {},
            child: SafeArea(
              top: false,
              child: picker,
            ),
          ),
        ),
      );
    }

    if (onlyDate) {
      if (Platform.isIOS) {
        return await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
              CupertinoDatePicker(
                mode: onlyDate
                    ? CupertinoDatePickerMode.date
                    : CupertinoDatePickerMode.dateAndTime,
                initialDateTime: _fromDate,
                onDateTimeChanged: onChanged,
              ),
            );
          },
        );
      }

      var picked = await showDatePicker(
        context: context,
        initialDate: _fromDate,
        firstDate: Constant.FIRST_DATE,
        lastDate: Constant.LAST_DATE,
      );
      onChanged(picked);
      return;
    }

    Platform.isIOS
        ? await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return _buildBottomPicker(
          CupertinoDatePicker(
            mode: onlyDate
                ? CupertinoDatePickerMode.date
                : CupertinoDatePickerMode.dateAndTime,
            initialDateTime: _fromDate,
            onDateTimeChanged: onChanged,
          ),
        );
      },
    )
        : await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pilih tanggal',
          ),
          content: DateTimePicker(
            onlyDate: onlyDate,
            selectedDate: _fromDate,
            selectedTime: _fromTime,
            savedDateTime: (DateTime dateTime) {
              _dateTimeSelected = dateTime;
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Batalkan",
                style: TextStyle(
                  color: Constant.BLUE03,
                  fontSize: Constant.MINIMUM_FONT_SIZE * 1.2,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Text(
                "Batalkan",
                style: TextStyle(
                  color: Constant.BLUE03,
                  fontSize: Constant.MINIMUM_FONT_SIZE * 1.2,
                ),
              ),
              onPressed: () {
                onChanged(_dateTimeSelected);
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            ),
          ],
        );
      },
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

enum CodeSelection { Country, Currency }

typedef void SavedDateTime(DateTime dateTime);

typedef void OnSavedStr(String str);

class DialogMethodProfileItems {
  String _label;
  IconData _icon;
  ImageSource _source;
  Color _color;

  set label(String newLabel) {
    this._label = newLabel;
  }

  set icon(IconData newIcon) {
    this._icon = newIcon;
  }

  set source(ImageSource source) {
    this._source = source;
  }

  set color(Color newColor) {
    this._color = newColor;
  }

  get label => _label;

  get icon => _icon;

  get source => _source;

  get color => _color;

  DialogMethodProfileItems(this._label, this._icon, this._source, this._color);
}
