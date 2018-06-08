import 'dart:async';
import 'dart:convert';

import 'package:chat/src/constant.dart';
import 'package:chat/src/data/database_helper.dart';
import 'package:chat/src/models/auth.dart';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/utils/network_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();

  Future<Auth> login(String email, String password, String deviceToken) {
    var loginUrl = "$backendUrl/api/auth/sign_in";
    return _netUtil.post(loginUrl, body: {
      "email": email,
      "password": password,
      "device_token": deviceToken,
    }).then((dynamic res) {
      var body = JSON.decode(res.body);

      print(body.toString());
      if (body["error"] != null) throw new Exception(body["error_msg"]);
      return new Auth.map(res, deviceToken);
    });
  }

  Future<ListMessage> getMessages(int page) {
    var messageUrl = "$backendUrl/api/messages?page=$page";
    return getHeaders().then((dynamic headers) {
      return _netUtil.get(messageUrl, headers).then((dynamic res) {
        var body = JSON.decode(res.body);

        print(body.toString());
        if (body["error"] != null) throw new Exception(body["error_msg"]);

        return new ListMessage.map(body);
      });
    });
  }

  Future logout() {
    var messageUrl = "$backendUrl/api/auth/sign_out";
    return getHeaders().then((dynamic headers) {
      return _netUtil.delete(messageUrl, headers: headers).then((dynamic res) {
        var body = JSON.decode(res.body);

        print(body.toString());
        if (body["error"] != null) throw new Exception(body["error_msg"]);

        return;
      });
    });
  }

  Future<dynamic> readAll() {
    var userRoomUrl = "$backendUrl/api/user_room";
    return getHeaders().then((dynamic headers) {
      return _netUtil
          .put(userRoomUrl, body: {}, headers: headers)
          .then((dynamic res) {
        try {
          var body = JSON.decode(res.body);
          print(body.toString());
          if (body["error"] != null) throw new Exception(body["error_msg"]);
          return body;
        } catch (_) {
          return {};
        }
      });
    });
  }

  Future<dynamic> getHeaders() async {
    var db = new DatabaseHelper();
    var auth = await db.getAuth();
    return {
      "UID": auth.uid,
      "ACCESS_TOKEN": auth.accessToken,
      "DEVICE_TOKEN": auth.deviceToken,
      "CLIENT": auth.clientId
    };
  }
}
