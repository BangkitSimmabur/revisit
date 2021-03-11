import 'package:flutter/material.dart';
import 'package:revisit/constant.dart';

class CommonText {
  String id;
  String name;

  CommonText(
      this.id,
      this.name,
      );
}

class TruWorldTextChoose extends StatefulWidget {
  final String _defaultText;
  final List<CommonText> commonText;
  final String initValue;
  final OnSavedValue onSavedValue;

  final double size;
  final double borderSize;
  final Color labelColor;
  final Color bgColor;
  final double labelSize;
  final FontWeight labelWeight;
  final MainAxisAlignment alignment;
  final bool noLabel;
  final bool bordered;

  TruWorldTextChoose(
      this._defaultText, {
        Key key,
        @required this.commonText,
        this.size = Constant.SEARCHBAR_HEIGHT,
        this.labelColor = Colors.black87,
        this.bgColor,
        this.labelSize = Constant.MINIMUM_FONT_SIZE,
        this.labelWeight = FontWeight.w400,
        this.alignment = MainAxisAlignment.start,
        this.initValue,
        this.onSavedValue,
        this.noLabel = false,
        this.bordered = false,
        this.borderSize = 1,
      }
      ) : super(key: key);

  @override
  _TruWorldTextChooseState createState() => _TruWorldTextChooseState();
}

class _TruWorldTextChooseState extends State<TruWorldTextChoose> {
  String _text;
  String _value;
  var _items = <CommonText>[];

  @override
  void initState() {
    super.initState();
    _value = widget.initValue;
  }

  @override
  void didUpdateWidget(TruWorldTextChoose oldWidget) {
    if (oldWidget.initValue != widget.initValue) {
      _value = widget.initValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _text =  widget._defaultText;
    _items = widget.commonText;
    bool isNullExist = false;
    for (var item in _items) {
      if (item.id == null) {
        isNullExist = true;
      }
    }
    if (!isNullExist && !widget.noLabel) {
      _items.insert(0, CommonText(null, _text));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => _parentElement;

  Widget get _parentElement {
    var ids = _items.map<String>((e) => e.id).toList();
    var isValueExist = ids.firstWhere((id) => id == _value, orElse: () => null);
    if (isValueExist == null) {
      _value = ids[0];
    }

    return SizedBox(
      width: widget.size + 15.0,
      height: widget.bordered
          ? kTextTabBarHeight-(widget.borderSize*2)
          : kTextTabBarHeight,
      child: Material(
        color: widget.bgColor != null
            ? widget.bgColor
            :Colors.transparent,
        child: DropdownButton<String>(
          isExpanded: true,
          underline: Container(
            color: Constant.GRAY_TEXT,
            height: 0.4,
          ),
          items: ids.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: _childElement(
                _items.firstWhere((e) {
                  return e.id == val;
                }),
              ),
            );
          }).toList(),
          onChanged: (String val) {
            setState(() {
              _value = val;
            });
            if (widget.onSavedValue != null) {
              widget.onSavedValue(val);
            }
          },
          value: _value,
        ),
      ),
    );
  }

  Widget _childElement(CommonText item) {
    return Text(
      item.name,
      style: TextStyle(
        color: widget.labelColor,
        fontSize: widget.labelSize,
        fontWeight: widget.labelWeight,
      ),
    );
  }
}

typedef void OnSavedValue(String val);
