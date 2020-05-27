import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'organiserPageNotifications.dart';

class BottomNaviationProfile extends StatefulWidget {
  @override
  _BottomNaviationProfileState createState() => _BottomNaviationProfileState();
}

class _BottomNaviationProfileState extends State<BottomNaviationProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "SAVED",
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.w400, fontSize: 25.0),
        ),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 15),
              child: IconButton(
                icon: Icon(Icons.notifications_active), color: Colors.red,
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          OrganiserNotifications()));
                }, //notification Page of the consumer
              ))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              child: Row(
                children: [
                  SizedBox(
                    width: 20.0,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/bandi.jpg'),
                    radius: 50.0,
                  )
//                  Image.asset(
//                    'assets/images/bandi.jpg',
//                    height: 90.0,
//                  ),
                  ,
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Emma Philips",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ),
                  Text(
                    "Emma Philips",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Card(
              child: Row(
                children: [
                  Container(
                      height: 90.0,
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 100.0,
                      )),
                  Text("wallet"),
                  Icon(
                    Icons.directions_car,
                  ),
                  Text("My rides")
                ],
              ),
            ),
            Card(
              elevation: 10.0,
              child: ListTile(
                leading: Icon(
                  Icons.notifications_active,
                  color: Colors.red,
                ),
                title: Text(
                  "Support",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Card(
              elevation: 10.0,
              child: ListTile(
                leading: Icon(
                  Icons.notifications_active,
                  color: Colors.red,
                ),
                title: Text(
                  "Privacy Policy",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Card(
              elevation: 10.0,
              child: ListTile(
                leading: Icon(
                  Icons.notifications_active,
                  color: Colors.red,
                ),
                title: Text(
                  "Rate Us",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Card(
              elevation: 10.0,
              child: ListTile(
                leading: Icon(
                  Icons.notifications_active,
                  color: Colors.red,
                ),
                title: Text(
                  "Tell Your Friends",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Card(
              elevation: 10.0,
              child: ListTile(
                leading: Icon(
                  Icons.notifications_active,
                  color: Colors.red,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
