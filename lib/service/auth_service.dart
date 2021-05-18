import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:revisit/models/user.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/screens/login.dart';
import 'package:revisit/service/constant_service.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'package:revisit/service/network_service.dart';
import 'package:revisit/db_helper/table_user.dart';
import 'package:revisit/service/navigation_service.dart';

class AuthService extends NetworkService {
  User currentUser;
  AuthService(ConstantService constantService) : super(constantService);

  Future<HandlingServerLog> login(
    String identity,
    String password,
    bool isRememberMe,
  ) async {
    Map<String, String> reqBody = {"username": identity, "password": password};
    HandlingServerLog serverLog = await doHttpPost('user/login', reqBody);
    var newToken = serverLog.data.toString();

    constantService.token = newToken;
    print(constantService.token);
    if (isRememberMe) {
      updateLatestToken();
    }
    if (serverLog.success) {
      await checkIfLoggedIn();
    }
    return serverLog;
  }

  Future<HandlingServerLog> register(
    String name,
    String password,
    String email,
    String username,
  ) async {
    Map reqBody = {
      "isAdmin": false,
      "name": name,
      "username": username,
      "email": email,
      "password": password
    };
    HandlingServerLog a = await doHttpPost('user/register', reqBody);

    print(a.data);

    return a;
  }

  Future<bool> checkIfLoggedIn() async {
    var tokenUsed = constantService.token;
    if (constantService.token == null || constantService.token.length == 0) {
      var tokenJson =
          await constantService.dbHelper.getFirst(TableUser.tokenTableName);

      if (tokenJson == null) return false;

      tokenUsed = tokenJson['Token'];
      notifyListeners();
    }
    print('tokenUsed:');
    print(tokenUsed);
    await getMe(tokenUsed);
    if (currentUser == null) {
      _setupUser();

      return false;
    }

    constantService.initClient();
    _setupUser();

    return true;
  }

  Future<User> getMe(String token) async {
    constantService.token = token;
    notifyListeners();

    print('gettingMe');
    var handlingLog = await doHttpGet('user/profile');

    print(handlingLog.success);
    print(handlingLog.data);
    print(handlingLog.message);
    if (handlingLog.success) {
      var user = User.fromJson(handlingLog.data);
      currentUser = user;
      constantService.token = token;

      print("currentUser:");
      print(currentUser);
      print(user);
      _setupUser();

      return user;
    } else {
      constantService.token = null;
    }

    notifyListeners();
    return null;
  }

  void _setupUser() {
    var locator = GetIt.I<NavigationService>();
    locator.currentUser = currentUser;
    locator.currentToken = constantService.token;
  }

  void updateLatestToken() async {
    if (constantService.token == null) {
      return;
    }

    var tokenFromInMemory = await constantService.dbHelper.getFirst(
      TableUser.tokenTableName,
    );

    if (tokenFromInMemory == null) {
      await constantService.dbHelper.insert(TableUser.tokenTableName, {
        "Token": constantService.token,
      });

      return;
    }

    tokenFromInMemory['Token'] = constantService.token;
    await constantService.dbHelper.update(
      TableUser.tokenTableName,
      tokenFromInMemory,
    );
  }

  Future logOut(BuildContext context) async {
    if (currentUser == null || constantService.token == null) {
      return;
    }

    MainPlatform.showLoadingAlert(context, 'logout');

    try {
      await resetToken();
      constantService.token = '';
      constantService.initClient();
      _setupUser();

      MainPlatform.backTransitionPage(context);
      MainPlatform.transitionToPage(context, Login(), newPage: true);
    } catch (e) {
      MainPlatform.backTransitionPage(context);
      MainPlatform.transitionToPage(context, Login(), newPage: true);
    }
  }

  Future<void> resetToken() async {
    await constantService.dbHelper.deleteAll(TableUser.tokenTableName);
  }

  Future<HandlingServerLog> editPhoto(
    File photo,
  ) async {
    print('test foto');
    var handlingLog = await doHttpPutUpload('user/upload/profile', photo);
    print('ini log');
    print(handlingLog);

    if (handlingLog.success) {
      getMe(constantService.token);
    }
    return handlingLog;
  }
}
