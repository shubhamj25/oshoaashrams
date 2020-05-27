import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rooms/hisroryAndWallet.dart';

class BackupProfile extends StatefulWidget {
  @override
  _BackupProfileState createState() => _BackupProfileState();
}

class _BackupProfileState extends State<BackupProfile> {
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
//                  image: NetworkImage(
//                      'https://images.unsplash.com/photo-1508672019048-805c876b67e2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'),
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
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.red,
                    fontWeight: FontWeight.w400),
              )),
              subtitle: Center(child: Text("Osho Customer")),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => WalletApp()));
                  },
                  icon: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.red,
                  ),
                  label: Text(
                    "Wallet",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.0,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.red,
                          width: 3,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8)),
                ),
                SizedBox(
                  width: 10.0,
                ),
                FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => WalletApp()));
                  },
                  icon: Icon(
                    Icons.directions_car,
                    color: Colors.red,
                  ),
                  label: Text(
                    "My Ride",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.0,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.red,
                          width: 3,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
