import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:revisit/db_helper/db_helper.dart';

class ConstantService with ChangeNotifier {

  String token;
  String activeUri;
  DatabaseHelper dbHelper;

  ConstantService() {
    initClient();
  }

  void initClient() {
    print('init db');
    dbHelper = DatabaseHelper.instance;
    notifyListeners();

    return developer.log('Current token: $token');
  }

}
