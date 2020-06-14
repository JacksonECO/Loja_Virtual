import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jackson's Store",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255,4,125,141),
      ),
      home: HomeScreen(),
    );
  }
}