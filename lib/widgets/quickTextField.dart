import 'package:flutter/material.dart';

class QuickTextField extends StatelessWidget {
  const QuickTextField(
      {required this.fill,
      this.onChange,
      this.text,
      this.controller,
      this.obscureText});
  final onChange;
  final bool fill;
  final text;
  final controller;
  final obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: fill ? Color(0xffDCEAFF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: TextField(
        obscureText: obscureText,
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
