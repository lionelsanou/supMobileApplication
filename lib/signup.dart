import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'auth.dart';


class Signup extends StatelessWidget{
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

class MySignupState extends State<SignupPage> with WidgetsBindingObserver{

  BaseAuth auth=new Auth();
  final _formKey=GlobalKey<FormState>();
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

  void validateAndSubmit() async{
    try {
      final firebaseUser =auth.SignUpWithEmailAndPassword(_emailController.text, _passwordController1.text).then((user){
        print("The UUID of the User is $user.");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
      });

    }catch(e){
      print(" the information the user entered firstname 2:$_userController.text lastname:$_emailController.text username:$_passwordController1.text");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body:ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children:<Widget>[
              Container(
                  padding:EdgeInsets.only(top:15.0,left:15.0,right: 15.0),
                  child:Column(
                      children:<Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _userController,
                          textInputAction: TextInputAction.next,
                          focusNode: _usernameFocus,
                          onFieldSubmitted: (term){
                            FocusScope.of(context).requestFocus(_passwordFocus1);
                          },
                          decoration: InputDecoration(
                              labelText:'USERNAME',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)
                              )
                          ),
                          onSaved: (value)=> username=value,
                        ),

                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFocus,
                            onFieldSubmitted: (term){
                              FocusScope.of(context).requestFocus(_usernameFocus);
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
                          onSaved: (value)=> firstname=value,
                        ),

                        SizedBox(height: 20.0),
                        TextFormField(
                          controller:_passwordController1,
                          textInputAction: TextInputAction.next,
                          focusNode: _passwordFocus1,
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
                        TextFormField(
                          controller:_passwordController2,
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocus2,
                          decoration: InputDecoration(
                              labelText:'Confirm PASSWORD',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)
                              )
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 30.0),
                        Container(
                            height: 40.0,
                            child:Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color:Colors.green,
                                elevation:7.0,
                                child:GestureDetector(
                                    onTap: (){
                                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
                                      //print(" the information the user entered firstname:$firstname lastname:$lastname username:$username");
                                      validateAndSubmit();
                                    },
                                    child:Center(
                                        child:Text(
                                          'Sign Up',
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
                            height: 40.0,
                            child:Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color:Colors.blue,
                                elevation:7.0,
                                child:GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
                                    },
                                    child:Center(
                                        child:Text(
                                          'Back To SignUp',
                                          style: TextStyle(
                                              color:Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    )
                                )
                            )

                        ),

                      ]
                  )
              ),

            ]

        )
    );

  }

}