import 'dart:async';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_notes/screens/mainScreen/mainScreen.dart';
import 'package:quick_notes/screens/welcomeScreen/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  checkUserLogin()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var name=pref.getString("email");
    var passwords=pref.getString("password");
    print("password: $passwords email:$name");
    if(name!=null && passwords != null){
      FirebaseAuth _auth = FirebaseAuth.instance;
      _auth.signInWithEmailAndPassword(
          email: name, password: passwords)
          .catchError((e) {
        alert(
          context,
          title: Text('Something went wrong'),
          content: Text('Please check your internet connection'),
          textOK: Text('OK'),
        );
      })
          .then(
            (value) {
          Navigator.push(
              context,
              PageTransition(
                  child: MainScreen(),
                  type: PageTransitionType.leftToRight,
                  childCurrent: SplashScreen(),
                  duration: Duration(seconds: 1)));},
      );
    }
    else{
      Navigator.push(context, PageTransition(child: WelcomeScreen(), type: PageTransitionType.leftToRight,duration: Duration(seconds: 1)));
    }

  }
  @override
  void initState() {
    checkUserLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Image.asset("assets/splash_logo.png",scale: 2,),
      ) ,
    );
  }
}