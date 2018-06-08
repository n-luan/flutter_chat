import 'package:chat/src/data/database_helper.dart';
import 'package:flutter/material.dart';

enum AuthState { LOGGED_IN, LOGGED_OUT }

abstract class AuthStateListener {
  void onAuthStateChanged(BuildContext context, AuthState state);
}

// A naive implementation of Observer/Subscriber Pattern. Will do for now.
class AuthStateProvider {
  static final AuthStateProvider _instance = new AuthStateProvider.internal();

  List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;
  AuthStateProvider.internal() {
    _subscribers = new List<AuthStateListener>();
    initState();
  }

  void initState() async {
    var db = new DatabaseHelper();
    var isLoggedIn = await db.isLoggedIn();
    if (isLoggedIn)
      notify(null, AuthState.LOGGED_IN);
    else
      notify(null, AuthState.LOGGED_OUT);
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener) {
    for (var l in _subscribers) {
      if (l == listener) _subscribers.remove(l);
    }
  }

  void notify(BuildContext context, AuthState state) {
    _subscribers
        .forEach((AuthStateListener s) => s.onAuthStateChanged(context, state));
  }
}
