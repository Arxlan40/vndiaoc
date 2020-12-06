import 'package:flutter/material.dart';

import 'home.dart';
import 'model/navigation_model.dart';
import 'package:get/get.dart';

class Sidebar extends StatelessWidget {
  int color;
  Sidebar({this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(.7),
      width: 100,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: navigationItems.length,
          physics: ScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
              onTap: () {
                Get.to(HomePage(url: navigationItems[index].url));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  navigationItems[index].icon != null
                      ? Container(
                          width: 85,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Color(color),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          child: Icon(navigationItems[index].icon,
                              size:35, color: Colors.white),
                        )
                      : Container(
                          width: 85,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Color(color),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(navigationItems[index].asseturl, color: Colors.white,width:40,height: 20,fit: BoxFit.fitHeight,scale: .1,),
                          ),
                        ),
                  SizedBox(
                    height: 3,
                  ),
                  Center(
                      child: Text(
                    navigationItems[index].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  )),
                ],
              ),
            );
          }),
    );
  }
}
