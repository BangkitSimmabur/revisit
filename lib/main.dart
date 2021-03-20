import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:revisit/Screens/login.dart';
import 'package:revisit/Screens/splashScreen.dart';
import 'package:revisit/components/button_full.dart';
import 'package:revisit/components/inputCommon.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:revisit/service/constant_service.dart';
import 'package:revisit/service/location_service.dart';
import 'package:revisit/service/navigation_service.dart';
import 'package:revisit/type.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:revisit/service/network_service.dart';

void main() {
  setupLocator();

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      //     .then((_) {
      //   runApp(new MyApp());
      // });
      runApp(MyApp());
    },
    (error, stackTrace) async {
      print('eror' + stackTrace.toString());
      print(error);
    },
  );
}

void setupLocator() {
  GetIt.I.registerLazySingleton<NavigationService>(() => NavigationService());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ConstantService>(
            create: (_) => ConstantService(),
          ),
          ChangeNotifierProvider<LocationService>(
            create: (_) => LocationService(),
          ),
          ChangeNotifierProvider<NetworkService>(
            create: (_) => NetworkService(ConstantService()),
          ),
          ChangeNotifierProvider<AuthService>(
            create: (_) => AuthService(ConstantService()),
          ),
        ],
        child: RefreshConfiguration(
          headerBuilder: () => MaterialClassicHeader(),
          footerBuilder: () => ClassicFooter(
            loadStyle: LoadStyle.ShowAlways,
          ),
          child: GestureDetector(
            onTap: _removeFocus,
            child: MaterialApp(
              title: 'ReVisit',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  fontFamily: 'Rubik',
                  scaffoldBackgroundColor: Constant.GRAY_BACKGROUND,
                  textTheme: TextTheme(
                    headline5: TextStyle(
                      fontSize: 72.0,
                      color: Colors.black,
                    ),
                    headline1: TextStyle(
                      fontSize: 40.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                    headline2: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    headline3: TextStyle(
                      // AppBar Title
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                    headline4: TextStyle(
                      // AppBar Title
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    bodyText2: TextStyle(
                      fontSize: 14.0,
                    ),
                  )),
              themeMode: ThemeMode.light,
              onGenerateRoute: (route) => _routeMap[route.name](
                route.arguments,
              ),
            ),
          ),
        ));
  }

  Map get _routeMap {
    return {
      '/': (dynamic data) => MaterialPageRoute(
            builder: (context) => SplashScreen(),
            // builder: (context) => _homeActive,
          ),
      '/landing-home': (dynamic data) => MaterialPageRoute(
            builder: (context) => Login(),
          ),
    };
  }

  // Widget get _homeActive {
  //   return SplashScreen();
  // }

  void _removeFocus() {

    print("tapped");
    var currentFocus = FocusScope.of(context);

    print(currentFocus);
    print(currentFocus.focusedChild);
    print(currentFocus.hasFocus);

    if (!currentFocus.hasFocus || currentFocus.focusedChild == null)
      return;

    currentFocus.focusedChild.unfocus();
    // FocusManager.instance.primaryFocus?.unfocus();
  }
}
