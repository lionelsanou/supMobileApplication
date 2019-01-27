import 'package:flutter/material.dart';
import 'main.dart';
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
  String firstname;
  String lastname;
  String email;
  String username;
  String password;
  var _userController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController1 = TextEditingController();
  var _passwordController2 = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus1 = FocusNode();
  final FocusNode _passwordFocus2 = FocusNode();

  void validateAndSubmit() async {
    if(_passwordController1.text==_passwordController2.text){
    try {
      final firebaseUser = auth.SignUpWithEmailAndPassword(
          _emailController.text, _passwordController1.text).then((user) {
        print("The UUID of the User is $user.");
        // ToDo below here I want to provide the user object instead of _userController.text
        auth.CreateUser(user, _userController.text);
        // ToDo below here I want to provide the user object instead of user which is the uuid obtained from signup
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyApp.withUser(user)));
      });
    } catch (e) {
      print(
          " the information the user entered firstname 2:$_userController.text lastname:$_emailController.text username:$_passwordController1.text");
      print(e);
    }
  }else{
     print("Passwords are not idenity");
     Scaffold.of(context)
         .showSnackBar(SnackBar(content: Text('Processing Data')));
     //_formKey.currentState.validate();
    }
  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    // Note: This is a `GlobalKey<FormState>`

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body:Form(
            key: _formKey,
            child:ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children:<Widget>[
              Container(
                  padding:EdgeInsets.only(top:15.0,left:15.0,right: 15.0),
                  child:Column(
                      children:<Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the username';
                            }
                          },
                          keyboardType: TextInputType.text,
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                          },
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }else if(value!=_passwordController1.text){
                              return 'Passwords Entered does not match';
                            }
                          },
                          controller:_passwordController2,
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocus2,
                          decoration: InputDecoration(
                              labelText:'CONFIRM PASSWORD',
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
                            child:GestureDetector(
                                    onTap: (){
                                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
                                      //print(" the information the user entered firstname:$firstname lastname:$lastname username:$username");

                                      if (_formKey.currentState.validate()) {
                                        print("Form is Valid");
                                        validateAndSubmit();
                                      }

                                    },
                                    child:Material(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color:Colors.green,
                                        elevation:7.0,
                                        child:Center(
                                        child:Text(
                                          'SignUp',
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
                            child:GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
                                    },
                                    child:Material(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color:Colors.blue,
                                        elevation:7.0,
                                        child:Center(
                                        child:Text(
                                          '<Back',
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

        ))
    );

  }

}