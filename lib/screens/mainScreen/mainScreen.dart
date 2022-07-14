import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/model/notesModel.dart';
import 'package:quick_notes/screens/categoryScreen/categoryScreen.dart';
import 'package:quick_notes/screens/createNotesScreen/createNotesScreen.dart';
import 'package:quick_notes/screens/showCategory/showCategory.dart';
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
  List<NotesModel> note=[];
  setDataBase()async{
    FirebaseAuth _auth= FirebaseAuth.instance;
    Database  db = await openDatabase('${_auth.currentUser!.uid}.db').catchError((e)=>print("error: $e"));
        //await db.execute("create table talha (name varchar(50),id int);").catchError((e)=>print("error1: $e"));
       // await db.rawInsert("insert into talha values(?, ?)",["hamza",2]).catchError((e)=>print("error2: $e"));
    List<Map> data= await db.rawQuery("select * from notes,categories").catchError((e)=>print("error3: $e"));
     for(var i in data){
       note.add(NotesModel(cat_id: i["cat_id"],note_id: i["note_id"],title: i["title"],desc: i["decs"],cat_name: i["cat_name"]));
       print(i);
     }

  }
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ShowCategoryScreen(),
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
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNotesScreen())),
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
  List<NotesModel> note=[];
  Future<void>setDataBase()async{
    note.clear();
    FirebaseAuth _auth= FirebaseAuth.instance;
    Database  db = await openDatabase('${_auth.currentUser!.uid}.db').catchError((e)=>print("error: $e"));
    //await db.execute("create table talha (name varchar(50),id int);").catchError((e)=>print("error1: $e"));
    // await db.rawInsert("insert into talha values(?, ?)",["hamza",2]).catchError((e)=>print("error2: $e"));
    List<Map> data= await db.rawQuery("select * from notes,categories where notes.cat_id==categories.cat_id").catchError((e)=>print("error3: $e"));
    for(var i in data){
      note.add(NotesModel(cat_id: i["cat_id"].toString(),note_id: i["note_id"].toString(),title: i["title"].toString(),desc: i["decs"].toString(),cat_name: i["cat_name"].toString()));
      print(i);
    }
    setState(() {});
  }
  TextEditingController search = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void>onSearch()async{
    note.clear();
    FirebaseAuth _auth= FirebaseAuth.instance;
    Database  db = await openDatabase('${_auth.currentUser!.uid}.db').catchError((e)=>print("error: $e"));
    //await db.execute("create table talha (name varchar(50),id int);").catchError((e)=>print("error1: $e"));
    // await db.rawInsert("insert into talha values(?, ?)",["hamza",2]).catchError((e)=>print("error2: $e"));
    List<Map> data= await db.rawQuery("select * from notes,categories where title=?",[search.text]).catchError((e)=>print("error3: $e"));
    for(var i in data){
      note.add(NotesModel(cat_id: i["cat_id"].toString(),note_id: i["note_id"].toString(),title: i["title"].toString(),desc: i["decs"].toString(),cat_name: i["cat_name"].toString()));
      print(i);
    }
    setState(() {});
  }
  @override
  void initState() {
    setDataBase();
    super.initState();
  }
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
              InkWell(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNotesScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Image.asset("assets/notes.png",scale: 2.5,),
                    SizedBox(width: 25,),
                    Text("All Notes",style: TextStyle(fontFamily: "Poppins",),)
                  ],),
                ),
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
              InkWell(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder:(context)=>CategoryScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(Icons.add,color: Color(0xff407BFF),),
                    SizedBox(width: 15,),
                    Text("Create Category",style: TextStyle(fontFamily: "Poppins",),)
                  ],),
                ),
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
                  onChange: (value) {
                    search=TextEditingController(text: value);
                    setState(() {

                    });
                  },
                  onTap: () =>onSearch(),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            note.length>0?Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Text(
                    "All Notes",
                    style: loginText,
                  ),
                ),
                IconButton(onPressed: ()=>setDataBase(), icon:Icon(Icons.refresh, color: themeColor1,))
              ],
            ):Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Text(
                "Hello Quickie",
                style: loginText,
              ),
            ),
            note.length>0?Container():Text(
              "Let get Started with notes",
              style: welcomeDescribeText,
            ),
            note.length>0?Container(
             // height: 500,
              child: ListView.separated(
                separatorBuilder: (context,index){
                  return SizedBox(height: 10,);
                },
                physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: note.length,
                  itemBuilder: (context,index){
                return Notes(note: note[index]);
              }),
            ):Expanded(
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

class Notes extends StatelessWidget {
  const Notes({
    Key? key,
    required this.note,
  }) : super(key: key);

  final NotesModel note;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dismissible(
        key: Key(note.title),
        onDismissed: (value)async{
          FirebaseAuth _auth = FirebaseAuth.instance;
          Database db = await openDatabase('${_auth.currentUser!.uid}.db')
              .catchError((error) => print("error: $error"));
          await db.delete("notes",where: "title = ?",whereArgs:[note.title] ).then((value) => print("success"));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          decoration: BoxDecoration(
            color: Color(0xffDCEAFF),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white)
          ),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 150,
                    child: FittedBox(child: Text(note.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,fontFamily: "Poppins"),))),
                Container(
                    decoration: BoxDecoration(
                      color: themeColor1,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 7,horizontal: 20),
                    child: Text(note.cat_name,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: "Poppins"),)),
              ],
            ),
            SizedBox(height: 10,),
            Text(note.desc,style: TextStyle(color: Colors.black54),),
          ],) ,
        ),
      ),
    );
  }
}
