import 'package:auth/forgot.dart';
import 'package:auth/login.dart';
import 'package:auth/new.dart';
import 'package:auth/otp.dart';
import 'package:auth/register.dart';
import 'package:auth/sucess.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (context) => MyLogin(),
      'register': (context) => MyRegister(),
      'sucess': (context) => Sucess(),
      'forgot': (context) => Forgot(),
      'otp': (context) => Otp(),
      'new': (context) => New(),
    },
  ));
}
