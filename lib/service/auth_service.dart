import 'package:revisit/service/constant_service.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'package:revisit/service/network_service.dart';

class AuthService extends NetworkService {
  AuthService(ConstantService constantService) : super(constantService);

  Future<HandlingServerLog> login(
    String identity,
    String password,
  ) async {
    Map<String, String> reqBody = {"username": identity, "password": password};
    HandlingServerLog a = await doHttpPost('user/login', reqBody);
    var newToken = a.data.toString();

    print(a.data);
    print(newToken);

    print('token ^');
    constantService.token = newToken;
    print(constantService.token);
    return a;
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
}
