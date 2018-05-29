import 'package:chat/src/models/user.dart';

class Message {
  String _text;
  String _name;
  String _password;
  User _user;
  Message(this._text, this._password);

  Message.map(dynamic obj) {
    this._text = obj["text"];
    this._user = obj["user"];
    this._name = obj["name"];
    this._password = obj["password"];
  }

  String get text => _text;
  String get name => _name;
  String get password => _password;
  User get user => _user;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["text"] = _text;
    map["name"] = _name;
    map["user"] = _user;
    map["password"] = _password;

    return map;
  }
}
