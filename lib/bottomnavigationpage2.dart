import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'insideHotelPage.dart';
import 'organiserPageNotifications.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
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
          "Bookings",
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
//      backgroundColor: Colors.black,
//      bottomNavigationBar: BottomNavigationBar(
//          currentIndex: _currentIndex,
//          items: [
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.home,
//                  color: Color.fromARGB(255, 196, 26, 61),
//                ),
//                title: Text("Home", style: TextStyle(color: Colors.red))),
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.history,
//                  color: Color.fromARGB(255, 196, 26, 61),
//                ),
//                title: Text("Add Events", style: TextStyle(color: Colors.red))),
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.favorite_border,
//                  color: Color.fromARGB(255, 196, 26, 61),
//                ),
//                title: Text("Saved", style: TextStyle(color: Colors.red))),
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.settings,
//                  color: Color.fromARGB(255, 196, 26, 61),
//                ),
//                title: Text("Profile", style: TextStyle(color: Colors.red))),
//          ],
//          onTap: (index) {
//            setState(() {
//              _currentIndex = index;
//            });
//            debugPrint("the current page is $_currentIndex");
//            if (index == 0)
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => AeoUI()));
//            if (index == 1)
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => BookingPage()));
//            if (index == 2)
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => SavedPage()));
//            if (index == 3)
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => BottomNaviationProfile()));
////    Navigator.of(context).push(MaterialPageRoute(
////    builder: (BuildContext context) => SavedPage()));
//          }),
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
      ),
    );
  }
}
