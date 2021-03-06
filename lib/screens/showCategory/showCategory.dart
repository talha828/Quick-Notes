import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/model/categoryModel.dart';
import 'package:quick_notes/screens/SpecificNotes/specificNotes.dart';
import 'package:sqflite/sqflite.dart';

class ShowCategoryScreen extends StatefulWidget {
  const ShowCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ShowCategoryScreen> createState() => _ShowCategoryScreenState();
}

class _ShowCategoryScreenState extends State<ShowCategoryScreen> {
  List<CategoryModel> category = [];
  getData() async {
    category.clear();
    FirebaseAuth _auth = FirebaseAuth.instance;
    Database db = await openDatabase('${_auth.currentUser!.uid}.db')
        .catchError((e) => print("error: $e"));
    // var dd=await db.query("select count(title) from notes,categories where notes.cat_id==categories.cat_id group by cat_id");
    //var dd=await db.query("notes",columns: ["count(title)",],groupBy: "notes.cat_id" );
    //print(dd);
    // await db.delete("categories",where: "cat_id != ?",whereArgs:[1] ).then((value) => print("success"));
    List<Map> data = await db.rawQuery("select * from categories");
    for (var i in data) {
      category.add(CategoryModel(catId: i["cat_id"], ctaName: i["cat_name"]));
    }
    setState(() {});
  }

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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Text("Category",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            category.length > 0
                ? Container(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SpecificNotes(
                                        categoryModel: category[index]))),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(vertical: 20),
                              alignment: Alignment.center,
                              child: Text(
                                category[index].ctaName,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal,
                                  color: themeColor1,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: category.length),
                  )
                : Expanded(
                    child: Center(child: Text("Category not Found")),
                  )
          ],
        ),
      ),
    );
  }
}
