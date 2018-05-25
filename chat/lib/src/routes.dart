import 'package:flutter/material.dart';
import 'package:chat/src/widgets/home/home_screen.dart';
import 'package:chat/src/widgets/login/login_screen.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new HomeScreen(),
  '/' :          (BuildContext context) => new LoginScreen(),
};
