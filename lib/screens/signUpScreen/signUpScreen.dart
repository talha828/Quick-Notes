import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/widgets/quickButton.dart';
import 'package:quick_notes/widgets/quickTextField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email =TextEditingController();
  TextEditingController password =TextEditingController();
  TextEditingController confirmPassword =TextEditingController();
  bool fill=false;
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
            Container(
              child: Text(
                "Create Your Account",
                style: loginText,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fill the details below to create",
                    style: welcomeDescribeText,
                  ),
                  Text(
                    "your account",
                    style: welcomeDescribeText,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            QuickTextField(
              text: "Email",
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
            QuickTextField(
              text: "Confirm Password",
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
            QuickButton(
              buttonText: "Sign Up",
              onTap: () {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Already have an account? ",
                    style: notHaveAccountText
                ),
                InkWell(
                    onTap: () {},
                    child: Text(
                        "Login in",
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
