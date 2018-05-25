import 'package:flutter/material.dart';
import 'package:chat/src/widgets/home/chat_screen.dart';
import 'package:chat/src/widgets/login/login_screen.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/chat': (BuildContext context) => new FriendlychatApp(),
  '/': (BuildContext context) => new LoginScreen(),
};
