import 'package:alert_dialog/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/screens/loginScreen/loginScreen.dart';
import 'package:quick_notes/screens/mainScreen/mainScreen.dart';
import 'package:quick_notes/widgets/quickButton.dart';
import 'package:quick_notes/widgets/quickTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  var fill1 = false, fill2 = false, fill3 = false;
  bool isLoading = false;
  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void signUpAccount(String email, String password, String confirmPassword) {
    FocusScope.of(context).requestFocus(FocusNode());
    setLoading(true);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email.length > 0 && password.length > 0 && confirmPassword.length > 0) {
      if (password == confirmPassword) {
        if (password.length > 5 && password != null) {
          if (emailValid) {
            FirebaseAuth _auth = FirebaseAuth.instance;
            _auth
                .createUserWithEmailAndPassword(
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
            }).then(
              (value) async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString("email", email);
                pref.setString("password", password);

                setLoading(false);
                Navigator.push(
                    context,
                    PageTransition(
                        child: MainScreen(),
                        type: PageTransitionType.rightToLeftPop,
                        childCurrent: SignUpScreen(),
                        duration: Duration(seconds: 1)));
              },
            );
          } else {
            setLoading(false);
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Email is not Valid?'),
                content: new Text('Please input a valid email'),
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
          }
        } else {
          setLoading(false);
          showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Password is not valid'),
              content: new Text('Password must be al least 6 characters'),
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
        }
      } else {
        setLoading(false);
        showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Password doesn`t match'),
            content: new Text('Please retype your password'),
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
      }
    } else {
      setLoading(false);
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Field are empty'),
          content: new Text('Please fill all the given fields'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;
    var height = media.height;
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
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
              SizedBox(
                height: 20,
              ),
              QuickTextField(
                text: "Email",
                controller: email,
                fill: fill1,
                obscureText: false,
                onChange: (value) {
                  email = TextEditingController(text: value);
                  fill1 = email.text.length > 0 ? true : false;
                  setState(() {});
                },
              ),
              QuickTextField(
                text: "Password",
                controller: password,
                obscureText: true,
                fill: fill2,
                onChange: (value) {
                  password = TextEditingController(text: value);
                  fill2 = password.text.length > 0 ? true : false;
                  setState(() {});
                },
              ),
              QuickTextField(
                text: "Confirm Password",
                controller: confirmPassword,
                fill: fill3,
                obscureText: true,
                onChange: (value) {
                  confirmPassword = TextEditingController(text: value);
                  fill3 = confirmPassword.text.length > 0 ? true : false;
                  setState(() {});
                },
              ),
              QuickButton(
                buttonText: "Sign Up",
                onTap: () => signUpAccount(
                    email.text, password.text, confirmPassword.text),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: notHaveAccountText),
                  InkWell(
                      onTap: () => Navigator.push(
                          context,
                          PageTransition(
                              child: LoginScreen(),
                              type: PageTransitionType.rightToLeftPop,
                              childCurrent: SignUpScreen(),
                              duration: Duration(seconds: 1))),
                      child: Text("Login in", style: signUp)),
                ],
              )
            ],
          ),
        ),
        isLoading
            ? Container(
                alignment: Alignment.center,
                color: Colors.black45,
                width: width,
                height: height,
                child: CircularProgressIndicator(),
              )
            : Container()
      ],
    ));
  }
}
