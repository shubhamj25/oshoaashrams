import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrganiserNotifications extends StatefulWidget {
  @override
  _OrganiserNotificationsState createState() => _OrganiserNotificationsState();
}

class _OrganiserNotificationsState extends State<OrganiserNotifications> {
  String locationText;
  String flagImage;
  List locationText1 = [
    'weidai@mac.com',
    'demmel@aol.com',
    'attwood@gmail.com',
    'mthurn@sbcglobal.net',
    'uqmcolyv@comcast.net',
    'jgwang@verizon.net',
    'reziac@yahoo.ca',
    'benanov@yahoo.com',
    'mfburgo@hotmail.com',
    'henkp@att.net',
    'natepuri@comcast.net',
    'solomon@me.com'
  ];
  List flagImage1 = [
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
    'OshoLogo.png',
  ];
  List subtitileList = [
    'payment received ',
    'payment received ',
    'payment in process ',
    'payment received ',
    'payment failed ',
    'payment received ',
    'payment received ',
    'payment received ',
    'payment received ',
    'payment received ',
    'payment received ',
    'payment received ',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Notifications"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: locationText1.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10.0,
              child: ListTile(
                onTap: () {},
                title: Text(locationText1[index]),
                subtitle: Text(subtitileList[index]),
                leading: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/${flagImage1[index]}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
