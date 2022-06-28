

import 'package:flutter/material.dart';

const welcomeMainText=TextStyle(fontSize: 26, fontWeight: FontWeight.bold,fontFamily: "Poppins");
const welcomeDescribeText=TextStyle(fontSize: 14, fontWeight: FontWeight.w300,fontFamily: "Poppins");
const quickButtonText = TextStyle(fontSize:18,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Poppins");
const loginText=TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: "Poppins");
const quickNotesText=TextStyle(color: Color(0xff407BFF), fontSize: 35, fontFamily: "Poppins", fontWeight: FontWeight.bold);
const forgetPasswordText=TextStyle(fontSize: 14, color: Color(0xff407BFF),fontFamily: 'Poppins');
const notHaveAccountText=TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins');
const signUp=TextStyle(color: Color(0xff407BFF), fontWeight: FontWeight.bold, fontFamily: 'Poppins');
final  topNoteImage=Container(child: Column(children: [Image.asset("assets/splash_logo.png", scale: 3,), Text("QuickNotes", style: quickNotesText),],),);


