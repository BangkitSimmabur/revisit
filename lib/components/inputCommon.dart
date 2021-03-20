import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/type.dart';

class RevisitInputCommon extends StatefulWidget {
  final TextEditingController inputController;
  final String titleText;
  final Function onValidate;
  final bool obscureText;
  final TextInputType keyboardType;
  Color labelColor;
  final double labelSize;
  final FontWeight labelWeight;
  final int labelMaxLine;
  final int labelMinLine;
  final Function onSaved;
  final bool autoValidate;
  final Function onSubmit;
  final Key key;
  final int errorMaxlines;
  final bool enabled;
  final String hintText;
  final String prefixText;
  final int inputMaxLines;
  final bool noPadding;
  final int charMax;
  final FocusNode focusNode;
  final String initValue;
  final OnChangeStr onChange;
  final bool noLabel;
  final bool isDigitWhitelist;
  final bool isDense;
  final bool noFocus;
  final Function onTap;
  final bool noBorder;
  Color borderColor;
  final BorderRadius borderRadius;

  RevisitInputCommon(
    this.titleText, {
    this.key,
    this.inputController,
    this.onValidate,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.labelSize = Constant.MINIMUM_FONT_SIZE,
    this.labelWeight = FontWeight.w400,
    this.labelMaxLine = 1,
    this.labelMinLine = 1,
    this.onSaved,
    this.autoValidate = false,
    this.onSubmit,
    this.errorMaxlines = 1,
    this.enabled = true,
    this.hintText,
    this.prefixText = '',
    this.inputMaxLines,
    Color labelColor,
    this.noPadding = false,
    this.charMax,
    this.focusNode,
    this.initValue,
    this.onChange,
    this.noLabel = false,
    this.isDigitWhitelist = false,
    this.isDense = false,
    this.noFocus = false,
    this.onTap,
    this.noBorder = false,
    Color borderColor,
    this.borderRadius = BorderRadius.zero,
  }) {
    this.labelColor = labelColor != null ? labelColor : Constant.GRAY_TEXT;
    this.borderColor = borderColor != null ? borderColor : Constant.GRAY_TEXT;
  }

  @override
  State<StatefulWidget> createState() {
    return _RevisitInputCommonState();
  }
}

class _RevisitInputCommonState extends State<RevisitInputCommon> {
  List<TextInputFormatter> _inputFormatters = new List();
  String titleText;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    if (widget.charMax != null) {
      _inputFormatters.add(LengthLimitingTextInputFormatter(widget.charMax));
    }
    _textController = widget.inputController ?? TextEditingController();
    if (widget.initValue != null) {
      _textController.text = widget.initValue;
    }
    if (widget.isDigitWhitelist) {
      _inputFormatters.add(
        WhitelistingTextInputFormatter.digitsOnly,
      );
    }
  }

  @override
  void dispose() {
    if (widget.inputController == null) _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Constant.inputCommon.copyWith(
        color: this.widget.labelColor,
        fontSize: this.widget.labelSize,
        fontWeight: this.widget.labelWeight);
    var inputTextStyle = textStyle.copyWith(
        fontSize: this.widget.labelSize, fontWeight: FontWeight.w400);

    return Padding(
      padding: widget.noPadding
          ? EdgeInsets.all(0.0)
          : EdgeInsets.only(
              top: Constant.MINIMUM_SPACING,
              bottom: Constant.MINIMUM_SPACING,
              left: Constant.MINIMUM_PADDING_BUTTON,
              right: Constant.MINIMUM_PADDING_BUTTON,
            ),
      child: TextFormField(
        key: widget.key,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        controller: _textController,
        style: inputTextStyle,
        inputFormatters: _inputFormatters,
        maxLines: widget.labelMaxLine,
        minLines: widget.labelMinLine,
        validator: widget.onValidate,
        onSaved: widget.onSaved,
        autovalidate: widget.autoValidate,
        onFieldSubmitted: widget.onSubmit,
        onChanged: widget.onChange,
        onTap: widget.onTap,
        decoration: InputDecoration(
          focusColor: !widget.noFocus ? Colors.transparent : Constant.blue01,
          isDense: widget.isDense,
          labelText: !widget.noLabel ? titleText : null,
          labelStyle: textStyle,
          errorMaxLines: widget.errorMaxlines,
          hintText: widget.hintText,
          hintStyle: textStyle,
          prefixText: widget.prefixText,
          border: widget.noBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide.none, borderRadius: BorderRadius.zero)
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor,
                    width: Constant.MINIMUM_BORDER_WIDTH,
                  ),
                  borderRadius: widget.borderRadius,
                ),
          focusedBorder: widget.noBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide.none, borderRadius: BorderRadius.zero)
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constant.blue01,
                    width: Constant.MINIMUM_BORDER_WIDTH,
                  ),
                  borderRadius: widget.borderRadius,
                ),
        ),
      ),
    );
  }
}
