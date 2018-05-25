import 'package:flutter/material.dart';

class ChatLogin extends StatefulWidget {
  final String title = "Login";
  ChatLogin();

  @override
  State createState() => new _ChatLoginState();
}

class _ChatLoginState extends State<ChatLogin> {
  String name;
  bool sending = false;
  TextEditingController _name_controller = new TextEditingController();
  TextEditingController _password_controller = new TextEditingController();

  _ChatLoginState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          child: new Column(
            children: <Widget>[
              new TextFormField(
                controller: _name_controller,
                decoration: new InputDecoration(labelText: 'Username'),
              ),
              new TextFormField(
                obscureText: true,
                controller: _password_controller,
                decoration: new InputDecoration(labelText: 'Password'),
              ),
              sending
                  ? new CircularProgressIndicator()
                  : new RaisedButton(
                      onPressed: () {
                        setState(() => sending = true);
                        setState(() => sending = false);
                        // restApp.authenticate(type: 'local', credentials: {
                        //   'username': username,
                        //   'password': password
                        // }).then((auth) {
                        //   // Alert the parent widget that we've logged in!
                        //   handleAuth(auth);
                        // }).catchError((e) {
                        //   // If we fail to log-in, tell the user that something went wrong.
                        //   showDialog(
                        //       context: context,
                        //       child: new SimpleDialog(
                        //         title: new Text('Login Error: $e'),
                        //       ));
                        // }).whenComplete(() {
                        //   setState(() => sending = false);
                        // });
                      },
                      color: Theme.of(context).primaryColor,
                      highlightColor: Theme.of(context).highlightColor,
                      child: new Text(
                        'SUBMIT',
                        style: new TextStyle(color: Colors.white),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
