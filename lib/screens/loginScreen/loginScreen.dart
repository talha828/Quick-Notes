import 'dart:io';

import 'package:alert_dialog/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/screens/mainScreen/mainScreen.dart';
import 'package:quick_notes/screens/signUpScreen/signUpScreen.dart';
import 'package:quick_notes/widgets/quickButton.dart';
import 'package:quick_notes/widgets/quickTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool fill1 = false;
  bool fill2 = false;
  bool isLoading=false;
  void setLoading(bool value){
    setState(() {
      isLoading=value;
    });
  }
  void loginAccount(String email, String password) {
    FocusScope.of(context).requestFocus(FocusNode());
    setLoading(true);
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.length > 0 && password.length > 0) {
        if (password.length > 5 && password != null) {
          if (emailValid) {
            FirebaseAuth _auth = FirebaseAuth.instance;
            _auth.signInWithEmailAndPassword(
                email: email, password: password)
                .catchError((e) {
              setLoading(false);
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text('Something went wrong?'),
                  content: new Text('Please check your internet connection'),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: new Text(
                        'Ok',
                        style: TextStyle(color: Color(0xff407BFF)),
                      ),
                    ),
                  ],
                ),
              );
            })
                .then(
                  (value)async {
                setLoading(false);
                SharedPreferences pref=await SharedPreferences.getInstance();
                pref.setString("email", email);
                pref.setString("password",password);
                Navigator.push(
                    context,
                    PageTransition(
                        child: MainScreen(),
                        type: PageTransitionType.rightToLeftPop,
                        childCurrent: SignUpScreen(),
                        duration: Duration(seconds: 1)));},
            );
          } else {
            setLoading(false);
            alert(
              context,
              title: Text('Email is not valid'),
              content: Text('Please check your email'),
              textOK: Text('OK'),
            );
          }
        } else {
          setLoading(false);
          alert(
            context,
            title: Text('Password is not valid'),
            content: Text('Please check your Password'),
            textOK: Text('OK'),
          );
        }
    } else {
      setLoading(false);
      alert(
        context,
        title: Text('All field are required'),
        content: Text('Please fill all fields'),
        textOK: Text('OK'),
      );
    }
  }
  @override
  void dispose() {
    email.clear();
    password.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
            ),
            topNoteImage,
            Container(
              child: Text(
                "Login",
                style: loginText,
              ),
            ),
            QuickTextField(
              text: "Email",
              controller: email,
              obscureText: false,
              fill: fill1,
              onChange: (value) {
                email = TextEditingController(text: value);
                fill1=email.text.length>0?true:false;
                setState(() {});
                },
            ),
            QuickTextField(
              text: "Password",
              obscureText: true,
              controller: password,
              fill: fill2,
              onChange: (value) {
                password = TextEditingController(text: value);
                fill2=password.text.length>0?true:false;
                setState(() {});
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Forget Your Password?",
                  style: forgetPasswordText,
                )
              ],
            ),
            QuickButton(
              buttonText: "Login",
              onTap: ()=>loginAccount(email.text, password.text),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don`t have an account? ",
                  style: notHaveAccountText
                ),
                InkWell(
                    onTap: ()=>     Navigator.push(context, PageTransition(child: SignUpScreen(), type: PageTransitionType.leftToRight,duration: Duration(seconds: 1))),
                    child: Text(
                      "Sign up",
                      style: signUp
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
