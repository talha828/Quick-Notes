import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/screens/signUpScreen/signUpScreen.dart';
import 'package:quick_notes/widgets/quickButton.dart';
import 'package:quick_notes/widgets/quickTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool fill = false;

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
              fill: fill,
              onTap: () {
                setState(() {
                  fill = true;
                });
              },
              onChange: (value) {
                email = TextEditingController(text: value);
              },
            ),
            QuickTextField(
              text: "Password",
              controller: password,
              fill: fill,
              onTap: () {
                setState(() {
                  fill = true;
                });
              },
              onChange: (value) {
                password = TextEditingController(text: value);
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
              onTap: () {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don`t have an account? ",
                  style: notHaveAccountText
                ),
                InkWell(
                    onTap: () {      Navigator.push(context, PageTransition(child: SignUpScreen(), type: PageTransitionType.leftToRight,duration: Duration(seconds: 1)));
                    },
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
