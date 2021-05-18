import 'package:flutter/material.dart';
import 'package:revisit/constant.dart';

class RevisitSearchBar extends StatefulWidget {
  final String placeholder;
  final TextEditingController searchBarController;
  final bool isShowIconVisible;
  final bool isIntl;
  final FocusNode focusNode;
  final OnSearchSubmit onSearchSubmit;
  final OnChanged onChanged;

  RevisitSearchBar(
      this.placeholder, {
        this.searchBarController,
        this.isShowIconVisible = true,
        this.isIntl = false,
        this.focusNode,
        this.onSearchSubmit,
        this.onChanged,
      });

  @override
  State<StatefulWidget> createState() {
    return _RevisitSearchBarState();
  }
}

class _RevisitSearchBarState extends State<RevisitSearchBar> {
  var defaultColor = Colors.grey.shade600;
  Widget searchIcon;
  String textLabel;
  bool _isSearchVisible = false;

  @override
  void initState() {
    if (widget.searchBarController != null) {
      widget.searchBarController.addListener(_onChangeText);
    }
    super.initState();
  }

  @override
  void setState(fn) {
    if (!mounted) return;

    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    textLabel = widget.placeholder;
    if (widget.isShowIconVisible) {
      searchIcon = Icon(
        Icons.search,
        color: defaultColor,
        size: Constant.SEARCHBAR_HEIGHT / 2,
      );
    } else {
      searchIcon = Container();
    }

    return Container(
      height: Constant.SEARCHBAR_HEIGHT,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          left: Constant.MINIMUM_PADDING_SM, right: Constant.MINIMUM_PADDING_SM),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(
              left: Constant.MINIMUM_PADDING / 4, right: Constant.MINIMUM_PADDING / 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(Constant.MINIMUM_BORDER_RADIUS * 1.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              searchIcon,
              Container(
                width: Constant.MINIMUM_SPACING_MD,
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: TextFormField(
                    onFieldSubmitted: (String val) {
                      if (widget.onSearchSubmit != null)
                        widget.onSearchSubmit(val);
                    },
                    textInputAction: TextInputAction.search,
                    focusNode: widget.focusNode,
                    controller: widget.searchBarController,
                    onChanged: (String val) {
                      if (widget.onChanged != null) widget.onChanged(val);
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: textLabel,
                        hintStyle: TextStyle(
                            color: defaultColor, fontWeight: FontWeight.w300)),
                    style: TextStyle(
                      color: defaultColor,
                      fontWeight: FontWeight.w600,
                      fontSize: Constant.SEARCHBAR_HEIGHT / 3,
                    ),
                  ),
                ),
              ),
              Container(
                width: Constant.MINIMUM_SPACING_MD,
              ),
              _isSearchVisible
                  ? GestureDetector(
                onTap: () {
                  if (widget.onSearchSubmit != null &&
                      widget.searchBarController != null) {
                    widget
                        .onSearchSubmit(widget.searchBarController.text);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Constant.BLUE02,
                    borderRadius: BorderRadius.circular(
                      Constant.MINIMUM_BORDER_RADIUS_MD,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Constant.MINIMUM_SPACING,
                    vertical: Constant.MINIMUM_SPACING / 1.6,
                  ),
                  child: Text(
                    'Cari',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Constant.SEARCHBAR_HEIGHT / 3.6,
                    ),
                  ),
                ),
              )
                  : Container(),
              Container(
                width: Constant.MINIMUM_SPACING,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onChangeText() {
    if (widget.searchBarController == null) return;

    setState(
          () => _isSearchVisible = widget.searchBarController.text.isNotEmpty,
    );
  }
}

typedef OnSearchSubmit(String val);
typedef OnChanged(String val);
