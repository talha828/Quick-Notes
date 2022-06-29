import 'package:flutter/material.dart';

class QuickSearch extends StatelessWidget {
  QuickSearch({required this.width,this.onChange,this.onTap});
  void Function(String)? onChange;
  void Function()? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.75,
      child: Container(
        decoration: BoxDecoration(
          color:  Color(0xffDCEAFF),
          borderRadius: BorderRadius.circular(10),),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          onTap: onTap,
          onChanged: onChange,
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.search,color: Color(0xff407BFF),),
              fillColor: Color(0xffDCEAFF),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              hintText: "Search",
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none),
        ),
      ),
    );
  }
}