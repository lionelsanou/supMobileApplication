import 'package:flutter_app/chatting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'auth.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapsDemo extends StatelessWidget {
  String userId;
  String userName;

  MapsDemo({this.userId, this.userName});

  @override
  Widget build(BuildContext context) {
    print("Map Page ~ My UserName is $userName");
    print("Map Page ~ My UserId is   $userId");
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MapPage(userId: this.userId, userName: this.userName),
    );
  }
}

class MapPage extends StatefulWidget {
  String userId;
  String userName;

  MapPage({this.userId, this.userName});

  static Future<void> camrecorder() async {
    List<CameraDescription> cameras = await availableCameras();
  }

  @override
  MySignupState createState() => new MySignupState();
}

class MySignupState extends State<MapPage> {
  List<CameraDescription> cameras;
  bool _isReady = false;
  bool isTrue = true;
  CameraController camController;
  BaseAuth auth = new Auth();
  GoogleMapController mapController;
  String chatMate;
  var clients = [];
  var currentLocation;
  bool mapToggle = false;

  void initState() {

    _setupCameras();
    Geolocator().getCurrentPosition().then((position) {
      setState(() {
        currentLocation = position;
        mapToggle = true;
        String userId = widget.userId;
        String userName = widget.userName;
        print("my current postion is $position");
        auth.AddLocationToServer(userId, userName, currentLocation.latitude,
                currentLocation.longitude)
            .then((response) {
          populateClient();
        });
      });
    });

    //String test = widget.cameras;
    //print("biedildld $test");

    //print("biedildld $widget.cameras[0]");
    super.initState();
  }

  //RemoveUserFromServer
  void dispose() {
    print("Disposing the Map Widget");
    String userId = widget.userId;
    auth.RemoveUserFromServer(userId);
    camController?.dispose();
    super.dispose();
  }

  Future<void> _setupCameras() async {
    try {
      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      print("~~~~~~~~~~~~~~~~~~ $cameras");
      camController = new CameraController(cameras[1], ResolutionPreset.medium);
      await camController.initialize();
    } on CameraException catch (e) {
      print("--jjklllkjhhh-------$e");
    }
    if (!mounted) return;
    setState(() {
      _isReady = true;
      var t = camController.value.aspectRatio;
      print("camController.value.aspectRatio------------$t");
    });
  }

  populateClient() {
    Firestore.instance.collection('maps').snapshots().listen((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          clients.add(docs.documents[i].data);
          initMarker(docs.documents[i].data);
        }
      }
    });

  }

  initMarker(client) {
    mapController.clearMarkers().then((val) {
      mapController.addMarker(MarkerOptions(
        position: LatLng(client['latitude'], client['longitude']),
        infoWindowText: InfoWindowText(client['username'], 'nice'),
        //icon: BitmapDescriptor.fromAsset('images/humanicon.png',)
      ));
    });
    //Marker t = new Marker.
    mapController.onMarkerTapped.add((marker) {
      chatMate = marker.options.infoWindowText.title;
      String latitude = marker.options.position.latitude.toString();
      String longitude = marker.options.position.longitude.toString();
      print("the username of the user is $chatMate");
      setState(() {});
    });
  }

  final ArgumentCallbacks<Marker> onMarkerTapped = ArgumentCallbacks<Marker>();

  void _signOut() async {
    dispose();
    auth.RemoveUserFromServer(widget.userId);
    await auth.SignOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    print("my chat mate is $chatMate");
    String userNameT = widget.userName;
    //String uuid=widget.userId;
    //print("mhfslfjsdfjskdfsldfjsdkfj $uuid");
    return Scaffold(
        appBar: AppBar(
          title: new Text('Welcome $userNameT'),
          actions: <Widget>[
            new FlatButton(onPressed: _signOut, child: new Text('LogOut'))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 300.0,
                  height: 300.0,
                  child: mapToggle
                      ? GoogleMap(
                          onMapCreated: _onMapCreated,
                          options: GoogleMapOptions(
                              //mapType: MapType.satellite,
                              cameraPosition: CameraPosition(
                                  target: LatLng(currentLocation.latitude,
                                      currentLocation.longitude),
                                  bearing: 270.0,
                                  tilt: 30.0,
                                  zoom: 25.0)),
                        )
                      : Center(
                          child: Text(
                          'Loading Please wait ....',
                          style: TextStyle(fontSize: 20.0),
                        )),
                ),
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          height: 180.0,
                          width: 130.0,
                          child: CameraPreview(camController)),
                    ],
                  ),
                  SizedBox(width: 50.0),
                  GestureDetector(
                      onTap: () {
                        print("you have clicked on the image icon");
                        print("myyyy chat mate is $chatMate");
                        String myUserName = widget.userName;
                        print("My user name chat is $myUserName");
                        String uuid=widget.userId;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChattingRoom(uuid:uuid,
                                    from: myUserName, to: chatMate)));
                      },
                      child: chatMate != null
                          ? Container(
                              height: 180.0,
                              width: 130.0,
                              child: Text(
                                'Click Me and Start Chatting with $chatMate',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ))
                          : //CameraPreview(camController)):
                          Container(
                              height: 180.0,
                              width: 130.0,
                              child: Text(
                                'Pick Someone to chat With',
                                style: TextStyle(fontSize: 20.0),
                              )))
                ],
              )
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
