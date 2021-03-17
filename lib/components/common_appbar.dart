import 'package:flutter/material.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/main_styles.dart';

class RevisitAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData trailingIcon;
  final Function onPressTrailing;
  final IconData customLeadingIconData;
  final dynamic onBackValue;
  final Widget specialBack;
  final bool canPop;
  final Function backValidator;
  final IconData customLeadingActionIconData;
  final Function onPressLeading;
  final bool mustPop;
  final Color bgColor;

  final Color trailingColor;

  RevisitAppbar(
      this.title, {
        Key key,
        this.trailingIcon,
        this.customLeadingIconData = Icons.arrow_back,
        this.onPressTrailing = _onDefaultTrailingPress,
        this.onBackValue,
        this.trailingColor = Colors.white,
        this.specialBack,
        this.canPop = true,
        this.backValidator,
        this.customLeadingActionIconData,
        this.onPressLeading,
        this.mustPop = false,
        this.bgColor = Colors.white,
      })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    var titleStr = title;
    var leading = specialBack == null
        ? (Navigator.canPop(context) && canPop) || mustPop
        ? IconButton(
      icon: Icon(
        customLeadingIconData,
        color: Colors.white,
      ),
      onPressed: _onBackChange(context),
    )
        : Container()
        : specialBack;

    return AppBar(

      leading: leading,
      centerTitle: true,
      title: Text(
        titleStr,
        style: Styles.navbarTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      brightness: Brightness.light,
      backgroundColor: bgColor,
      actions: <Widget>[
        _trailingIcon,
        _actionIcon,
      ],
    );
  }

  Widget get _trailingIcon {
    return trailingIcon != null
        ? IconButton(
      icon: Icon(
        trailingIcon,
        color: trailingColor,
      ),
      onPressed: onPressTrailing,
    )
        : Container();
  }

  Widget get _actionIcon {
    return customLeadingActionIconData != null
        ? IconButton(
      icon: Icon(
        customLeadingActionIconData,
        color: trailingColor,
      ),
      onPressed: onPressLeading,
    )
        : Container();
  }

  Function _onBackChange(BuildContext context) {
    if (backValidator != null) return () => backValidator();

    return () => MainPlatform.backTransitionPage(
      context,
      value: onBackValue,
    );
  }
}

void _onDefaultTrailingPress() {}
