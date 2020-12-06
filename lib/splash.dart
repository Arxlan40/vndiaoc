import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vndiaoc/home.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  /// -----------------------------------------
  /// Initstate and timer for splash screen
  /// -----------------------------------------

  void initState() {
    super.initState();
    getdata();
    startTimer();
  }
String img;
  String color;
  getdata() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
    img =  prefs.getString('img');
     color = prefs.getString('color');

    });
     }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage(imgurl: img,color: color,)));
    });
  }

  double _height;
  double _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
      height: _height,
      width: _width,
      color: Colors.white,
      child: Image.asset(
        'asset/splash.jpg',
      ),
    ));
  }
}
