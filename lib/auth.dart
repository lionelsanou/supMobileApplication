import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'dart:async';
import 'user.dart';


abstract class BaseAuth{
  Future<User> SignInWithEmailAndPassword(String email, String password);
  Future<User> SignUpWithEmailAndPassword(String email, String password);
  Future<User> CurrentUser();
  Future<void> SignOut();
}

class Auth implements BaseAuth{
  User user = new User();
  Future<User> SignInWithEmailAndPassword(String email, String password) async{
    print("the user email is $email and password is $password");
    final firebaseUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print("the firebase user is 1 $firebaseUser");
    user.setUuid(firebaseUser.uid);
    user.setEmail(firebaseUser.email);
    return user;
  }

  Future<User> SignUpWithEmailAndPassword(String email, String password) async{
    print("the user email is $email and password is $password");
    final firebaseUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print("the firebase user is 2 $firebaseUser");
    user.setUuid(firebaseUser.uid);
    user.setEmail(firebaseUser.email);
    return user;
  }
  Future<User> CurrentUser() async{
    final firebaseUser = await FirebaseAuth.instance
        .currentUser();
    print("getting current state $firebaseUser");
    user.setUuid(firebaseUser.uid);
    user.setEmail(firebaseUser.email);
    return user;
  }

  Future<void> SignOut() async{

    return await FirebaseAuth.instance.signOut();

  }
}