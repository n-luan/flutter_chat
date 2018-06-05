import 'package:chat/src/widgets/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat/src/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.orangeAccent[400],
);
void main() => runApp(new MaterialApp(
      title: 'Chat App',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new LoginScreen(),
      routes: routes,
    ));
