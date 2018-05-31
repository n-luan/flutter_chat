class User {
  int _id;
  String _email;
  String _name;
  String _avatar;
  String _password;
  User(this._email, this._password);

  User.map(dynamic obj) {
    this._id = obj["id"];
    this._email = obj["email"];
    this._name = obj["name"];
    this._avatar = obj["avatar"];
    this._password = obj["password"];
  }

  int get id => _id;
  String get email => _email;
  String get name => _name;
  String get password => _password;
  String get avatar => _avatar;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["email"] = _email;
    map["name"] = _name;
    map["_avatar"] = _avatar;
    map["password"] = _password;

    return map;
  }
}
