import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/screens/loginScreen/loginScreen.dart';
import 'package:quick_notes/widgets/quickButton.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String buttonText = "Get Started";

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/welcome.png",
              scale: 1.8,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.3),
                child: Divider(
                  color: Color(0xffDCEAFF),
                  thickness: 5,
                )),
            Text(
              "Welcome To QuickNotes",
              style: welcomeMainText,
              textAlign: TextAlign.center,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "Take Notes,set reminders, collect yours",
                    style: welcomeDescribeText,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "ideas in Simple and organize way",
                    style: welcomeDescribeText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            QuickButton(
              buttonText: buttonText,
              onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: LoginScreen(),
                      type: PageTransitionType.bottomToTopPop,
                      childCurrent: WelcomeScreen(),
                      duration: Duration(seconds: 1))),
            ),
          ],
        ),
      ),
    );
  }
}
