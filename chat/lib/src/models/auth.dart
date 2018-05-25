import 'dart:convert';

import 'dart:developer';

class Auth {
  int _id;
  String _email;
  String _name;
  String _avatar;

  String _accessToken;
  String _uid;
  String _clientId;
  Auth(this._uid, this._accessToken);

  Auth.map(dynamic response) {
    var obj = JSON.decode(response.body)["data"];
    var headers = response.headers;

    this._id = obj["id"];
    this._email = obj["email"];
    this._name = obj["name"];
    this._avatar = obj["avatar"];
    this._accessToken = headers["access-token"];
    this._clientId = headers["client"];
    this._uid = headers["uid"];
  }

  Auth.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._email = obj["email"];
    this._name = obj["name"];
    this._avatar = obj["avatar"];

    this._uid = obj["uid"];
    this._accessToken = obj["accessToken"];
    this._clientId = obj["clientId"];
  }

  int get id => _id;
  String get email => _email;
  String get name => _name;
  String get avatar => _avatar;
  String get uid => _uid;
  String get accessToken => _accessToken;
  String get clientId => _clientId;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["email"] = _email;
    map["name"] = _name;
    map["avatar"] = _avatar;
    map["uid"] = _uid;
    map["accessToken"] = _accessToken;
    map["clientId"] = _clientId;

    return map;
  }
}
