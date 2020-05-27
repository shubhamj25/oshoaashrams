import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'insideHotelPage.dart';
import 'organiserPageNotifications.dart';

class OnGoingEvents extends StatefulWidget {
  @override
  _OnGoingEventsState createState() => _OnGoingEventsState();
}

class _OnGoingEventsState extends State<OnGoingEvents> {
  @override
  Widget build(BuildContext context) {
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
            "On Going Events",
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 25.0),
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
        body: ListView(
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                                  HotelDetailsPage()));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/53.PNG'),
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
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),

//          Column(
//            children: <Widget>[
//              Stack(
//                children: [Image.asset('images/12.jpg')],
//              ),
//            ],
//          ),
//          Column(
//            children: <Widget>[
//              Stack(
//                children: [Image.asset('images/12.jpg')],
//              ),
//            ],
//          ),
//          Column(
//            children: <Widget>[
//              Stack(
//                children: [Image.asset('images/12.jpg')],
//              ),
//            ],
//          ),
          ],
        ));
  }
}
