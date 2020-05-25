import 'package:flutter/material.dart';

Text primaryText(String title,{double fontSize,FontWeight fontWeight,int maxLines,TextAlign textAlign}){
  return Text(
    title,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: Color(0xFF2F4670),
      fontSize: fontSize,
      fontWeight: fontWeight
    ),
  );
}
Text accentText(String title,{double fontSize,FontWeight fontWeight,int maxLines,TextAlign textAlign}){
  return Text(
    title,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: Color(0xFFFDD186),
      fontSize: fontSize,
      fontWeight: fontWeight
    ),
  );
}