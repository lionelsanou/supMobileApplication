import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'auth.dart';


class MapsDemo extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home:new SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget{
  @override
  MySignupState createState()=> new MySignupState();
}

class MySignupState extends State<SignupPage> with WidgetsBindingObserver {
  BaseAuth auth=new Auth();
  GoogleMapController mapController;

  void _signOut() async{
    await auth.SignOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:new Text('Welcome'),
        actions: <Widget>[
          new FlatButton(onPressed: _signOut, child: new Text('LogOut'))
        ],
      ),
      body:Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 300.0,
              height: 400.0,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
          RaisedButton(
            child: const Text('My Location'),
            onPressed: mapController == null ? null : () {
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                const CameraPosition(
                  bearing: 270.0,
                  target: LatLng(33.886670, -84.255730),
                  tilt: 30.0,
                  zoom: 17.0,
                ),
              ));
            },
          ),
        ],
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
