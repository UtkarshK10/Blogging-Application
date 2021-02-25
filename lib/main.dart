import 'package:flutter/material.dart';
import 'package:flutterblogapp/LoginRegisterPage.dart';
import 'package:flutterblogapp/HomePage.dart';
import 'package:flutterblogapp/Mapping.dart';
import 'package:flutterblogapp/Authentication.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData.dark(),
//        primaryColor: Colors.blueGrey,
//      ),
      home: MappingPage(auth: Auth(),),
    );
  }
}


