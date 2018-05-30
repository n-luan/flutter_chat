import 'dart:developer';

import 'package:chat/src/data/rest_ds.dart';
import 'package:chat/src/models/auth.dart';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';

abstract class ChatScreenContract {
  void onLoadMessageSuccess(ListMessage messages);
  void onLoadMessageError(String errorMessage);
}

class ChatScreenPresenter {
  ChatScreenContract _view;
  RestDatasource api = new RestDatasource();
  ChatScreenPresenter(this._view);
  int current_page = 0;
  loadMessages() {
    api.getMessages(current_page + 1).then((ListMessage messages) {
      if (current_page < messages.total_pages) {
        current_page++;
      }
      _view.onLoadMessageSuccess(messages);
    }).catchError(
        (Exception error) => _view.onLoadMessageError(error.toString()));
  }
}
