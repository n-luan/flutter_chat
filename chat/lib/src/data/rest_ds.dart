import 'dart:async';

import 'package:chat/src/utils/network_util.dart';
import 'package:chat/src/models/user.dart';

const String backendUrl = "http://192.168.0.24:3000";

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final LOGIN_URL = "$backendUrl/api/auth/sign_in";

  Future<User> login(String email, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "email": email,
      "password": password,
    }).then((dynamic res) {
      print(res.toString());
      if (res["error"] != null) throw new Exception(res["error_msg"]);
      return new User.map(res["data"]);
    });
  }
}
