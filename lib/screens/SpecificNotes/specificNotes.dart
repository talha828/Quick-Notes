import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/constant/constant.dart';
import 'package:quick_notes/model/categoryModel.dart';
import 'package:quick_notes/model/notesModel.dart';
import 'package:quick_notes/screens/mainScreen/mainScreen.dart';
import 'package:sqflite/sqflite.dart';

class SpecificNotes extends StatefulWidget {
  CategoryModel categoryModel;
  SpecificNotes({required this.categoryModel});

  @override
  State<SpecificNotes> createState() => _SpecificNotesState();
}

class _SpecificNotesState extends State<SpecificNotes> {
  List<NotesModel> note=[];
  Future<void>getData()async{
    note.clear();
    FirebaseAuth _auth= FirebaseAuth.instance;
    Database  db = await openDatabase('${_auth.currentUser!.uid}.db').catchError((e)=>print("error: $e"));
    //await db.execute("create table talha (name varchar(50),id int);").catchError((e)=>print("error1: $e"));
    // await db.rawInsert("insert into talha values(?, ?)",["hamza",2]).catchError((e)=>print("error2: $e"));
    List<Map> data= await db.rawQuery("select * from notes,categories where cat_name=?",[widget.categoryModel.ctaName]).catchError((e)=>print("error3: $e"));
    for(var i in data){
      note.add(NotesModel(cat_id: i["cat_id"].toString(),note_id: i["note_id"].toString(),title: i["title"].toString(),desc: i["decs"].toString(),cat_name: i["cat_name"].toString()));
      print(i);
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
      body:
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        Row(
        children: [
        Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Text(
          widget.categoryModel.ctaName,
          style: loginText,
        ),
      ),
      ],
    ),

        note.length>0?

        Container(
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
        ): Expanded(
    child: Center(child: Text("Category not Found")),
    )
          ],
        ),
      ),
    );
  }
}
