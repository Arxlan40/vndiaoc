import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'Conectivity.dart';
import 'main.dart';
import 'not.dart';

class HomePage extends StatefulWidget {
  String url;

  HomePage({this.url});

  @override
  _WebViewWebPageState createState() => _WebViewWebPageState();
}

class _WebViewWebPageState extends State<HomePage> {
  bool sidebar = false;

  //
  // _launchURL(url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  Future<bool> _onBack() async {
    bool goBack;
    var value = await webView.canGoBack();
    if (value) {
      webView.goBack();
      return false;
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _refresh() async {
    webView.reload();
  }

  // var URL = "https://www.lechoeurdusud.com/";
  double progress = 0;
  InAppWebViewController webView;

  @override
  void initState() {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    PushNotificationService().initialise(context);

    super.initState();
  }

  @override
  void dispose() {
    //_connectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String string;

    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "Offline";
        break;
      case ConnectivityResult.mobile:
        string = "Online";
        break;
      case ConnectivityResult.wifi:
        string = "Online";
    }
    return WillPopScope(
      onWillPop: _onBack,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.only(bottom: 85.0),
          //   child: FloatingActionButton(
          //       backgroundColor: Color(0xFFd52860),
          //       child: Icon(Icons.refresh),
          //       onPressed: () {
          //         _refresh();
          //       }),
          // ),
          // appBar: AppBar(
          //   backgroundColor: Color(0xFFd52860),
          //   leading: Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Image.asset(
          //       'asset/appbar.png',
          //     ),
          //   ),
          //   actions: [
          //     IconButton(
          //         icon: Icon(
          //           Icons.share,
          //           color: Colors.white,
          //         ),
          //         onPressed: null),
          //     IconButton(
          //         icon: Icon(
          //           Icons.home_outlined,
          //           color: Colors.white,
          //         ),
          //         onPressed: (){
          //           webView.loadUrl(url: URL);
          //
          //         })
          //   ],
          //   elevation: 0,
          //   // title: Text(
          //   //   "Valor",
          //   //   style: TextStyle(color: Colors.white, fontSize: 25),
          //   // ),
          // ),
          body: string == 'Offline'
              ? InkWell(
                  onTap: () {
                    webView.reload();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("asset/internet.png"),
                            fit: BoxFit.fitHeight)),
                  ),
                )
              : Container(
                  child: Column(
                      children: <Widget>[
                  (progress != 1.0)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.redAccent)),
                            // Container(
                            //        height: _height / 1.1365,
                            //        width: _width,
                            //        child:
                            //            Center(child: Image.asset('assets/splash.png')))
                          ],
                        )
                      : null, //
                  // Should be removed while showing
                  Expanded(
                    child: Container(
                      child: InAppWebView(
                        initialUrl: widget.url,
                        initialHeaders: {},
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                              mediaPlaybackRequiresUserGesture: false,
                              debuggingEnabled: true,
                              javaScriptEnabled: true,
                              useShouldOverrideUrlLoading: true),
                        ),
                        onWebViewCreated: (InAppWebViewController controller) {
                          webView = controller;
                        },
                        shouldOverrideUrlLoading: (controller, request) async {
                          var url = request.url;
                          var uri = Uri.parse(url);

                          if (![
                            "http",
                            "https",
                            "file",
                            "chrome",
                            "data",
                            "javascript",
                            "about"
                          ].contains(uri.scheme)) {
                            if (await canLaunch(url)) {
                              // Launch the App
                              await launch(
                                url,
                              );
                              // and cancel the request
                              return ShouldOverrideUrlLoadingAction.CANCEL;
                            }
                          }

                          return ShouldOverrideUrlLoadingAction.ALLOW;
                        },
                        onReceivedServerTrustAuthRequest:
                            (InAppWebViewController controller,
                                ServerTrustChallenge challenge) async {
                          return ServerTrustAuthResponse(
                              action: ServerTrustAuthResponseAction.PROCEED);
                        },
                        androidOnPermissionRequest:
                            (InAppWebViewController controller, String origin,
                                List<String> resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        onProgressChanged:
                            (InAppWebViewController controller, int progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                      ),
                    ),
                  )
                ].where((Object o) => o != null).toList())),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: InkWell(
                  child: Icon(
                    Icons.home,
                    color: Colors.red,
                  ),
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    var img = prefs.getString('img');
                    var color = prefs.getString('color');

                    Get.offAll(MyHomePage(imgurl: img,color: color,));
//Navigator.pop(context);
},
                ),
                backgroundColor: Colors.red,
                title: InkWell(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    var img = prefs.getString('img');
                    var color = prefs.getString('color');

                    Get.offAll(MyHomePage(imgurl: img,color: color,));
    },                  child: Text(
                    'Trang Chủ',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                  icon: InkWell(
                    child: Icon(
                      FontAwesomeIcons.moneyBillWave,
                      color: Colors.red,
                    ),
                    onTap: () {
                      webView.loadUrl(
                          url: "https://vndiaoc.com/bao-gia-dich-vu.html");
                    },
                  ),
                  title: InkWell(
                    onTap: () {
                      webView.loadUrl(
                          url: "https://vndiaoc.com/bao-gia-dich-vu.html");
                    },
                    child: Text(
                      'Giá dịch vụ',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  backgroundColor: Colors.red),
              BottomNavigationBarItem(
                icon: InkWell(
                  child: Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  onTap: () {
                    webView.loadUrl(
                        url:
                            "https://vndiaoc.com/member/login.html/?ref=aHR0cHM6Ly92bmRpYW9jLmNvbS9tZW1iZXIvcmVnaXN0ZXIuaHRtbC8_cmVmPWFIUjBjSE02THk5MmJtUnBZVzlqTG1OdmJTOXpZVzVuTFc1b2RXOXVaeTVvZEcxcw");
                  },
                ),
                title: InkWell(
                  onTap: () {
                    webView.loadUrl(
                        url:
                            "https://vndiaoc.com/member/login.html/?ref=aHR0cHM6Ly92bmRpYW9jLmNvbS9tZW1iZXIvcmVnaXN0ZXIuaHRtbC8_cmVmPWFIUjBjSE02THk5MmJtUnBZVzlqTG1OdmJTOXpZVzVuTFc1b2RXOXVaeTVvZEcxcw");
                  },
                  child: Text(
                    'Tài khoản',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ); //Remove null widgets
  }
}
