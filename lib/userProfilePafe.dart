import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/MyRide.dart';
import 'package:rooms/hisroryAndWallet.dart';

import 'helpAndSupport.dart';

class UserProfileUI extends StatelessWidget {
  String msg = 'Hey Friends try this OSHO app';
  String base64Image = '';
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Stack(
              overflow: Overflow.visible,
              alignment: Alignment.center,
              children: [
                Image(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/qwe.jpg'),
                ),
                Positioned(
                  bottom: -60.0,
                  child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/bandi.jpg')),
                )
              ],
            ),
            SizedBox(
              height: 60.0,
            ),
            ListTile(
              title: Center(
                  child: Text(
                "Smith Jane",
                style: GoogleFonts.balooBhaina(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
              subtitle: Center(child: Text("Osho Customer")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
//                SizedBox(
//                  width: 10.0,
//                ),
                FlatButton.icon(
                  color: Color.fromRGBO(253, 11, 23, 1),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => WalletApp()));
                  },
                  icon: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Wallet",
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
//                SizedBox(
//                  width: 10.0,
//                ),
                FlatButton.icon(
                  color: Color.fromRGBO(253, 11, 23, 1),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => MyRide()));
                  },
                  icon: Icon(
                    Icons.directions_car,
                    color: Colors.white,
                  ),
                  label: Text(
                    "My Rides",
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
            ),
          ],
        ),
        DataTable(columns: <DataColumn>[
          DataColumn(
              label: Text(
            "Information",
            style: TextStyle(color: Colors.black),
          )),
          DataColumn(
              label: Text("Details", style: TextStyle(color: Colors.black)))
        ], rows: <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text(
                "Name",
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
              )),
              DataCell(Text(
                "Smith jane",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
              ))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text(
                "Phone Number",
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
              )),
              DataCell(Text(
                "987654321",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
              ))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text(
                "Gender",
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
              )),
              DataCell(Text(
                "Female",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
              ))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text(
                "Email",
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
              )),
              DataCell(Text(
                "amithjane@gmail.com",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
              ))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text(
                "Gst No.",
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
              )),
              DataCell(Text(
                "12345",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
              ))
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text(
                "Password",
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
              )),
              DataCell(Text(
                "ABC1234",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
              ))
            ],
          ),
        ]),
        SizedBox(height: 15.0),
        Card(
          elevation: 10.0,
          child: ListTile(
            leading: Icon(
              Icons.notifications_active,
              color: Color.fromRGBO(253, 11, 23, 1),
            ),
            title: Text(
              "Notifications",
              style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              "ON",
              style: GoogleFonts.balooBhaina(
                  color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext) => HelpAndSUpport()));
          },
          child: Card(
            elevation: 10.0,
            child: ListTile(
                leading: Icon(
                  Icons.help,
                  color: Color.fromRGBO(253, 11, 23, 1),
                ),
                title: Text(
                  "Support",
                  style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
                )),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Card(
            elevation: 10.0,
            child: ListTile(
                leading: Icon(
                  Icons.security,
                  color: Color.fromRGBO(253, 11, 23, 1),
                ),
                title: Text(
                  "Privacy Policy",
                  style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
                )),
          ),
        ),
        Card(
          elevation: 10.0,
          child: ListTile(
              leading: Icon(
                Icons.stars,
                color: Color.fromRGBO(253, 11, 23, 1),
              ),
              title: Text(
                "Rate Us",
                style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
              )),
        ),
        InkWell(
          onTap: () {
            FlutterShareMe()
                .shareToWhatsApp(base64Image: base64Image, msg: msg);
          },
          child: Card(
            elevation: 10.0,
            child: ListTile(
                leading: Icon(
                  Icons.group_add,
                  color: Color.fromRGBO(253, 11, 23, 1),
                ),
                title: Text(
                  "Tell your Friends",
                  style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
                )),
          ),
        ),
        Card(
          elevation: 10.0,
          child: ListTile(
              leading: Icon(
                Icons.touch_app,
                color: Color.fromRGBO(253, 11, 23, 1),
              ),
              title: Text(
                "Log Out",
                style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
              )),
        ),
      ],
    );
  }
}
