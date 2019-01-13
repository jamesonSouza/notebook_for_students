import 'package:anotacoes_blocos/ui/home_page.dart';
import 'package:anotacoes_blocos/ui/notpad_card.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      hintColor: Colors.grey,
      primaryColor: Colors.white,
    ),
  ));
}