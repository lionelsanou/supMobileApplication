import 'package:flutter/material.dart';
import 'signup.dart';
import 'home.dart';
import 'root.dart';
import 'landing.dart';
import 'auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home:new Root(auth:new Auth()),
    );
   }
}

