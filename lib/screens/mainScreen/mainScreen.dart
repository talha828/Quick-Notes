import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/widgets/quickSearch.dart';
import 'package:quick_notes/widgets/quickTextField.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex=0;
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

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HomeScreen(),
  ];
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor:Color(0xff535353) ,
          selectedItemColor:Color(0xff407BFF) ,
          items: [
            BottomNavigationBarItem(icon: Image.asset("assets/home.png",scale: 2,color:_selectedIndex==0?Color(0xff407BFF):Color(0xff535353)), title: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Home',style: TextStyle(color:_selectedIndex==0?Color(0xff407BFF):Color(0xff535353),fontSize: 10),),
            ), ),
            BottomNavigationBarItem(icon:Image.asset("assets/category.png", color:_selectedIndex==1?Color(0xff407BFF):Color(0xff535353),scale: 2,), title: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Category',style: TextStyle(fontSize:10,color: _selectedIndex==1?Color(0xff407BFF):Color(0xff535353),),),
            ), ),
          ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            //selectedItemColor: Colors.black,
            iconSize: 40,
            onTap: _onItemTapped,
            elevation: 5
        ),
        body:Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add,size: 30,),backgroundColor: Color(0xff407BFF)),
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
    child: ListView(
    padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
      ],
    ),
    ),
      body:Container(
        padding: EdgeInsets.only(top: 50,left: 20,right: 20),
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
                SizedBox(width: 13,),
                QuickSearch(width: width,onChange: (value){},onTap: (){},),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
              child: Text(
                "Hello Talha",
                style: loginText,
              ),
            ),
            Text(
              "Let get Started with notes",
              style: welcomeDescribeText,
            ),
            Expanded(
              child: Container(
                child:  Column(
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



