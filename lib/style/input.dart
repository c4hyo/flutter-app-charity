import 'package:flutter/material.dart';

UnderlineInputBorder primaryInputsBorder(){
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFFDD186),
      style: BorderStyle.solid,
      width: 5
    )
  );
}
UnderlineInputBorder accentInputsBorder(){
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF2F4670),
      style: BorderStyle.solid,
      width: 5
    )
  );
}