import 'package:flutter/material.dart';
import 'package:todolist/View/Home.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        accentColor: Colors.purpleAccent,
      ),
      home: Home(),
    ),
  );
}
