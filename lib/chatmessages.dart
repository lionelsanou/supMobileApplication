import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'auth.dart';


const String name="Lionel";
class ChatMessages extends StatelessWidget{
final String text;
ChatMessages({this.text});
  @override
  Widget build(BuildContext context){
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
                  child: Text(name[0]),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(name,style: Theme.of(context).textTheme.subhead,),
              new Container(
                margin:const EdgeInsets.only(top: 5.0),
                child: Text(text),
              )
            ],
          )
        ],
      ),
    );
  }
}

