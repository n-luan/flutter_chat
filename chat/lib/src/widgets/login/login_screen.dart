import 'package:flutter/material.dart';
import 'package:chat/src/auth.dart';
import 'package:chat/src/widgets/login/login_screen_presenter.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;

  LoginScreenPresenter _presenter;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }
  @override
  void initState() {
    _firebaseMessaging.configure();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    super.initState();
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        print(token);
        setState(() {
          _presenter.doLogin(_email, _password, token);
        });
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(BuildContext _context, AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      var ctx = (_context == null) ? context : _context;
      Navigator.of(ctx).pushReplacementNamed("/chat");
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN"),
      color: Colors.primaries[0],
    );
    var loginForm = new Column(
      children: <Widget>[
        new Text(
          "Login",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _email = val,
                  validator: (val) {
                    return val.length < 10
                        ? "User name must have atleast 10 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "User name"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        decoration: new BoxDecoration(),
        child: new Center(
          child: new Container(
            child: loginForm,
            height: 300.0,
            width: 300.0,
          ),
        ),
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess() {
    setState(() => _isLoading = false);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(context, AuthState.LOGGED_IN);
  }
}
