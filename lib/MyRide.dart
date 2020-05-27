import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/addingNewRides.dart';

import 'insideHotelPage.dart';

class MyRide extends StatefulWidget {
  @override
  _MyRideState createState() => _MyRideState();
}

class _MyRideState extends State<MyRide> {
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
          "My Rides",
          style: GoogleFonts.balooBhaina(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 15),
              child: IconButton(
                icon: Icon(Icons.add), color: Colors.red, iconSize: 30,
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => DropDown()));
                }, //notification Page of the consumer
              ))
        ],
      ),
      body: new ListView(
        children: [
          Column(
            children: <Widget>[
              Card(
                elevation: 10.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HotelDetailsPage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/bandi.jpg'),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Smith Jane is travelling from",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Delhi to Rishikesh",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          FlatButton.icon(
                            color: Color.fromRGBO(253, 11, 23, 1),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Not Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Not Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                elevation: 10.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HotelDetailsPage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/bandi.jpg'),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Smith Jane is travelling from",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Delhi to Rishikesh",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          FlatButton.icon(
                            color: Color.fromRGBO(253, 11, 23, 1),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Not Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Not Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                elevation: 10.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HotelDetailsPage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/bandi.jpg'),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Smith Jane is travelling from",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Delhi to Rishikesh",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          FlatButton.icon(
                            color: Color.fromRGBO(253, 11, 23, 1),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Not Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Not Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                elevation: 10.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HotelDetailsPage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/bandi.jpg'),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Smith Jane is travelling from",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Delhi to Rishikesh",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          FlatButton.icon(
                            color: Color.fromRGBO(253, 11, 23, 1),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Not Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Not Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                elevation: 10.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HotelDetailsPage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/bandi.jpg'),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Smith Jane is travelling from",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Delhi to Rishikesh",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          FlatButton.icon(
                            color: Color.fromRGBO(253, 11, 23, 1),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Not Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Not Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                elevation: 10.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HotelDetailsPage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/bandi.jpg'),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Smith Jane is travelling from",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Delhi to Rishikesh",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          FlatButton.icon(
                            color: Color.fromRGBO(253, 11, 23, 1),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Not Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Not Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                elevation: 10.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HotelDetailsPage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/bandi.jpg'),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Smith Jane is travelling from",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Delhi to Rishikesh",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          FlatButton.icon(
                            color: Color.fromRGBO(253, 11, 23, 1),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Not Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Not Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                elevation: 10.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => HotelDetailsPage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/bandi.jpg'),
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Smith Jane is travelling from",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Delhi to Rishikesh",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          FlatButton.icon(
                            color: Color.fromRGBO(253, 11, 23, 1),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Not Interested",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Not Interested",
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    width: 3,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
