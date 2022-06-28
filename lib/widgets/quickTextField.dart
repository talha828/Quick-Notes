
import 'package:flutter/material.dart';

class QuickTextField extends StatelessWidget {
  const QuickTextField(
      {required this.fill,
        this.onChange,
        this.onTap,
        this.text,
        this.controller});
  final onChange;
  final onTap;
  final bool fill;
  final text;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: fill ? Color(0xffDCEAFF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: TextField(
        onTap: onTap,
        onChanged: onChange,
        decoration: InputDecoration(
            fillColor: Color(0xffDCEAFF),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            hintText: text,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none),
      ),
    );
  }
}