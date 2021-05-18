import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revisit/components/button_full_border.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/components/image_input_profile.dart';
import 'package:revisit/components/input_border.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'package:revisit/service/location_service.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/service/navigation_service.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile>
    with SingleTickerProviderStateMixin {
  Widget childElement;
  TabController _tabController;
  var _locatorModel = GetIt.I<NavigationService>();
  var _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String imgSrc;
  File _imageFile;
  bool _isLoadingImg = false;

  AuthService _authService;

  // GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController _emailController = TextEditingController();
  // TextEditingController _usernameController = TextEditingController();
  // TextEditingController _nameController = TextEditingController();
  // TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  LocationService _locationService;

  @override
  void initState() {
    _initInternalState();

    Future.delayed(Duration.zero, _initDataState);

    super.initState();
  }

  Future<void> _initDataState() async {
    setState(() {
      // _usernameController.text = _authService.currentUser.username;
      // _nameController.text = _authService.currentUser.name;
      imgSrc = _authService.currentUser.profilePicture.fullImage;
    });
  }

  /// Initialization of internal states.
  void _initInternalState() {
    // init element
    _locatorModel.navigatorKey = _navigatorKey;
    _locatorModel.scaffoldKey = _scaffoldKey;
  }

  @override
  void dispose() {

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
              _photoInput,
              Container(
                height: Constant.MINIMUM_SPACING_XLG,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Constant.INPUT_HEIGHT_BUTTON + 2,
                    width: 100,
                    child: RevisitButtonFullBordered(
                      'Unggah',
                      labelColor: Colors.white,
                      labelSize: Constant.MINIMUM_FONT_SIZE,
                      labelWeight: FontWeight.w600,
                      borderRadius: Constant.MINIMUM_BORDER_RADIUS_LG,
                      onClick: () {
                        onRegister();
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

  void onRegister() async {
    // HandlingServerLog a = await _authService.register(
    //   _nameController.text,
    //   _passwordController.text,
    //   _emailController.text,
    //   _usernameController.text,
    // );
    MainPlatform.showLoadingAlert(context, "Mengunggah");

    HandlingServerLog a = await _authService.editPhoto(_imageFile);
    print(a.data);
    if (a.success) {
      MainPlatform.backTransitionPage(context);
      MainPlatform.backTransitionPage(context);
    }
    if (!a.success) {
      MainPlatform.backTransitionPage(context);
      MainPlatform.showErrorSnackbar(context, 'Gagal mendaftarkan akun');
    }
  }

  Widget get _photoInput {
    return RevisitInputImageProfile(
      imgSrc,onSavedImage: (File img) {
        setState(() {
          _imageFile = img;
        });
      },
      isLoading: _isLoadingImg,
    );
  }

  Widget get _appBar {
    return RevisitAppbar(
      'Unggah Foto Profil',
      bgColor: Constant.blue01,
      trailingColor: Colors.white,
    );
  }
}
