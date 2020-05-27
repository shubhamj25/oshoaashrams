import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'aeoui.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    void onTappedBar(int index) {
      setState(() {
        _currentIndex = index;
        if (index == 0)
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => AeoUI()));
        if (index == 1)
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => AeoUI()));
        if (index == 2)
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => AeoUI()));
      });
    }

    var _controller;

    final List<Widget> _children = [AeoUI(), AeoUI(), AeoUI()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(253, 11, 23, 1),
        title: Text("Add Activities"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.add,
                size: 25.0,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Card(
            elevation: 10.0,
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        labelText: "Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        hintText: "Description"),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        labelText: "Place Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        hintText: "Description"),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        labelText: "Centre Name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        hintText: "Description"),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        labelText: "Aadhar No."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        hintText: "Description"),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        labelText: "PAN No."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        hintText: "Description"),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        labelText: "Image"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(253, 11, 23, 1),
                                width: 3.0)),
                        hintText: "Description"),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
//      bottomNavigationBar: BottomNavigationBar(
//        currentIndex: _currentIndex, onTap: onTappedBar,
//        items: [
//          BottomNavigationBarItem(
//              icon: Icon(
//                Icons.home,
//                color: Color.fromARGB(255, 196, 26, 61),
//              ),
//              title: Text("Home")),
//          BottomNavigationBarItem(
//              icon: Icon(
//                Icons.card_travel,
//                color: Color.fromARGB(255, 196, 26, 61),
//              ),
//              title: Text("Booking")),
//          BottomNavigationBarItem(
//              icon: Icon(
//                Icons.person,
//                color: Color.fromARGB(255, 196, 26, 61),
//              ),
//              title: Text("Profile")),
//        ],
//
////        child: Container(
////          padding: const EdgeInsets.only(top: 10.0),
////          height: 60,
////          child: Row(
////            mainAxisAlignment: MainAxisAlignment.spaceAround,
////            children: <Widget>[
////              Column(
////                children: <Widget>[
//
////                  Text('Home',
////                      style: TextStyle(
////                        color: Color.fromARGB(255, 196, 26, 61),
////                      )),
////                ],
////              ),
////              Column(
////                children: <Widget>[
////                  Icon(Icons.favorite_border),
////                  Text('Saved'),
////                ],
////              ),
////              Column(
////                children: <Widget>[
////                  Icon(Icons.card_travel),
////                  Text('Booking'),
////                ],
////              ),
////              Column(
////                children: <Widget>[
////                  Icon(Icons.group_add),
////                  Text('Invite & Earn'),
////                ],
////              )
////            ],
////          ),
////        ),
//      ),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.save_alt),
          backgroundColor: Color.fromRGBO(253, 11, 23, 1),
          onPressed: showToastForSubmission),
    );
  }
}

void showToastForSubmission() {
  Fluttertoast.showToast(
      msg: "SUCCESSFULLY UPLOADED",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}
