import "package:flutter/material.dart";
import "home.dart";
import "auth.dart";
import "landing.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
class Root extends StatefulWidget{

  Root({this.auth, this.userId});
  BaseAuth auth;
  String userId;
  @override
  State<StatefulWidget> createState() {

    return new RootState();
  }
}
enum AuthStatus{
  notSignedIn,
  signIn
}

class RootState extends State<Root>{
  AuthStatus authStatus = AuthStatus.notSignedIn;
  String myUserName="";
  String userId;

  @override
  Widget build(BuildContext context)  {
    setState(() {
      widget.auth.CurrentUser().then((uuid){
        print("Root Class - The Current User is : $uuid");
        userId=uuid;
        setState(() {
          authStatus=uuid==null ? AuthStatus.notSignedIn:AuthStatus.signIn;

        });
        print("Root Class - about to get the current user name : $uuid");

        print("the userName aaaaaaaaaaaaaaaaaa");

        Firestore.instance.collection('users').document(uuid).get().then((docs){
          myUserName=docs.data['username'];
          print("the userName is $myUserName");
          print("the userName isssssssssssssssssssss");
        });
      });
    });


    switch(authStatus){
      case AuthStatus.notSignedIn:
        return LandingPage();
      case AuthStatus.signIn:
        return MapsDemo(userId:userId,userName: myUserName);
    }
    return LandingPage();
  }

}