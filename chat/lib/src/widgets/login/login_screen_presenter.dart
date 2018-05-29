import 'dart:developer';

import 'package:chat/src/data/rest_ds.dart';
import 'package:chat/src/models/auth.dart';
import 'package:chat/src/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(Auth user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String email, String password) {
    api.login(email, password).then((Auth auth) {
      _view.onLoginSuccess(auth);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }
}
