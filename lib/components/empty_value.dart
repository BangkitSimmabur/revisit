import 'package:flutter/material.dart';
import 'package:revisit/constant.dart';


class RevisitEmptyValues extends StatelessWidget {
  final String _assetSrc;
  final String text;

  final double assetSize;
  final Color textColor;
  final FontWeight textWeight;
  final double textSize;
  final FontStyle textStyle;

  RevisitEmptyValues(
      this._assetSrc, {
        this.text = '',
        this.assetSize = Constant.DEFAULT_VECTOR_SIZE,
        this.textColor = Colors.black87,
        this.textWeight = FontWeight.w600,
        this.textSize = Constant.MINIMUM_FONT_SIZE,
        this.textStyle = FontStyle.italic,
      });

  @override
  Widget build(BuildContext context) {
    String _textStr = text;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          _assetSrc,
          height: assetSize,
        ),
        Container(
          height: Constant.MINIMUM_SPACING_SM,
        ),
        Text(
          _textStr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontWeight: textWeight,
            fontStyle: textStyle,
          ),
        ),
      ],
    );
  }
}
