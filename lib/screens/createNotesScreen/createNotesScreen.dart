import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/model/categoryModel.dart';
import 'package:quick_notes/model/notesModel.dart';
import 'package:quick_notes/screens/mainScreen/mainScreen.dart';
import 'package:sqflite/sqflite.dart';

class CreateNotesScreen extends StatefulWidget {
  const CreateNotesScreen({Key? key}) : super(key: key);

  @override
  State<CreateNotesScreen> createState() => _CreateNotesScreenState();
}

class _CreateNotesScreenState extends State<CreateNotesScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController decs = TextEditingController();
  List<CategoryModel> category = [
    CategoryModel(catId: 4000, ctaName: "Select Category"),
  ];
  getData() async {
    category.clear();
    FirebaseAuth _auth = FirebaseAuth.instance;
    Database db = await openDatabase('${_auth.currentUser!.uid}.db')
        .catchError((e) => print("error: $e"));
    // await db.delete("categories",where: "cat_id != ?",whereArgs:[1] ).then((value) => print("success"));
    List<Map> data = await db.rawQuery("select * from categories");
    for (var i in data) {
      category.add(CategoryModel(catId: i["cat_id"], ctaName: i["cat_name"]));
    }
    setState(() {});
  }

  late Database db;
  open() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    db = await openDatabase('${_auth.currentUser!.uid}.db')
        .catchError((e) => print("error: $e"));
    List<Map> data = await db.rawQuery("select * from categories");
    for (var i in data) {
      category.add(CategoryModel(catId: i["cat_id"], ctaName: i["cat_name"]));
    }
    setState(() {});
    await db
        .execute(
            "create table notes (note_id int AUTO_INCREMENT primary key,title varchar(50),decs varchar(50),cat_id int, FOREIGN KEY (cat_id) REFERENCES categories(cat_id));")
        .catchError((e) => print("error1: $e"))
        .then((value) => print("sccess"));
    titleText = "";
    decsText = "";
  }

  List<NotesModel> note = [];
  Future<void> setDataBase() async {
    note.clear();
    FirebaseAuth _auth = FirebaseAuth.instance;
    Database db = await openDatabase('${_auth.currentUser!.uid}.db')
        .catchError((e) => print("error: $e"));
    //await db.execute("create table talha (name varchar(50),id int);").catchError((e)=>print("error1: $e"));
    // await db.rawInsert("insert into talha values(?, ?)",["hamza",2]).catchError((e)=>print("error2: $e"));
    List<Map> data = await db
        .rawQuery(
            "select * from notes,categories where notes.cat_id==categories.cat_id")
        .catchError((e) => print("error3: $e"));
    for (var i in data) {
      note.add(NotesModel(
          cat_id: i["cat_id"].toString(),
          note_id: i["note_id"].toString(),
          title: i["title"].toString(),
          desc: i["decs"].toString(),
          cat_name: i["cat_name"].toString()));
      print(i);
    }
    setState(() {});
  }

  getSave(CategoryModel value, String titleText, String descText) async {
    setDataBase().then((s) async {
      if (value.catId != 4000) {
        if (titleText.length > 0) {
          if (decsText.length > 0) {
            // int ran=Random(0).nextInt(1000000);
            await db
                .rawInsert("insert into notes values(?,?,?,?)", [
                  note.length < 1
                      ? 1
                      : double.parse(note.last.note_id).toInt() + 1,
                  titleText,
                  descText,
                  value.catId
                ])
                .catchError((e) => print("error2: $e"))
                .then((value) => print("done"));
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          } else {
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Description is Empty'),
                content: new Text('Please Add a Description First'),
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
          showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Title is Empty'),
              content: new Text('Please Add a title First'),
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
        showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Category is Empty'),
            content: new Text('Please select category first'),
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
    });
  }

  late CategoryModel value;
  late String titleText;
  late String decsText;
  @override
  void initState() {
    //getData();
    open();
    value = category.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                category.length < 2
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: Colors.grey)),
                        child: Row(
                          children: [
                            Text(
                              "Select Category",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey)
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: Colors.grey)),
                        width: 150,
                        height: 40,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CategoryModel>(
                              disabledHint: Text("Select Category"),
                              isExpanded: true,
                              onChanged: (item) {
                                setState(() {
                                  value = item!;
                                });
                              },
                              value: value,
                              items: category
                                  .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: FittedBox(child: Text(e.ctaName))))
                                  .toList()),
                        ),
                      ),
                InkWell(
                  onTap: () => getSave(value, titleText, decsText),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: themeColor1,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: title,
              decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
              onChanged: (value) {
                titleText = value.trim();
                setState(() {});
              },
            ),
            TextField(
              controller: decs,
              keyboardType: TextInputType.multiline,
              minLines: null,
              maxLines: null,
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  hintText: "Type your note here...",
                  hintStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    color: Colors.grey,
                  )),
              onChanged: (value) {
                decsText = value.trim();
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}
