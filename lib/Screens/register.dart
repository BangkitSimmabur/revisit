import 'dart:io' show Platform;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revisit/components/button_full_border.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/components/input_border.dart';
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

  // GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

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
        children: [
          // RevisitBackgroundImage(
          //   src: 'assets/images/loginbg.jpg',
          // ),
          Scaffold(
            key: _navigatorKey,
            appBar: _appBar,
            // backgroundColor: Color(0x263D5AFE),
            body: _childElement,
          )
        ],
      ),
    );
  }

  Widget get _childElement {
    return Form(
      key: _signUpKey,
      child: Stack(
        children: [
          ListView(
            children: [
              _formElement,
            ],
          ),
        ],
      ),
    );
  }

  Widget get _formElement {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: Constant.DEFAULT_PADDING_MD,
            right: Constant.DEFAULT_PADDING_MD,
            top: Constant.MINIMUM_SPACING_XLG,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RevisitInputBorder(
                'nama',
                labelColor: Constant.blue01,
                labelSize: Constant.MINIMUM_FONT_SIZE,
                labelWeight: FontWeight.w600,
                keyboardType: TextInputType.emailAddress,
                borderSide: BorderSide(
                  color: Constant.blue01,
                  width: Constant.MINIMUM_BORDER_WIDTH,
                ),
                noPadding: true,
                inputController: _emailController,
                borderRadius: 0,
                isDense: false,
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              RevisitInputBorder(
                'username',
                labelColor: Constant.blue01,
                labelSize: Constant.MINIMUM_FONT_SIZE,
                labelWeight: FontWeight.w600,
                keyboardType: TextInputType.emailAddress,
                borderSide: BorderSide(
                  color: Constant.blue01,
                  width: Constant.MINIMUM_BORDER_WIDTH,
                ),
                noPadding: true,
                inputController: _emailController,
                borderRadius: 0,
                isDense: false,
              ),
              RevisitInputBorder(
                'email',
                labelColor: Constant.blue01,
                labelSize: Constant.MINIMUM_FONT_SIZE,
                labelWeight: FontWeight.w600,
                keyboardType: TextInputType.emailAddress,
                borderSide: BorderSide(
                  color: Constant.blue01,
                  width: Constant.MINIMUM_BORDER_WIDTH,
                ),
                noPadding: true,
                inputController: _emailController,
                borderRadius: 0,
                isDense: false,
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              RevisitInputBorder(
                'password',
                labelColor: Constant.blue01,
                labelWeight: FontWeight.w600,
                labelSize: Constant.MINIMUM_FONT_SIZE,
                borderSide: BorderSide(
                  color: Constant.blue01,
                  width: Constant.MINIMUM_BORDER_WIDTH,
                ),
                isDense: false,
                noPadding: true,
                inputController: _passwordController,
                borderRadius: 0,
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: Constant.INPUT_HEIGHT_BUTTON + 2,
                    width: 100,
                    child: RevisitButtonFullBordered(
                      'Daftar',
                      labelColor: Colors.white,
                      labelSize: Constant.MINIMUM_FONT_SIZE,
                      labelWeight: FontWeight.w600,
                      borderRadius: Constant.MINIMUM_BORDER_RADIUS_LG,
                      onClick: () {
                        print('ditekan');
                      },
                      btnBorderSide:
                      BorderSide(width: 2, color: Constant.blue01),
                      buttonColor: Constant.blue01,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget get _appBar {
    return AuthAppbar(
      'Registrasi',
      bgColor: Constant.blue01,
      trailingColor: Colors.white,
    );
  }
}
