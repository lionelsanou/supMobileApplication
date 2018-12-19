import "package:flutter/material.dart";
import "main.dart";
import "home.dart";
import "auth.dart";
import "landing.dart";
import "home.dart";

class Root extends StatefulWidget{

  Root({this.auth});
  BaseAuth auth;
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
  @override
  void initState() {

    super.initState();
    widget.auth.CurrentUser().then((user){
      print("loading $user.getEmail()");
      setState(() {
        authStatus=user.getUuid()==null ? AuthStatus.notSignedIn:AuthStatus.signIn;
      });
    });

  }
  @override
  Widget build(BuildContext context){
    switch(authStatus){
      case AuthStatus.notSignedIn:
        return LandingPage();
      case AuthStatus.signIn:
        return MapsDemo();
    }
    return LandingPage();
  }
}