import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/model/categoryModel.dart';
import 'package:sqflite/sqflite.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController _controller = TextEditingController();

  saveCategory(String cat) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    Database db = await openDatabase('${_auth.currentUser!.uid}.db')
        .catchError((e) => print("error: $e"));
    db
        .execute(
            "create table categories (cat_id int AUTO_INCREMENT primary key,cat_name varchar(50))")
        .then((value) async {
      await db.rawInsert("insert into categories values(?,?)", [
        category.length < 1 ? 1 : category.last.catId + 1,
        cat
      ]).catchError((e) => print("error2: $e"));
    }).catchError((e) async {
      await db.rawInsert("insert into categories values(?,?)",
          [category.length < 1 ? 1 : category.last.catId + 1, cat]);
    }).whenComplete(() async {
      List<Map> data = await db
          .rawQuery("select * from categories")
          .catchError((e) => print("error3: $e"));
      for (var i in data) {
        print("name: ${i["cat_name"]}");
      }
      getData();
    });

    // List<Map> data= await db.rawQuery("select * from category").catchError((e)=>print("error3: $e"));
    // for(var i in data){
    //   print("name: ${i["cat_name"]}");
    // }
    _controller.clear();
  }

  getData() async {
    category.clear();
    FirebaseAuth _auth = FirebaseAuth.instance;
    Database db = await openDatabase('${_auth.currentUser!.uid}.db')
        .catchError((e) => print("error: $e"));
    // await db.delete("categories",where: "cat_id != ?",whereArgs:[1] ).then((value) => print("success"));
    List<Map> data = await db.rawQuery("select * from categories");
    // List<Map> data2 = await db.rawQuery("select count(cat_name) from categories");
    // print(data2[0]["count(cat_name)"]);
    for (var i in data) {
      category.add(CategoryModel(catId: i["cat_id"], ctaName: i["cat_name"]));
    }
    setState(() {});
  }

  List<CategoryModel> category = [];

  @override
  void initState() {
    getData();
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Text(
                  "Edit Category",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Poppins"),
                ),
              ),
              TextField(
                controller: _controller,
                onChanged: (value) {
                  _controller = TextEditingController(text: value);
                },
                decoration: InputDecoration(
                  hintText: "Add Category",
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: InkWell(
                    onTap: () => saveCategory(_controller.text),
                    child: Icon(
                      Icons.check,
                      color: themeColor1,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                  //focusedBorder: InputBorder.none,
                  // disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Text(
                  "All Category",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Poppins"),
                ),
              ),
              category.length < 1
                  ? Text("Your Record is Empty")
                  : Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: category
                            .map((e) => Dismissible(
                                  onDismissed: (value) async {
                                    FirebaseAuth _auth = FirebaseAuth.instance;
                                    Database db = await openDatabase(
                                            '${_auth.currentUser!.uid}.db')
                                        .catchError(
                                            (error) => print("error: $error"));
                                    await db.delete("categories",
                                        where: "cat_id = ?",
                                        whereArgs: [
                                          e.catId
                                        ]).then((value) => print("success"));
                                  },
                                  key: Key(e.ctaName),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: e.ctaName,
                                      hintStyle: TextStyle(color: Colors.black),
                                      suffixIcon: Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                      ),
                                      prefixIcon: Image.asset(
                                        "assets/notes.png",
                                        scale: 2,
                                      ),
                                      //focusedBorder: InputBorder.none,
                                      // disabledBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
