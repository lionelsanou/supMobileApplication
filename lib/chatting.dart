import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'auth.dart';
import 'chatmessages.dart';

String groupChatIdString;
class ChattingRoom extends StatelessWidget{
   String from;
   String to;
   String uuid;
  ChattingRoom({this.uuid,this.from,this.to});
  @override
  Widget build(BuildContext context){
    print("Inside Chatting Room $to");
    print("Inside Chatting Room the UUID $uuid");
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home:new ChattingPage(uuid:this.uuid,fromUser:this.from,toUser:this.to)
    );
  }
}

class ChattingPage extends StatefulWidget{
  String fromUser;
  String toUser;
  String uuid;
  ChattingPage({this.uuid,this.fromUser,this.toUser});
  @override
  MyChattingState createState()=> new MyChattingState();
}

class MyChattingState extends State<ChattingPage> with WidgetsBindingObserver {


  final textEditingController = TextEditingController();
  final List<ChatMessages> messagesArray = <ChatMessages>[];
  BaseAuth auth = new Auth();
  final _formKey = GlobalKey<FormState>();
  String firstname;
  String lastname;
  String email;
  String username;
  String password;
  var _userController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController1 = TextEditingController();
  var _passwordController2 = TextEditingController();
  final FocusNode _firstnameFocus = FocusNode();
  final FocusNode _lastnameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus1 = FocusNode();
  final FocusNode _passwordFocus2 = FocusNode();



  Widget textComposeWidget() {
    return IconTheme(
        data: IconThemeData(color: Colors.blue),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: new TextField(
                      decoration: new InputDecoration.collapsed(
                          hintText: "Send a Message"),
                      controller: textEditingController,
                     // onSubmitted: handleSubmittedText,
                    )
                ),
                new Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(icon: Icon(Icons.send),
                    onPressed: () =>
                        handleSubmittedText(textEditingController.text,groupChatIdString),

                  ),

                )
              ],
            )
        ));
  }

  void handleSubmittedText(String text,String groupChatIdString) {
    textEditingController.clear();
    print("I have submitted $groupChatIdString");
    print("the widget is $widget.toUser");
    var db = Firestore.instance;
    db.collection("chat_room").document(groupChatIdString).collection(groupChatIdString).add({
      "user_name": widget.fromUser,
      "message": text,
      "created_at": DateTime.now()
    }).then((val) {
      print("sucess");
    }).catchError((err) {
      print(err);
    });
    // ChatMessages messages = new ChatMessages(
    //   text:text
    // );
    // setState(() {
    //  messagesArray.insert(0, messages);
    //});
  }
Future<bool> _onBackPressed(){
  Navigator.pop(context);
  return Future.value(false);
  }
  @override
  Widget build(BuildContext context) {
    String fromUser=widget.fromUser;
    String toUser=widget.toUser;
    String uuid=widget.uuid;
    int fromHashId= fromUser.hashCode;
    int toHashId=toUser.hashCode;
    int groupChatId=0;
    if (fromHashId <= toHashId) {
      groupChatId = fromHashId-toHashId;
      print("fromHashId $fromHashId");
      print("toHashId $toHashId");
    } else {
      groupChatId = toHashId-fromHashId;
      print("fromHashId $fromHashId");
      print("toHashId $toHashId");
    }
    groupChatIdString=groupChatId.toString();
    print("groupChatIdString $groupChatIdString");

    return new WillPopScope(
        onWillPop:_onBackPressed,

        child:Scaffold(

        appBar: AppBar(

          title: new Text('$fromUser chats with $toUser'),
          actions: <Widget>[
            new FlatButton(onPressed: (){
              print("testing $uuid");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp.withUser(uuid)));
            }, child: new Text('<Back')),
            new FlatButton(onPressed: (){
              print("testing $uuid");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp.withUser(uuid)));
            }, child: new Text('Profile'))
          ],
        ),

        body: new Column(
          children: <Widget>[
            Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("chat_room").document(groupChatIdString).collection(groupChatIdString)
                      .orderBy("created_at", descending: false).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      // padding: new EdgeInsets.all(8.0),
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document = snapshot.data
                            .documents[index];
                        bool isOwnMessage = false;
                        if (document['user_name'] == widget.fromUser) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage ?
                        ownMessage(
                            document['message'], document['user_name']
                        ) : _message(
                            document['message'], document['user_name']
                        );
                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  },

                )

            ),
            new Divider(height: 1.0,),
            new Container(
              decoration: new BoxDecoration(
                //color: Colors.blue,

              ),
              child: textComposeWidget(),
            )
          ],
        )
      //textComposeWidget()
    ));
  }

  Widget ownMessage(String message, String userName) {
    return new Container(
      //width: 100.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[


              new Container(
                margin: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  child: Text(userName[0]),
                ),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(userName, style: Theme
                      .of(context)
                      .textTheme
                      .subhead,),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(message),
                  )


                ],
              ),


            ]));
  }


  Widget _message(String message, String userName) {
    return new Container(
      //width: 100.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


              new Container(
                margin: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  child: Text(userName[0]),
                ),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(userName, style: Theme
                      .of(context)
                      .textTheme
                      .subhead,),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(message),
                  )


                ],
              ),


            ]));
  }
}
