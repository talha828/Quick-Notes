import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/widgets/quickSearch.dart';
import 'package:quick_notes/widgets/quickTextField.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: Color(0xff407BFF)),
                ),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text(
                  'Yes',
                  style: TextStyle(color: Color(0xff407BFF)),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
  setDataBase()async{
    Database  db = await openDatabase('aaa.db').catchError((e)=>print("error: $e"));
        //await db.execute("create table talha (name varchar(50),id int);").catchError((e)=>print("error1: $e"));
        await db.rawInsert("insert into talha values(?, ?)",["hamza",2]).catchError((e)=>print("error2: $e"));
    List<Map> data= await db.rawQuery("select * from talha where id=?",[1]).catchError((e)=>print("error3: $e"));
      for(var i in data){
        print("name: ${i["name"]}");
      }

  }
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HomeScreen(),
  ];

  @override
  void initState() {
    //setDataBase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Color(0xff535353),
            selectedItemColor: Color(0xff407BFF),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset("assets/home.png",
                    scale: 2,
                    color: _selectedIndex == 0
                        ? Color(0xff407BFF)
                        : Color(0xff535353)),
                title: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Home',
                    style: TextStyle(
                        color: _selectedIndex == 0
                            ? Color(0xff407BFF)
                            : Color(0xff535353),
                        fontSize: 10),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/category.png",
                  color: _selectedIndex == 1
                      ? Color(0xff407BFF)
                      : Color(0xff535353),
                  scale: 2,
                ),
                title: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 10,
                      color: _selectedIndex == 1
                          ? Color(0xff407BFF)
                          : Color(0xff535353),
                    ),
                  ),
                ),
              ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            //selectedItemColor: Colors.black,
            iconSize: 40,
            onTap: _onItemTapped,
            elevation: 5),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.add,
              size: 30,
            ),
            backgroundColor: Color(0xff407BFF)),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController search = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var width = media.width;
    var height = media.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50,),
                child: Image.asset("assets/drawer_logo.png",scale: 1.5,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(Icons.add,color: Color(0xff407BFF),),
                  SizedBox(width: 15,),
                  Text("Create Notes",style: TextStyle(fontFamily: "Poppins",),)
                ],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Image.asset("assets/notes.png",scale: 2.5,),
                  SizedBox(width: 25,),
                  Text("All Notes",style: TextStyle(fontFamily: "Poppins",),)
                ],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Divider(color:Color(0xff407BFF) ,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Image.asset("assets/notes.png",scale: 2.5,),
                  SizedBox(width: 25,),
                  Text("Design",style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                ],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(Icons.add,color: Color(0xff407BFF),),
                  SizedBox(width: 15,),
                  Text("Create Category",style: TextStyle(fontFamily: "Poppins",),)
                ],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Divider(color:Color(0xff407BFF) ,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(Icons.login,color: Color(0xff407BFF),),
                  SizedBox(width: 15,),
                  Text("Signout",style: TextStyle(fontFamily: "Poppins",),)
                ],),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () => _scaffoldKey.currentState!.openDrawer(),
                    child: Image.asset(
                      "assets/drawer.png",
                      scale: 2,
                    )),
                SizedBox(
                  width: 13,
                ),
                QuickSearch(
                  width: width,
                  onChange: (value) {},
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Text(
                "Hello Quickie",
                style: loginText,
              ),
            ),
            Text(
              "Let get Started with notes",
              style: welcomeDescribeText,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "You have not create any ",
                      style: welcomeDescribeText,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Note yet",
                      style: welcomeDescribeText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
