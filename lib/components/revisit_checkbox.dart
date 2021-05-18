import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:revisit/constant.dart';

enum ItemPosition { left, right }

class RevisitCheckbox extends StatefulWidget {
  final String labelText;
  final Function onChecked;
  final bool isChecked;
  final bool isIntl;
  final ItemPosition checkboxPosition;
  final Color labelColor;
  final double labelSize;
  final FontWeight labelWeight;

  final Color buttonColor;
  final Color bgColor;
  final Color checkColor;

  RevisitCheckbox(
      this.labelText, {
        this.onChecked = _defaultBtnChecked,
        this.isChecked = false,
        this.isIntl = false,
        this.checkboxPosition = ItemPosition.left,
        this.labelSize = Constant.MINIMUM_FONT_SIZE,
        this.labelWeight = FontWeight.w400,
        this.labelColor,
        this.buttonColor,
        this.bgColor = Colors.transparent,
        this.checkColor = Colors.white,
      });

  @override
  State<StatefulWidget> createState() {
    return _RevisitCheckboxState();
  }
}

class _RevisitCheckboxState extends State<RevisitCheckbox> {
  String textLabel;
  bool _isChecked;
  Color _labelColor;
  Color _buttonColor;

  @override
  void initState() {
    super.initState();

    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(RevisitCheckbox oldWidget) {
    if (widget.isChecked != oldWidget.isChecked) {
      _isChecked = widget.isChecked;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    textLabel =  this.widget.labelText;
    _labelColor = widget.labelColor ?? Colors.grey.shade800;
    _buttonColor = widget.buttonColor ?? Colors.blue.shade500;

    return Padding(
      padding: EdgeInsets.only(right: Constant.MINIMUM_PADDING / 2),
      child: InkWell(
        onTap: () {
          setState(() {
            _isChecked = !_isChecked;
            widget.onChecked(_isChecked);
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,

          children: <Widget>[
            Container(
              child: Text(
                textLabel,
                style: TextStyle(
                  color: _labelColor,
                  fontSize: widget.labelSize,
                  fontWeight: widget.labelWeight,
                ),
              ),
            ),

            Container(
              width: Constant.MINIMUM_SPACING_SM,
            ),

            SizedBox(
              width: Checkbox.width,
              height: Checkbox.width,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: Constant.MINIMUM_BORDER_WIDTH,
                  ),
                  color: widget.bgColor,
                ),
                child: Checkbox(
                  value: _isChecked,
                  tristate: true,
                  onChanged: (bool isChecked) {
                    setState(() {
                      _isChecked = !_isChecked;
                      widget.onChecked(isChecked);
                    });
                  },
                  checkColor: Colors.white,
                  activeColor: _buttonColor,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

void _defaultBtnChecked() {}
