import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revisit/Screens/login.dart';
import 'package:revisit/Screens/tabs/main_tab.dart';
import 'package:revisit/components/revisit_bg_image.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/db_helper/table_user.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:revisit/service/constant_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:revisit/service/navigation_service.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthService _authService;
  ConstantService _constantService;

  var _locatorModel = GetIt.I<NavigationService>();

  @override
  void initState() {
    Future.delayed(Duration.zero, _fetchIfUserExist);

    super.initState();
  }


  void _fetchIfUserExist() async {
    var ctx = _locatorModel.navigatorKey?.currentContext ?? context;

    var isLoggedIn = await _authService.checkIfLoggedIn();

    Widget destination;

    if (isLoggedIn == null) {
      return SystemChannels.platform.invokeMethod(
        'SystemNavigator.pop',
      );
    }

    print(isLoggedIn);
    print(_constantService.token);
    if (isLoggedIn) {
      destination = MainTab();
    } else {
      destination = Login();
    }

    MainPlatform.transitionToPage(ctx, destination, newPage: true);
  }

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthService>(context);
    _constantService = Provider.of<ConstantService>(context);

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Platform.isIOS
              ? CupertinoPageScaffold(
                  child: _childElement,
                )
              : Scaffold(
                  body: _childElement,
                ),
        ],
      ),
    );
  }

  Widget get _childElement {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: RevisitBackgroundImage(
              src: 'assets/images/loginbg.jpg',
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: Constant.MINIMUM_SPACING_LG + 4,
              ),
              RevisitSpinner(),
            ],
          ),
        ],
      ),
    );
  }
}
