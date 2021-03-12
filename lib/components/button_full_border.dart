import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:revisit/constant.dart';

class RevisitButtonFullBordered extends StatefulWidget {
  final String labelText;
  Color labelColor;
  final double labelSize;
  Color buttonColor;
  final Function onClick;
  final GlobalKey key;
  final double borderRadius;
  final bool isLoading;
  final double width;
  final double padding;
  final bool active;
  final int maxLines;
  final double height;
  final BorderSide btnBorderSide;
  // Border btnBorder;
  final FontWeight labelWeight;
  final TextOverflow textOverflow;

  RevisitButtonFullBordered(
      this.labelText, {
        this.buttonColor,
        this.labelColor,
        this.labelSize = Constant.MINIMUM_FONT_SIZE * 1.5,
        this.onClick,
        this.borderRadius = 10.0,
        this.isLoading = false,
        this.width = double.maxFinite,
        this.padding = Constant.MINIMUM_PADDING_BUTTON,
        this.active = false,
        this.key,
        this.labelWeight = FontWeight.w600,
        this.maxLines,
        this.textOverflow: TextOverflow.ellipsis,
        this.height,
        this.btnBorderSide,
      }) {
    var btnColor = this.active ? Colors.white : Colors.black;
    this.buttonColor = this.buttonColor ?? btnColor;
    // var brdrColor = this.active ? Colors.white : Colors.black;
    // this.borderColor = this.borderColor ?? brdrColor;
    var labelColor = this.active ? Colors.blue.shade700 : Colors.white;
    this.labelColor = this.labelColor ?? labelColor;

    // var buttonBorderSide = this.btnBorderSide = this.active
    //     ? BorderSide(color: this.labelColor, width: Constant.MINIMUM_BORDER_WIDTH)
    //     : BorderSide(width: 0.0, color: Colors.transparent);
    // this.btnBorderSide = this.btnBorderSide ?? buttonBorderSide;
    // var buttonBorder = this.btnBorder = this.active
    //     ? Border.fromBorderSide(
    //   btnBorderSide,
    // )
    //     : null;
    // this.btnBorder = this.btnBorder ?? buttonBorder;
  }

  @override
  State<StatefulWidget> createState() {
    return _RevisitButtonFullBorderedState();
  }
}

class _RevisitButtonFullBorderedState extends State<RevisitButtonFullBordered> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Container(
        child: OutlinedButton(
          key: widget.key,
          onPressed: !widget.isLoading ? widget.onClick : null,
          style: OutlinedButton.styleFrom(
            backgroundColor: widget.active ? Colors.white : widget.buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
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
