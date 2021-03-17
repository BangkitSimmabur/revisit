import 'dart:io' show Platform;

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revisit/Screens/tabs/article_tab/article_main.dart';
import 'package:revisit/Screens/tabs/profile_tab/profile_main.dart';
import 'package:revisit/Screens/tabs/story_tab/story_main.dart';
import 'package:revisit/components/tab_app_bar.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:revisit/service/navigation_service.dart';

class MainTab extends StatefulWidget {
  MainTab({
    this.currentIndex,
  });

  final int currentIndex;

  @override
  State<StatefulWidget> createState() {
    return _MainTabState();
  }
}

class _MainTabState extends State<MainTab>
    with SingleTickerProviderStateMixin {
  var _locatorModel = GetIt.I<NavigationService>();
  var _navigatorKey = GlobalKey<NavigatorState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;

  int _currentIndex = 0;
  final List<String> _titleBars = [
    "Artikel",
    "Cerita",
    "Profil",
  ];

  // two times back
  DateTime backButtonPressTime;
  Duration snackBarDuration = Duration(seconds: 1);
  Duration snackBarAnimationDuration = Duration(milliseconds: 500);

  List<BottomNavigationBarItem> _bottomNavItems;
  Widget _bottomNavbar;
  Widget _homeAppBar;

  AuthService _authService;

  @override
  void initState() {
    _locatorModel.navigatorKey = _navigatorKey;
    _locatorModel.scaffoldKey = _scaffoldKey;
    _currentIndex = widget.currentIndex ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthService>(context);
    _bottomNavItems = [
      BottomNavigationBarItem(
        icon: _currentIndex == 0
            ? Icon(
                FontAwesomeIcons.newspaper,
                color: Constant.blue01,
              )
            : Icon(
                FontAwesomeIcons.newspaper,
                color: Constant.GRAY01,
              ),
        //     ? Image.asset(
        //   'assets/icons/home_selected.png',
        //   height: 23,
        //   width: 23,
        // )
        //     : Image.asset(
        //   'assets/icons/home.png',
        //   height: 23,
        //   width: 23,
        // ),
        label: "Artikel",
      ),
      BottomNavigationBarItem(
          icon: _currentIndex == 1
              //     ? Image.asset(
              //         'assets/icons/orders_selected.png',
              //         height: 23,
              //         width: 23,
              //       )
              //     : Image.asset(
              //         'assets/icons/orders.png',
              //         height: 23,
              //         width: 23,
              //       ),
              // title: TruWorldTextIntl(
              //   "tab_orders_bottom",
              //   isIntl: true,
              //   style: Styles.titleBarStyle,
              // ),
              ? Icon(
                  FontAwesomeIcons.paperPlane,
                  color: Constant.blue01,
                )
              : Icon(
                  FontAwesomeIcons.paperPlane,
                  color: Constant.GRAY01,
                ),
          label: "Cerita"),
      BottomNavigationBarItem(
        icon: _currentIndex == 2
            //     ? Image.asset(
            //         'assets/icons/map_view_selected.png',
            //         height: 23,
            //         width: 23,
            //       )
            //     : Image.asset(
            //         'assets/icons/map_view.png',
            //         height: 23,
            //         width: 23,
            //       ),
            // title: TruWorldTextIntl(
            //   "tab_map",
            //   isIntl: true,
            //   style: Styles.titleBarStyle,
            // ),
            ? Icon(
                FontAwesomeIcons.user,
                color: Constant.blue01,
              )
            : Icon(
                FontAwesomeIcons.user,
                color: Constant.GRAY01,
              ),
        label: "Profil"
      ),
    ].toList();

    _homeAppBar = TabAppBar(
      _titleBars[_currentIndex],
      showBackButton: false,
      iconAction: _iconTabs[_currentIndex],
      isIntl: true,
      key: Key(Constant.KEY_TAB_APPBAR[_currentIndex]),
      onActionClick: _actionClick[_currentIndex],
    );
    _bottomNavbar = BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: _bottomNavItems,
      selectedLabelStyle: TextStyle(
        fontSize: Constant.MINIMUM_FONT_SIZE / 1.5,
        fontWeight: FontWeight.w700,
      ),
      selectedItemColor: Constant.blue01,
      unselectedItemColor: Constant.GRAY01,
      unselectedLabelStyle: TextStyle(
        fontSize: Constant.MINIMUM_FONT_SIZE / 1.5,
        fontWeight: FontWeight.w700,
        color: Constant.GRAY01,
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[_screen],
        ),
      ),
    );
  }

  Widget get _screen {
    return Scaffold(
      key: _navigatorKey,
      appBar: _homeAppBar,
      body: WillPopScope(
          child: _children[_currentIndex], onWillPop: () => onWillPop(context)),
      bottomNavigationBar: _bottomNavbar,
    );
  }

  List<Widget> get _children {
    return [
      ArticleMain(),
      StoryMain(),
      ProfileMain(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> onWillPop(BuildContext context) async {
    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            currentTime.difference(backButtonPressTime) > snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      Flushbar(
        message:
            "Tekan tombol kembali sebanyak dua kali untuk keluar dari aplikasi",
        duration: snackBarDuration,
        flushbarStyle: FlushbarStyle.FLOATING,
        borderRadius: Constant.MINIMUM_BORDER_RADIUS,
        margin: EdgeInsets.all(
          Constant.MINIMUM_PADDING,
        ),
//        backgroundGradient: LinearGradient(
//          colors: [Colors.blue, Colors.lightBlueAccent],
//        ),
        boxShadows: [
          BoxShadow(
            color: Constant.GRAY_TEXT,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        animationDuration: snackBarAnimationDuration,
      )..show(context);
      return false;
    }

    SystemNavigator.pop();
    return null;
  }

  List<Widget> get _iconTabs {
    return [
      Icon(Icons.search, color: Colors.white, size: Constant.HEIGHT_SM),
      Icon(Icons.search, color: Colors.white, size: Constant.HEIGHT_SM),
      null,
    ];
  }

  List<Function> get _actionClick {
    return [
      () => print('search ditekan'),
      () => print('search ditekan'),
      null,
    ].toList();
  }
}
