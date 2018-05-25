// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:convert';

import 'package:chat/src/data/database_helper.dart';
import 'package:chat/src/models/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(new FriendlychatApp());
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.orangeAccent[400],
);

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Room';

    return new MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ChatScreen(
        title: title,
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.id,
      this.current_user_id,
      this.name,
      this.text,
      this.animationController});
  final int id;
  final int current_user_id;
  final String text;
  final String name;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    if (current_user_id == id) {
      return _buildRight(context);
    } else {
      return _build(context);
    }
  }

  Widget _build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(name[0])),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(name, style: Theme.of(context).textTheme.title),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildRight(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(name, style: Theme.of(context).textTheme.title),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0, right: 4.0),
                      child: new Text(text),
                    ),
                  ],
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(right: 16.0, left: 2.0),
                child: new CircleAvatar(child: new Text(name[0])),
              ),
            ],
          ),
        ));
  }
}

class ChatScreen extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  ChatScreen({Key key, @required this.title, this.channel}) : super(key: key);
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  bool _isComposing = false;
  int current_user_id;
  WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    setupChannel();
    // widget.channel.sink.add(json.encode({
    //   "command": "subscribe",
    //   "identifier": "{\"channel\":\"RoomChannel\"}"
    // }));

    // widget.channel.stream.listen(onData);
  }

  void setupChannel() async {
    var db = new DatabaseHelper();
    var auth = await db.getAuth();

    setState(() {
      current_user_id = auth.id;
      channel = new IOWebSocketChannel.connect('ws://192.168.0.24:3000/cable',
          headers: {
            "UID": auth.uid,
            "ACCESS_TOKEN": auth.accessToken,
            "CLIENT_ID": auth.clientId
          });
    });

    channel.sink.add(json.encode({
      "command": "subscribe",
      "identifier": "{\"channel\":\"RoomChannel\"}"
    }));

    channel.stream.listen(onData);
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    // channel.sink.add(json.encode({
    //   "command": "subscribe",
    //   "identifier": "{\"channel\":\"RoomChannel\"}"
    // }));

    channel.sink.add(json.encode({
      "command": "message",
      "identifier": "{\"channel\":\"RoomChannel\"}",
      "data": "{\"action\":\"speak\", \"message\":\"${text}\"}"
    }));

    // ChatMessage message = new ChatMessage(
    //   text: text,
    //   animationController: new AnimationController(
    //     duration: new Duration(milliseconds: 700),
    //     vsync: this,
    //   ),
    // );
    // setState(() {
    //   _messages.insert(0, message);
    // });
    // message.animationController.forward();
  }

  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    widget.channel.sink.close();
    super.dispose();
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
      var id = data["message"]["message"]["user"]["id"];
      var name = data["message"]["message"]["user"]["name"];
      var text = data["message"]["message"]["text"];

      ChatMessage message = new ChatMessage(
        current_user_id: current_user_id,
        id: id,
        name: name,
        text: text,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 700),
          vsync: this,
        ),
      );
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
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
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
      body: new Container(
          child: new Column(children: <Widget>[
            new Flexible(
                child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
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
