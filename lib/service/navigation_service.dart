import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:revisit/models/user.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Flushbar flushbarNavigator;

  Widget currentWidget;

  User currentUser;
  String currentToken;

  Future<dynamic> navigateNamedTo(String routeName) {
    if (navigatorKey?.currentState == null) return null;

    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }
}
