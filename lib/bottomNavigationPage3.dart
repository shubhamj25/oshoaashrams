import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'insidehotelBottom3.dart';
import 'organiserPageNotifications.dart';

class SavedPage extends StatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            color: Colors.red,
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: Icon(Icons.keyboard_backspace),
          ),
        ),
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
      body: new ListView(
        children: [
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Card(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HotelDetailsPageSaved()));
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/53.PNG',
                                ),
                                new Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: new Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Parmarth Niketan Ashram",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
