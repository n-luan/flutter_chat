import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat/src/models/auth.dart';
import 'package:chat/src/utils/network_util.dart';
import 'package:http/http.dart' as http;

const String backendUrl = "http://192.168.0.24:3000";

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final LOGIN_URL = "$backendUrl/api/auth/sign_in";

  Future<Auth> login(String email, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "email": email,
      "password": password,
    }).then((dynamic res) {
      var body = JSON.decode(res.body);

      print(body.toString());
      if (body["error"] != null) throw new Exception(body["error_msg"]);
      return new Auth.map(res);
    });
  }
}
