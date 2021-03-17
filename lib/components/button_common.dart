import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import "package:revisit/constant.dart";

class RevisitButtonCommon extends StatefulWidget {
  final String labelText;
  final Color labelColor;
  final double labelSize;
  final FontWeight labelWeight;
  final Function onPress;
  final Color color;
  final double borderRadius;
  final bool active;
  final double dividedPadding;
  final double btnWidth;
  final double borderWidth;
  final Color borderColor;
  final bool noHorizontalPadding;
  final Widget extraWidget;

  RevisitButtonCommon(
      this.labelText, {
        this.onPress = _defaultBtnCommonPressed,
        this.labelColor,
        this.labelWeight = FontWeight.w600,
        this.labelSize = Constant.MINIMUM_FONT_SIZE,
        this.color = Colors.white,
        this.borderRadius = Constant.MINIMUM_BORDER_RADIUS,
        this.active = false,
        this.btnWidth,
        this.borderColor = Colors.black26,
        this.borderWidth = 0.5,
        this.dividedPadding,
        this.noHorizontalPadding = false,
        this.extraWidget,
      });

  @override
  State<StatefulWidget> createState() {
    return _RevisitButtonCommonState();
  }
}

class _RevisitButtonCommonState extends State<RevisitButtonCommon> {
  String textLabel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textLabel = this.widget.labelText;
  }

  BorderSide get _borderSide {
    BorderSide btnBorderSide;
    if (widget.active) {
      btnBorderSide =
          BorderSide(color: widget.borderColor, width: Constant.MINIMUM_BORDER_WIDTH);
    } else {
      btnBorderSide = Platform.isAndroid
          ? BorderSide(color: Colors.transparent)
          : widget.color == Colors.transparent || widget.color == Colors.white
          ? BorderSide(
        color: widget.borderColor,
        width: widget.borderWidth,
      )
          : BorderSide(color: Colors.transparent, width: 0);
    }
    return btnBorderSide;
  }

  @override
  Widget build(BuildContext context) {
    Color labelColor;
    var defaultDividedPadding = Platform.isIOS ? 1.6 : 1;
    var dividedPadding =
        widget.dividedPadding ?? defaultDividedPadding.toDouble();
    if (widget.active)
      labelColor = widget.labelColor ?? Colors.blue.shade800;
    else
      labelColor = widget.labelColor ?? Colors.black87;

    return Platform.isIOS
        ? Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: MaterialButton(
        elevation: 0.0,
        color: widget.color,
        disabledColor: Constant.GRAY02,
        onPressed: widget.onPress,
        padding: !widget.noHorizontalPadding
            ? EdgeInsets.only(
          top: Constant.MINIMUM_PADDING_BUTTON / dividedPadding,
          bottom: Constant.MINIMUM_PADDING_BUTTON / dividedPadding,
          left: Constant.MINIMUM_PADDING_BUTTON * 1.5 / dividedPadding,
          right: Constant.MINIMUM_PADDING_BUTTON * 1.5 / dividedPadding,
        )
            : EdgeInsets.only(
          top: Constant.MINIMUM_PADDING_BUTTON / dividedPadding,
          bottom: Constant.MINIMUM_PADDING_BUTTON / dividedPadding,
        ),
        shape: RoundedRectangleBorder(
          side: _borderSide,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Container(
          width: widget.btnWidth,
          child: widget.extraWidget == null ? Text(
            textLabel,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: labelColor,
              fontWeight: widget.labelWeight,
              fontSize: widget.labelSize,
            ),
          ) : Row(
            children: <Widget>[
              Text(
                textLabel,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: labelColor,
                  fontWeight: widget.labelWeight,
                  fontSize: widget.labelSize,
                ),
              ),
              widget.extraWidget != null ? widget.extraWidget : Container(),
            ],
          ),
        ),
      ),
    )
        : Container(
      width: widget.btnWidth,
      child: RaisedButton(
        onPressed: widget.onPress,
        color: widget.color,
        shape: RoundedRectangleBorder(
            side: _borderSide,
            borderRadius:
            BorderRadius.circular(this.widget.borderRadius / 1.2)),
        child: Padding(
          padding: !widget.noHorizontalPadding
              ? EdgeInsets.only(
            top: Constant.MINIMUM_PADDING_BUTTON / dividedPadding,
            bottom: Constant.MINIMUM_PADDING_BUTTON / dividedPadding,
            left: Constant.MINIMUM_PADDING_BUTTON * 1.5 / dividedPadding,
            right: Constant.MINIMUM_PADDING_BUTTON * 1.5 / dividedPadding,
          )
              : EdgeInsets.only(
            top: Constant.MINIMUM_PADDING_BUTTON / dividedPadding,
            bottom: Constant.MINIMUM_PADDING_BUTTON / dividedPadding,
          ),
          child: widget.extraWidget == null ? Text(
            textLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: labelColor,
              fontSize: this.widget.labelSize,
              fontWeight: this.widget.labelWeight,
            ),
          ) : Row(
            children: <Widget>[
              Text(
                textLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: labelColor,
                  fontSize: this.widget.labelSize,
                  fontWeight: this.widget.labelWeight,
                ),
              ),
              widget.extraWidget != null ? widget.extraWidget : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

void _defaultBtnCommonPressed() {}
