import 'dart:io' show Platform;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/location_service.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/service/navigation_service.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  Widget childElement;
  TabController _tabController;
  var _locatorModel = GetIt.I<NavigationService>();
  var _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  LocationService _locationService;

  @override
  void initState() {
    _initInternalState();

    Future.delayed(Duration.zero, _initDataState);

    super.initState();
  }

  Future<void> _initDataState() async {
    MainPlatform.showLoadingAlert(
      context,
      'Mengambil lokasi',
    );

    var serverLog = await _locationService.setCurrentLocation(
      isLastKnown: true,
    );

    MainPlatform.backTransitionPage(context);

    print(_locationService.address);
    if (serverLog.success) return;

    return MainPlatform.showErrorSnackbar(context, serverLog.message);
  }

  /// Initialization of internal states.
  void _initInternalState() {
    // init element
    _locatorModel.navigatorKey = _navigatorKey;
    _locatorModel.scaffoldKey = _scaffoldKey;
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_signUpKey.currentState != null) {
      _signUpKey.currentState.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _locationService = Provider.of<LocationService>(context);

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Scaffold(
            appBar: _appBar,
            body: Container(
              child: Text('Pendaftaran'),
            )
          )
        ],
      ),
    );
  }

  Widget get _appBar {
    return AuthAppbar(
      'Registrasi',
    );
  }
}
