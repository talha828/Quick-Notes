import 'package:flutter/material.dart';
import 'package:quick_notes/constant/constant.dart';

class QuickButton extends StatelessWidget {
  const QuickButton({required this.buttonText,this.onTap}) ;

  final String buttonText;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap ,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Color(0xff407BFF),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(buttonText,style:quickButtonText),),
    );
  }
}