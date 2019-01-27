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
  void initState() {
    setState(() {
      widget.auth.CurrentUser().then((uuid){
        print("Root Class - The Current User is : $uuid");
        userId=uuid;
        print("Root Class Build Method - about to get the current user name");
        Firestore.instance.collection('users').document(userId).get().then((docs){
          setState(() {
            authStatus=uuid==null ? AuthStatus.notSignedIn:AuthStatus.signIn;
            myUserName=docs.data['username'];
            print("Root Class Build Method - the userName is $myUserName");
          });

      });
    });
    super.initState();



    });
  }

  @override
  Widget build(BuildContext context)  {

    switch(authStatus){
      case AuthStatus.notSignedIn:
        return LandingPage();
      case AuthStatus.signIn:
        return MapsDemo(userId:userId,userName: myUserName);
    }
    return LandingPage();
  }

}