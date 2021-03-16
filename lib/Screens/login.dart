import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revisit/Screens/register.dart';
import 'package:revisit/components/button_full_border.dart';
import 'package:revisit/components/input_border.dart';
import 'package:revisit/components/revisit_bg_image.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:revisit/service/location_service.dart';
import 'package:revisit/service/navigation_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _navigatorKey = GlobalKey<NavigatorState>();
  var _locatorModel = GetIt.I<NavigationService>();
  bool _isLoginLoading = false;
  AuthService _authService;

  LocationService _locationService;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _initDataState);
    super.initState();
  }

  void _initDataState() async {
    if (_locatorModel.navigatorKey?.currentContext != null) return;
    _locatorModel.navigatorKey = _navigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthService>(context);

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          RevisitBackgroundImage(
            src: 'assets/images/loginbg.jpg',
          ),
          Scaffold(
            key: _navigatorKey,
            backgroundColor: Color(0x263D5AFE),
            body: _childElement,
          )
        ],
      ),
    );
  }

  Widget get _childElement {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(
                        'Re-Visit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Flexible(
                      flex: 8,
                      child: _formElement,
                    ),
                  ],
                ),
              ),
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
              Container(
                height: Constant.INPUT_HEIGHT + 2,
                child: RevisitInputBorder(
                  'email',
                  labelColor: Colors.white,
                  labelSize: Constant.MINIMUM_FONT_SIZE,
                  labelWeight: FontWeight.w600,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icon(
                    Icons.perm_identity,
                    color: Colors.white,
                    size: Constant.MINIMUM_FONT_SIZE,
                  ),
                  backGroundColor: Color(0x54000000),
                  borderSide: BorderSide(
                    color: Constant.blue01,
                    width: Constant.MINIMUM_BORDER_WIDTH,
                  ),
                  noPadding: true,
                  inputController: _emailController,
                  borderRadius: 5,
                ),
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              Container(
                height: Constant.INPUT_HEIGHT + 2,
                child: RevisitInputBorder(
                  'password',
                  labelColor: Colors.white,
                  labelWeight: FontWeight.w600,
                  obscureText: true,
                  labelSize: Constant.MINIMUM_FONT_SIZE,
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  borderSide: BorderSide(
                    color: Constant.blue01,
                    width: Constant.MINIMUM_BORDER_WIDTH,
                  ),
                  noPadding: true,
                  backGroundColor: Color(0x54000000),
                  inputController: _passwordController,
                  borderRadius: 5,
                ),
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: Constant.INPUT_HEIGHT_BUTTON + 2,
                      child: RevisitButtonFullBordered('Daftar',
                          labelColor: Colors.white,
                          labelSize: Constant.MINIMUM_FONT_SIZE,
                          labelWeight: FontWeight.w600,
                          buttonColor: Color(0x54000000),
                          // buttonDisabledColor: Constant.GRAY02,
                          borderRadius: Constant.MINIMUM_BORDER_RADIUS_LG,
                          onClick: _onNavigateRegister,
                          isLoading: _isLoginLoading,
                          btnBorderSide:
                              BorderSide(width: 2, color: Constant.blue01)),
                    ),
                  ),
                  Container(
                    width: Constant.MINIMUM_SPACING_XLG,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: Constant.INPUT_HEIGHT_BUTTON + 2,
                      child: RevisitButtonFullBordered(
                        'Masuk',
                        labelColor: Colors.white,
                        labelSize: Constant.MINIMUM_FONT_SIZE,
                        labelWeight: FontWeight.w600,
                        buttonColor: Color(0x54000000),
                        borderRadius: Constant.MINIMUM_BORDER_RADIUS_LG,
                        onClick: () {
                          print('ditekan');
                          _onLogin();
                        },
                        btnBorderSide:
                            BorderSide(width: 2, color: Constant.blue01),
                      ),
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

  void _onLogin() async {
    var a = await _authService.login(_emailController.text, _passwordController.text);
    print('ini balasan: $a');
  }

  void _onNavigateRegister() {
    return MainPlatform.transitionToPage(context, Register());
  }
}
