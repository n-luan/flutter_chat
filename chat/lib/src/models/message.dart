import 'dart:developer';

import 'package:chat/src/models/user.dart';

class Message {
  int _id;
  String _text;
  String _name;
  DateTime _created_at;
  User _user;

  Message.map(dynamic obj) {
    this._id = obj["id"];
    this._text = obj["text"];
    this._user = new User.map(obj["user"]);
    this._name = obj["name"];
    this._created_at = DateTime.parse(obj["created_at"]);
  }

  int get id => _id;
  String get text => _text;
  String get name => _name;
  DateTime get created_at => _created_at;
  User get user => _user;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["text"] = _text;
    map["name"] = _name;
    map["user"] = _user;
    map["created_at"] = _created_at;

    return map;
  }
}

class ListMessage {
  int _current_page;
  int _count;
  int _total_pages;
  int _total_count;
  List<Message> _messages = <Message>[];

  int get current_page => _current_page;
  int get count => _count;
  int get total_pages => _total_pages;
  int get total_count => _total_count;
  List<Message> get messages => _messages;

  ListMessage.map(dynamic obj) {
    this._current_page = obj["current_page"];
    this._count = obj["count"];
    this._total_pages = obj["total_pages"];
    this._total_count = obj["total_count"];

    for (final x in obj["messages"]) {
      this._messages.add(new Message.map(x));
    }
  }
}
