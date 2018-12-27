import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class BaseAuth{
  Future<String> SignInWithEmailAndPassword(String email, String password);
  Future<String> SignUpWithEmailAndPassword(String email, String password);
  Future<String> CurrentUser();
  Future<void> AddLocationToServer(String uuid,double latitude,double longitude);
  Future<void> SignOut();
  void CreateUser(String uuid,String username);
  Future<QuerySnapshot> getAllUsers();
}

class Auth implements BaseAuth{
  Future<String> SignInWithEmailAndPassword(String email, String password) async{
    print("the user email is $email and password is $password");
    final firebaseUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print("the firebase user is 1 $firebaseUser");
    return firebaseUser.uid;
  }

  Future<String> SignUpWithEmailAndPassword(String email, String password) async{
    print("the user email is $email and password is $password");
    final firebaseUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print("the firebase user is 2 $firebaseUser");
    return firebaseUser.uid;
  }
  Future<String> CurrentUser() async{
    final firebaseUser = await FirebaseAuth.instance
        .currentUser();
    print("getting current state $firebaseUser");
    return firebaseUser.uid;
  }

  void CreateUser(String uuid,String username){
    print("~~~~~~~~~~~~~~~~~~$uuid");
    final firebaseUser =Firestore.instance.collection('users').document(uuid)
        .setData({ 'username': username });

  }

  Future<void> AddLocationToServer(String uuid,double latitude,double longitude){
    return Firestore.instance.collection('users').document(uuid)
        .updateData({
          'latitude': latitude,
          'longitude':longitude

        });
  }

  Future<QuerySnapshot> getAllUsers(){
    return Firestore.instance.collection('users').getDocuments();


  }

  Future<void> SignOut() async{

    return await FirebaseAuth.instance.signOut();

  }
}