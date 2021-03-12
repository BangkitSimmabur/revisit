import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:revisit/constant.dart';

class RevisitButtonFull extends StatefulWidget {
  final String labelText;
  Color labelColor;
  final double labelSize;
  Color buttonColor;
  final Function onClick;
  final GlobalKey key;
  final double borderRadius;
  final bool isIntl;
  final bool isLoading;
  final double width;
  final double padding;
  final bool active;
  final int maxLines;
  final double height;
  BorderSide btnBorderSide;
  Border btnBorder;
  final Color buttonDisabledColor;
  final FontWeight labelWeight;
  final TextOverflow textOverflow;

  RevisitButtonFull(
      this.labelText, {
        this.buttonColor,
        this.labelColor,
        this.labelSize = Constant.MINIMUM_FONT_SIZE * 1.5,
        this.onClick,
        this.borderRadius = 10.0,
        this.isIntl = false,
        this.isLoading = false,
        this.width = double.maxFinite,
        this.padding = Constant.MINIMUM_PADDING_BUTTON,
        this.active = false,
        this.key,
        this.buttonDisabledColor = Colors.lightBlueAccent,
        this.labelWeight = FontWeight.w600,
        this.maxLines,
        this.textOverflow: TextOverflow.ellipsis,
        this.height
      }) {
    var btnColor = this.active ? Colors.white : Colors.black;
    this.buttonColor = this.buttonColor ?? btnColor;
    var labelColor = this.active ? Colors.blue.shade700 : Colors.white;
    this.labelColor = this.labelColor ?? labelColor;

    btnBorderSide = this.active
        ? BorderSide(color: this.labelColor, width: Constant.MINIMUM_BORDER_WIDTH)
        : BorderSide(width: 0.0, color: Colors.transparent);
    btnBorder = this.active
        ? Border.fromBorderSide(
      btnBorderSide,
    )
        : null;
  }

  @override
  State<StatefulWidget> createState() {
    return _RevisitButtonFullState();
  }
}

class _RevisitButtonFullState extends State<RevisitButtonFull> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Container(
        child: MaterialButton(
          height: widget.height,
          key: widget.key,
          onPressed: !widget.isLoading ? widget.onClick : null,
          color: widget.active ? Colors.white : widget.buttonColor,
          disabledColor: widget.buttonDisabledColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side: widget.btnBorderSide,
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: widget.padding,
              bottom: widget.padding,
            ),
            child: widget.isLoading
                ? Stack(
              children: <Widget>[
                SpinKitThreeBounce(
                  color: widget.labelColor,
                  size: widget.labelSize,
                ),
                Text(
                  "",
                  style: TextStyle(
                    fontWeight: widget.labelWeight,
                    fontSize: widget.labelSize,
                    color: widget.labelColor,
                  ),
                )
              ],
            )
                : Text(
              widget.labelText,
              overflow: widget.textOverflow,
              maxLines: widget.maxLines,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: widget.labelWeight,
                fontSize: widget.labelSize,
                color: widget.labelColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
