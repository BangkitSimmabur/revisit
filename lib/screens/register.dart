import 'dart:io' show Platform;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revisit/components/button_full.dart';
import 'package:revisit/components/button_full_border.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/components/input_border.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'package:revisit/service/location_service.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/service/navigation_service.dart';
import 'package:revisit/utility/signup_util.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  Widget childElement;
  var _locatorModel = GetIt.I<NavigationService>();
  var _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthService _authService;

  // GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _canRegister = false;

  LocationService _locationService;

  @override
  void initState() {
    _initInternalState();

    Future.delayed(Duration.zero, _initDataState);

    super.initState();
  }

  Future<void> _initDataState() async {}

  /// Initialization of internal states.
  void _initInternalState() {
    // init element
    _locatorModel.navigatorKey = _navigatorKey;
    _locatorModel.scaffoldKey = _scaffoldKey;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _emailController.dispose();

    if (_signUpKey.currentState != null) {
      _signUpKey.currentState.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _locationService = Provider.of<LocationService>(context);
    _authService = Provider.of<AuthService>(context);

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
          Column(
            children: [
              Expanded(
                child: Center(child: _formElement),
              ),
              _registerButton,
            ],
          ),
        ],
      ),
    );
  }

  Widget get _formElement {
    return ListView(
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
              RevisitInputOutlineBorder(
                'nama',
                labelColor: Constant.blue01,
                labelSize: Constant.MINIMUM_FONT_SIZE,
                labelWeight: FontWeight.w600,
                borderSide: BorderSide(
                  color: Constant.blue01,
                  width: Constant.MINIMUM_BORDER_WIDTH,
                ),
                noPadding: true,
                inputController: _nameController,
                borderRadius: 0,
                isDense: false,
                onChange: (val) {
                  checkCanRegister();
                  print("1");
                },
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              RevisitInputOutlineBorder(
                'username',
                labelColor: Constant.blue01,
                labelSize: Constant.MINIMUM_FONT_SIZE,
                labelWeight: FontWeight.w600,
                borderSide: BorderSide(
                  color: Constant.blue01,
                  width: Constant.MINIMUM_BORDER_WIDTH,
                ),
                noPadding: true,
                inputController: _usernameController,
                borderRadius: 0,
                isDense: false,
                onChange: (val) {
                  checkCanRegister();
                  print("2");
                },
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              RevisitInputOutlineBorder(
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
                onValidate: (String email) {
                  return SignUpUtils.emailRegexValidate(context, email);
                },
                errorColor: Colors.red,
                errorMaxLines: 3,
                autoValidate: true,
                onChange: (val) {
                  checkCanRegister();
                  print("3");
                },
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              RevisitInputOutlineBorder(
                'kata sandi',
                labelColor: Constant.blue01,
                labelWeight: FontWeight.w600,
                labelSize: Constant.MINIMUM_FONT_SIZE,
                borderSide: BorderSide(
                  color: Constant.blue01,
                  width: Constant.MINIMUM_BORDER_WIDTH,
                ),
                isDense: false,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                noPadding: true,
                autoValidate: true,
                inputController: _passwordController,
                borderRadius: 0,
                onValidate: (String password) {
                  return SignUpUtils.passwordRegexValidate(context, password);
                },
                errorColor: Colors.red,
                errorMaxLines: 3,
                onChange: (val) {
                  checkCanRegister();
                  print("4");
                },
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              RevisitInputOutlineBorder(
                'ulangi kata sandi',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                labelColor: Constant.blue01,
                labelWeight: FontWeight.w600,
                labelSize: Constant.MINIMUM_FONT_SIZE,
                borderSide: BorderSide(
                  color: Constant.blue01,
                  width: Constant.MINIMUM_BORDER_WIDTH,
                ),
                isDense: false,
                noPadding: true,
                autoValidate: true,
                inputController: _confirmPasswordController,
                borderRadius: 0,
                onValidate: (String confirmPasswordVal) {
                  return SignUpUtils.isConfirmPasswordValid(
                    context,
                    _passwordController.text,
                    confirmPasswordVal,
                  );
                },
                errorColor: Colors.red,
                errorMaxLines: 3,
                onChange: (val) {
                  checkCanRegister();
                  print("5");
                },
              ),
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onRegister() async {
    HandlingServerLog a = await _authService.register(
      _nameController.text,
      _passwordController.text,
      _emailController.text,
      _usernameController.text,
    );
    print(a.data);
    if (a.success) {
      MainPlatform.backTransitionPage(context);
    }
    if (!a.success) {
      MainPlatform.showErrorSnackbar(context, 'Gagal mendaftarkan akun');
    }
  }

  Widget get _registerButton {
    return RevisitButtonFull(
      "Daftar",
      buttonColor: Constant.blue01,
      onClick: _canRegister ? _onRegister : null,
      isLoading: _isLoading,
      padding: Constant.MINIMUM_PADDING_BUTTON_MD,
      labelSize: Constant.MINIMUM_FONT_SIZE - 2,
    );
  }

  void checkCanRegister() {
    print('asd');
    var emailCheck =
        SignUpUtils.emailRegexValidate(context, _emailController.text);
    var confirmPasswordCheck = SignUpUtils.isConfirmPasswordValid(
      context,
      _passwordController.text,
      _confirmPasswordController.text,
    );
    var passwordCheck =
        SignUpUtils.passwordRegexValidate(context, _passwordController.text);

    if (_nameController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        emailCheck == null &&
        passwordCheck == null &&
        confirmPasswordCheck == null) {
      setState(() {
        _canRegister = true;
      });
      print("ini tru");
      return;
    }

    setState(() {
      _canRegister = false;
    });
    print("ini false");
    return;
  }

  Widget get _appBar {
    return RevisitAppbar(
      'Registrasi',
      bgColor: Constant.blue01,
      trailingColor: Colors.white,
    );
  }
}
