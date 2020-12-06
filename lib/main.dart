import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:vndiaoc/sidebar.dart';
import 'package:vndiaoc/splash.dart';

import 'package:get/get.dart';

import 'not.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      title: 'VNDIAOC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String imgurl;
  String color;

  MyHomePage({this.imgurl, this.color});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    PushNotificationService().initialise(context);
    getDataa();
    super.initState();
  }

  DocumentSnapshot snapshot; //Define snapshot
  String img;
  String color;
  bool lodaing = false;

  void getDataa() async {
    print("${widget.imgurl}");
    setState(() {
      lodaing = true;
    });
    await Firebase.initializeApp();
//use a Async-await function to get the data
    final data = await Firestore.instance
        .collection("Admin")
        .document('Admin')
        .get(); //get the data
    snapshot = data;
    setState(() {
      img = snapshot['img'];
      color = snapshot['Color'];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('img', img);
    prefs.setString('color', color);

    print("san${snapshot['Color']}");
    setState(() {
      lodaing = false;
    });
    // print('data$data');
  }

  @override
  Widget build(BuildContext context) {
    bool isValid = isURL(widget.imgurl);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        isValid == true
            ? Container(
                child: ExtendedImage.network(
                  lodaing == true
                      ? widget.imgurl !=null ? widget.imgurl
                      : "https://firebasestorage.googleapis.com/v0/b/vndiaoc-a462a.appspot.com/o/11606633674363.png?alt=media&token=18f3939e-afc7-4846-b1cd-44f44aaf819e" : img,
                  // width: ScreenUtil.instance.setWidth(400),
                  height: Get.height,
                  fit: BoxFit.fitHeight,
                  cache: true,
                  border: Border.all(color: Colors.red, width: 1.0),
                  //shape: boxShape,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  //cancelToken: cancellationToken,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("asset/house.jpg"),
                        fit: BoxFit.fitHeight)),
              ),
        Sidebar(
          color: lodaing == true ? int.parse("0xFFa83232") : int.parse(color),
        )
      ],
    ));
  }
}
