import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/MyRide.dart';
import 'package:rooms/hisroryAndWallet.dart';

import 'helpAndSupport.dart';

class UserProfileUI extends StatefulWidget {
  String email;
  UserProfileUI(this.email);
  @override
  _UserProfileUIState createState() => _UserProfileUIState();
}

class _UserProfileUIState extends State<UserProfileUI> {
  String msg = 'Hey Friends try this OSHO app';
  String base64Image = '';

  int  _selectedGender=0;
  String gender;
  List<DropdownMenuItem<int>> genderList = [
    DropdownMenuItem(
      child: new Text('Select Gender',style:TextStyle(
        color: Colors.blue,
        fontFamily: 'OpenSans',
      ),),
      value: 0,

    ),
    DropdownMenuItem(
        child: new Text('Male',style:TextStyle(
          color: Colors.blue,
          fontFamily: 'OpenSans',
        ),),
        value: 1
    ),
    DropdownMenuItem(
      child: new Text('Female',style: TextStyle(
        color: Colors.blue,
        fontFamily: 'OpenSans',
      ),),
      value: 2,
    ),
    DropdownMenuItem(
      child: new Text('Other',style: TextStyle(
        color: Colors.blue,
        fontFamily: 'OpenSans',
      ),),
      value: 3,
    ),

  ];
int retGender(AsyncSnapshot snapshot){
  if(snapshot.data['gender']=="Male"){
    return 1;
  }
  else if(snapshot.data['gender']=="Female"){
    return 2;
  }
  else if(snapshot.data['gender']=="Others"){
    return 3;
  }
  else{
    return 0;
  }
}
  bool phoneError=false;
  bool hidepass=true;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: StreamBuilder(
          stream: Firestore.instance.collection("users").document(widget.email).snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData?ListView(
              children: [
                Column(
                  children: [
                    Stack(
                      children: <Widget>[
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
                              child: snapshot.data['photoURL']!=null?CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(snapshot.data['photoURL'])):Icon(Icons.account_circle,size: 80.0,color: Colors.blueAccent,),
                            ),

                          ],
                        ),
                        IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    ListTile(
                      title: Center(
                          child: Text(
                            "${snapshot.data['name']}",
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
                              fontSize: 14.0,
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
                              fontSize: 14.0,
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
                      DataCell(
                          TextFormField(
                           initialValue: "${snapshot.data['name']}",
                           style: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                           decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                           ),
                            onChanged: (String val){
                             Firestore.instance.collection("users").document(widget.email).updateData({
                               "name": val,
                             });
                            },
                           ),
                      )
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                        "Phone",
                        style:
                        TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                      )),
                      DataCell(
                          TextFormField(

                            initialValue: "${snapshot.data['phone']!=null?snapshot.data['phone']:"Enter Phone Number"}",
                            style: TextStyle(fontWeight: FontWeight.w300, color: !phoneError?Colors.blue:Colors.red),
                            onChanged: (String value){
                              if(value.length==10){
                                setState(() {
                                  phoneError=false;
                                });
                                Firestore.instance.collection("users").document(widget.email).updateData({
                                  "phone":value.trim()
                                });
                              }
                              else{
                               setState(() {
                                 phoneError=true;
                               });
                              }
                            },
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                          )
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                        "Gender",
                        style:
                        TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                      )),
                      DataCell(
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: Icon(Icons.arrow_drop_down_circle,color:Colors.blue),
                              hint: new Text('Select Gender'),
                              items: genderList,
                              value: snapshot.data['gender']!=null?retGender(snapshot):_selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender=value;
                                  if(_selectedGender==1){
                                    gender="Male";
                                  }
                                  else if(_selectedGender==2){
                                    gender="Female";
                                  }
                                  else if(_selectedGender==3){
                                    gender="Others";
                                  }
                                });
                                Firestore.instance.collection("users").document(widget.email).updateData({
                                  "gender":gender,
                                });
                              },
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                              underline: null,
                            ),
                          )
                      )
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                        "Password",
                        style:
                        TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                      )),
                      DataCell(
                        TextFormField(
                          initialValue: "${snapshot.data['password']}",
                          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            suffixIcon: IconButton(icon:Icon(hidepass?Icons.lock:Icons.lock_open,color: Colors.blue,),onPressed: (){
                              setState(() {
                                if(hidepass){
                                  hidepass=false;
                                }
                                else{
                                  hidepass=true;
                                }
                              });
                            },)
                          ),
                          obscureText: hidepass,

                          onChanged: (String val){
                            Firestore.instance.collection("users").document(widget.email).updateData({
                              "password": val,
                            });
                          },
                        ),
                      )
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
                        "${snapshot.data['email']}",
                        style:
                        TextStyle(fontWeight: FontWeight.w300, color: Colors.blue,fontSize: 16),
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
                      DataCell(TextFormField(
                        initialValue: "${snapshot.data['gstno']!=null?snapshot.data['gstno']:"Enter GST Number"}",
                        style: TextStyle(fontWeight: FontWeight.w300, color: !phoneError?Colors.blue:Colors.red),
                        onChanged: (String value){
                            Firestore.instance.collection("users").document(widget.email).updateData({
                              "gstno":value.trim()
                            });
                        },
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),)
                    ],
                  ),
                ]),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
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
                      ListTile(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => HelpAndSUpport()));
                          },
                          leading: Icon(
                            Icons.help,
                            color: Color.fromRGBO(253, 11, 23, 1),
                          ),
                          title: Text(
                            "Support",
                            style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
                          )),
                      ListTile(
                          onTap: (){

                          },
                          leading: Icon(
                            Icons.security,
                            color: Color.fromRGBO(253, 11, 23, 1),
                          ),
                          title: Text(
                            "Privacy Policy",
                            style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
                          )),
                      ListTile(
                          onTap: (){},
                          leading: Icon(
                            Icons.stars,
                            color: Color.fromRGBO(253, 11, 23, 1),
                          ),
                          title: Text(
                            "Rate Us",
                            style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
                          )),
                      ListTile(
                          onTap: () {
                            FlutterShareMe()
                                .shareToWhatsApp(base64Image: base64Image, msg: msg);
                          },
                          leading: Icon(
                            Icons.group_add,
                            color: Color.fromRGBO(253, 11, 23, 1),
                          ),
                          title: Text(
                            "Tell your Friends",
                            style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
                          )),
                      ListTile(
                          leading: Icon(
                            Icons.touch_app,
                            color: Color.fromRGBO(253, 11, 23, 1),
                          ),
                          title: Text(
                            "Log Out",
                            style: GoogleFonts.balooBhaina(fontWeight: FontWeight.w400),
                          )),
                    ],
                  ),
                )
              ],
            ):Center(child: CircularProgressIndicator());
          }
        ),
      ),
    );
  }
}
