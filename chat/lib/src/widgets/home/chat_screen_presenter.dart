import 'dart:developer';

import 'package:chat/src/data/rest_ds.dart';
import 'package:chat/src/models/message.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

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

      updateBadger();
      _view.onLoadMessageSuccess(messages);
    }).catchError(
        (Exception error) => _view.onLoadMessageError(error.toString()));
  }

  void readAll() {
    api.readAll().then((dynamic _) {
      updateBadger();
    });
  }

  void updateBadger() async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      // FlutterAppBadger.updateBadgeCount(1);
      FlutterAppBadger.removeBadge();
    }
  }
}
