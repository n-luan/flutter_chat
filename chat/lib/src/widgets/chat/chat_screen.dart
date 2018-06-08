import 'dart:async';
import 'dart:convert';

import 'package:chat/src/constant.dart';
import 'package:chat/src/data/database_helper.dart';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/widgets/chat/chat_message.dart';
import 'package:chat/src/widgets/chat/chat_screen_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin
    implements ChatScreenContract {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  bool _isComposing = false;
  int current_user_id;
  WebSocketChannel channel;
  ChatScreenPresenter _presenter;
  AppLifecycleState _lastLifecyleState;

  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  ChatScreenState() {
    _presenter = new ChatScreenPresenter(this);
  }

  void onLoadMessageSuccess(ListMessage listMessage) {
    setState(() {
      for (var message in listMessage.messages) {
        _messages.add(new ChatMessage(
          current_user_id: current_user_id,
          message: message,
        ));
      }
    });
  }

  void onLoadMessageError(String errorMessage) {}
  void onLogoutSuccess() {
    Navigator.of(context).pushReplacementNamed("/login");
  }

  @override
  void initState() {
    handleAppLifecycleState();
    setupChannel();
    _presenter.loadMessages();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    super.initState();
  }

  void handleAppLifecycleState() {
    SystemChannels.lifecycle.setMessageHandler((msg) {
      debugPrint('SystemChannels> $msg');
      setState(() {
        switch (msg) {
          case "AppLifecycleState.paused":
            _lastLifecyleState = AppLifecycleState.paused;
            break;
          case "AppLifecycleState.inactive":
            _lastLifecyleState = AppLifecycleState.inactive;
            break;
          case "AppLifecycleState.resumed":
            _lastLifecyleState = AppLifecycleState.resumed;
            _presenter.readAll();
            break;
          case "AppLifecycleState.suspending":
            _lastLifecyleState = AppLifecycleState.suspending;
            break;
          default:
        }
      });
    });
  }

  void _getMoreData() {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      _presenter.loadMessages();
      setState(() {
        isPerformingRequest = false;
      });
    }
  }

  void setupChannel() {
    var db = new DatabaseHelper();
    db.getAuth().then((auth) {
      current_user_id = auth.id;
      channel = new IOWebSocketChannel.connect(socketUrl, headers: {
        "UID": auth.uid,
        "ACCESS_TOKEN": auth.accessToken,
        "CLIENT_ID": auth.clientId
      });

      channel.sink.add(json.encode({
        "command": "subscribe",
        "identifier": "{\"channel\":\"RoomChannel\"}"
      }));

      channel.stream.listen(onData);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    channel.sink.add(json.encode({
      "command": "message",
      "identifier": "{\"channel\":\"RoomChannel\"}",
      "data": "{\"action\":\"speak\", \"message\":\"${text}\"}"
    }));
  }

  void dispose() {
    for (ChatMessage message in _messages)
      if (message.animationController != null)
        message.animationController.dispose();

    channel.sink.close();
    _scrollController.dispose();
    super.dispose();
  }

  void logout() {
    _presenter.logout();
  }

  void onData(_data) {
    var data = JSON.decode(_data);
    switch (data["type"]) {
      case "ping":
        break;
      case "welcome":
      case "confirm_subscription":
        print("Connected");
        break;
      default:
        print(data.toString());
    }

    if (data["identifier"] == "{\"channel\":\"RoomChannel\"}" &&
        data["type"] != "confirm_subscription") {
      var msg = Message.map(data["message"]["message"]);

      ChatMessage message = new ChatMessage(
        current_user_id: current_user_id,
        message: msg,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 700),
          vsync: this,
        ),
      );
      setState(() {
        _messages.insert(0, message);
      });
      _scrollController.jumpTo(0.0);
      message.animationController.forward();

      if (_lastLifecyleState == AppLifecycleState.resumed ||
          _lastLifecyleState == null) {
        _presenter.readAll();
      }
    }
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border:
                      new Border(top: new BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Room"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: logout,
          )
        ],
      ),
      body: new Container(
          child: new Column(children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                controller: _scrollController,
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border:
                      new Border(top: new BorderSide(color: Colors.grey[200])))
              : null), //new
    );
  }
}
