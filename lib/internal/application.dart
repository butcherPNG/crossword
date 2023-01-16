import 'package:crossword/presentation/crossword.dart';
import 'package:flutter/material.dart';

import '../presentation/creationOfCrossword.dart';
import '../presentation/home.dart';


class Application extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      routes: {
        '/': (context) => Home(),

      },
    );
  }
}