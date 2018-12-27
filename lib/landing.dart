import 'package:flutter/material.dart';
import 'signup.dart';
import 'home.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class LandingPage extends StatefulWidget{
  @override
  MyLandingPageState createState()=> new MyLandingPageState();
}

class MyLandingPageState extends State<LandingPage>{
  BaseAuth auth = new Auth();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  void validateAndSubmit() async{
    try {
      final firebaseUser =auth.SignInWithEmailAndPassword(_emailController.text, _passwordController.text).then((user){
        print("Landing Page ~ Sign in with Email and Password Result : $user");
        var userObject;
        String myUserName;

        Firestore.instance.collection('users').document('$user').get().then((docs){
          var test=docs.data['username'];
          print("the user object from the firestore is $test.");

        });

        Firestore.instance.collection('users').document('$user').get().then((docs){
          if(docs.data.isNotEmpty){
            myUserName=docs.data['username'];
            print("the userName is $myUserName");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MapsDemo(userId:user,userName: myUserName)));
          }else{
            print("Opps there is no document for the user id $user");
          }
        });


      });

    }catch(e){
      print(" the information the user entered firstname 2:$_emailController.text password:$_passwordController.text");
      print(e);
    }
  }
  final _formKey = GlobalKey<FormState>();
  Widget getErrorWidget(FlutterErrorDetails error) {
    return Center(
      child: Text("Error appeared."),
    );
  }
  @override
  Widget build(BuildContext context){
    ErrorWidget.builder = getErrorWidget;
    return Form(
        key: _formKey,
        child:new Scaffold(
        resizeToAvoidBottomPadding: false,
        body:Column(
            children:<Widget>[
              Container(
                  child:new Image.asset(
                      'images/supsuplogo.png',
                      fit:BoxFit.cover,
                      height:210.0
                  )
              ),
              Container(
                  padding:EdgeInsets.only(top:15.0,left:15.0,right: 15.0),
                  child:Column(
                      children:<Widget>[
                        TextFormField(
                          validator: (value) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Enter Valid Email';
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFocus,
                          onFieldSubmitted: (term){
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                          decoration: InputDecoration(
                              labelText:'Email',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)
                              )
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                          },
                          textInputAction: TextInputAction.done,
                          controller: _passwordController,
                          focusNode: _passwordFocus,

                          decoration: InputDecoration(
                              labelText:'PASSWORD',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)
                              )
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20.0),
                        Container(
                            alignment: Alignment(1.0, 0.0),
                            padding:EdgeInsets.only(top:15,left:20.0),
                            child:InkWell(
                              child:Text('Forgot Password',
                                style: TextStyle(
                                    color:Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration:TextDecoration.underline
                                ),
                              ),

                            )
                        ),
                        SizedBox(height: 20.0),
                        Container(
                            height: 40.0,
                            child:Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color:Colors.green,
                                elevation:7.0,
                                child:GestureDetector(
                                    onTap: (){
                                      if (_formKey.currentState.validate()) {
                                        print("Form is Valid");
                                        validateAndSubmit();
                                      }

                                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>MapsDemo()));
                                    },
                                    child:Center(
                                        child:Text(
                                          'LOGIN',
                                          style: TextStyle(
                                              color:Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    )
                                )
                            )

                        ),
                        SizedBox(height: 20.0),
                        Container(
                            height:40.0,
                            color:Colors.transparent,
                            child:Container(
                                decoration:BoxDecoration(
                                    border: Border.all(
                                        color:Colors.black,
                                        style:BorderStyle.solid,
                                        width: 1.0
                                    ),
                                    color:Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:<Widget>[
                                      Center(
                                          child:ImageIcon(AssetImage('images/supsuplogo.png'))
                                      ),

                                      SizedBox(width:10.0),
                                      Center(
                                          child:Text('Log in with Facebook',
                                              style:TextStyle(
                                                  fontWeight: FontWeight.bold
                                              )
                                          )
                                      )
                                    ]
                                )
                            )
                        )
                      ]
                  )
              ),
              SizedBox(height: 20.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    Text(
                        'New to SupSup ?',
                        style:TextStyle(
                            fontFamily: 'Montserrat'
                        )
                    ),
                    SizedBox(width:5.0),
                    InkWell(
                        onTap: (){

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                        },
                        child:Text('Register',
                          style: TextStyle(
                              color:Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration:TextDecoration.underline
                          ),
                        )
                    )
                  ]
              )
            ]

        )
    ));

  }

}