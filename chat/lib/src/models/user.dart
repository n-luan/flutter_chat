class User {
  String _email;
  String _name;
  String _password;
  User(this._email, this._password);

  User.map(dynamic obj) {
    this._email = obj["email"];
    this._name = obj["name"];
    this._password = obj["password"];
  }

  String get email => _email;
  String get name => _name;
  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = _email;
    map["name"] = _name;
    map["password"] = _password;

    return map;
  }
}
