import 'package:chat/src/data/database_helper.dart';
import 'package:chat/src/data/rest_ds.dart';
import 'package:chat/src/models/auth.dart';

abstract class LoginScreenContract {
  void onLoginSuccess();
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String email, String password, String deviceToken) {
    api.login(email, password, deviceToken).then((Auth auth) {
      var db = new DatabaseHelper();
      db.saveAuth(auth).then((_) {
        _view.onLoginSuccess();
      });
    }, onError: (e) {
      handleError(e);
    }).catchError(handleError);
  }

  handleError(Exception error) {
    _view.onLoginError(error.toString());
  }
}
