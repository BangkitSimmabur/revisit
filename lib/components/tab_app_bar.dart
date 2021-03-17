import 'package:flutter/material.dart';
import 'package:revisit/main_styles.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool searchBar;
  final Widget iconAction;
  final Widget iconActionSecondary;
  final bool isIntl;
  final IconData customLeadingIcon;
  final Function onLeadingClick;
  final Function onActionClick;
  final Function onActionSecondaryClick;
  final Color customLeadingColour;

  TabAppBar(
      this.title, {
        Key key,
        this.showBackButton = true,
        this.searchBar = false,
        this.iconAction,
        this.iconActionSecondary,
        this.isIntl = false,
        this.customLeadingIcon,
        this.onLeadingClick,
        this.onActionClick,
        this.onActionSecondaryClick,
        this.customLeadingColour = Colors.white,
      })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;
  Widget _leadingWidget;
  Widget _titleWidget;
  String _textLabel;
  Widget _showIconAction;

  @override
  Widget build(BuildContext context) {
    this._textLabel =  this.title;

    _titleWidget =  Text(
      this._textLabel,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: Styles.navbarTextStyle,
    );

    _leadingWidget = this.customLeadingIcon != null
        ? IconButton(
      icon: Icon(
        this.customLeadingIcon,
        color: this.customLeadingColour,
      ),
      onPressed: this.onLeadingClick,
    )
        : this.showBackButton
        ? IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () => this._moveToLastScreen(context),
    )
        : Container();

    _showIconAction = Row(
      children: <Widget>[
        this.iconAction != null
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: IconButton(
                icon: this.iconAction,
                onPressed: onActionClick,
              ),
            ),
            this.iconActionSecondary != null
                ? Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                  left: Constant.MINIMUM_SPACING,
                ),
                child: IconButton(
                  icon: this.iconActionSecondary,
                  onPressed: onActionSecondaryClick,
                ),
              ),
            )
                : Container(),
          ],
        )
            : Container(),
      ],
    );

    return AppBar(
      automaticallyImplyLeading: this.showBackButton,
      leading: _leadingWidget,
      centerTitle: true,
      title: _titleWidget,
      titleSpacing: 0,
      brightness: Brightness.light,
      backgroundColor: Constant.blue01,
      actions: <Widget>[this._showIconAction],
    );
  }

  void _moveToLastScreen(BuildContext context) {
    MainPlatform.backTransitionPage(context);
  }
}
