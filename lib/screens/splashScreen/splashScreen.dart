import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_notes/screens/welcomeScreen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), (){
      Navigator.push(context, PageTransition(child: WelcomeScreen(), type: PageTransitionType.leftToRight,duration: Duration(seconds: 1)));
    });
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