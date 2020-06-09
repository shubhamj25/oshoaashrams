import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'aeoui.dart';

String planChoose;
String plan;

class SubscritionHomePage extends StatefulWidget {
  final String userEmail;
  SubscritionHomePage({this.userEmail});
  @override
  _SubscritionHomePageState createState() => _SubscritionHomePageState();
}

class _SubscritionHomePageState extends State<SubscritionHomePage> {
  Razorpay _razorPay;
  bool processing=false;
  bool payingGold=false; bool payingSilver=false;
  bool payingDiamond=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection("users").document(loggedInEmail).get().then((doc){
      if(doc.exists){
        if(doc.data['subscription']=='Gold'||doc.data['subscription']=='Diamond'||doc.data['subscription']=='Silver'){
          setState(() {
            plan=doc.data['subscription'];
          });
        }
        else{
          setState(() {
            plan="Inactive";
          });
        }
      }
    });
    _razorPay=Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,_handlePaymentError);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorPay.clear();
  }

  void openCheckout(String subscription,int amount) async {
    var options;
    Firestore.instance.collection("users").document(widget.userEmail).get().then((doc){
      setState(() {
        options = {
          'key': 'rzp_test_PyfpsGv8KwvPDJ',
          'amount': amount*100,
          'name': 'Osho Aaashrams',
          'description': '$subscription Subscription Payment by\n${widget.userEmail}',
          'prefill': {'contact': doc.data['phone'], 'email': widget.userEmail},
          'external': {
            'wallets': ['paytm']
          }
        };
        try {
          _razorPay.open(options);
        } catch (e) {
          debugPrint(e);
        }
      });
    });

  }
  bool walletPay=false;
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Flushbar(
      shouldIconPulse: true,
      isDismissible: true,
      flushbarPosition: FlushbarPosition.TOP,
      titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
      messageText: Text("Subscription Confirmed with id ${response.paymentId}",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
      duration: Duration(seconds: 3),
      icon: Icon(Icons.check,color: Colors.white,),
      backgroundColor:  Colors.green,
    )..show(context).then((value){
      Firestore.instance.collection("users").document(loggedInEmail).updateData(
          {
            "subscription":planChoose,
          }
      ).then((value){
        Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context){
                return SubscritionHomePage(userEmail: widget.userEmail,);
              }
          ));
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    SafeArea(
      child: Flushbar(
        shouldIconPulse: true,
        isDismissible: true,
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text("Payment Failed",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
        messageText: Text("${response.message}",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.close,color: Colors.white,),
        backgroundColor:  Colors.red,
      )..show(context).then((value){
        setState(() {
          payingGold=false;  payingSilver=false;
           payingDiamond=false;
        });
      }));
  }

  Widget silverPlan(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Color(0xff5a348b),
          gradient: LinearGradient(
              colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
              begin: Alignment.centerRight,
              end: Alignment(-1.0, -1.0)), //Gradient
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Text
                  Container(
                    child: Text(
                      'Standard Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //subText
                  Container(
                    child: Text(
                      'This is Silver plan',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  //Circle Avatar
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                        width: 140.0,
                        height: 120.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                '₹ 399',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color(0xff8d70fe),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '/yr',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xff8d70fe),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),

                  //Two Column Table
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(cells: <DataCell>[
                        DataCell(
                          myRowDataIcon(
                              FontAwesomeIcons.database, "Parking"),
                        ),
                        DataCell(
                          Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          myRowDataIcon(FontAwesomeIcons.users, "TV"),
                        ),
                        DataCell(
                          Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          myRowDataIcon(
                              FontAwesomeIcons.folderOpen, "Addons "),
                        ),
                        DataCell(
                          Text(
                            'No',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          myRowDataIcon(
                              FontAwesomeIcons.phone, "24/7 Support"),
                        ),
                        DataCell(
                          Text(
                            'No',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          myRowDataIcon(
                              FontAwesomeIcons.envelope, "Helpers"),
                        ),
                        DataCell(
                          Text(
                            'No',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),

                  //Button
                  Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: RaisedButton(
                        color: new Color(0xffffffff),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Choose Plan',
                              style: GoogleFonts.balooBhai(
                                fontSize: 19,
                                color: new Color(0xff6200ee),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            planChoose="Silver";
                            payingSilver=true;
                          });
                          showDialog(context: context,
                              builder: (context){
                                return StatefulBuilder(
                                    builder: (context,setState){
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(vertical:120.0,horizontal: 0.0),
                                          child: AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                              ),
                                              contentPadding: const EdgeInsets.all(0),
                                              content:Card(
                                                  shape:RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                                  ),
                                                  child: Stack(
                                                      alignment: Alignment.bottomCenter,
                                                      children: <Widget>[
                                                        Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: <Widget>[
                                                                            Text("Confirm Payment",style: GoogleFonts.raleway(fontSize: 20.0,fontWeight: FontWeight.w600),),
                                                                            IconButton(
                                                                              icon: Icon(Icons.close),
                                                                              onPressed: (){
                                                                                setState(() {
                                                                                  processing=false;
                                                                                });
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ]
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(16.0),
                                                                    child: Text("Do you confirm Your payment of ₹ 399 to Osho Silver Subscription",
                                                                      style: GoogleFonts.raleway(fontSize: 18.0),
                                                                    ),
                                                                  ),


                                                                  Padding(
                                                                    padding: const EdgeInsets.all(16.0),
                                                                    child: FadingText('Long Press to Confirm',style: GoogleFonts.raleway(fontSize: 18.0),),
                                                                  ),

                                                                  InkWell(
                                                                    onLongPress: (){
                                                                      setState(() {
                                                                        processing=true;
                                                                      });
                                                                      if(walletPay==true){
                                                                        Firestore.instance.collection("users").document(widget.userEmail).get().then((doc){
                                                                          if(doc.exists){
                                                                            if(doc.data['walletBalance']>=399){
                                                                              Firestore.instance.collection("users").document(widget.userEmail).updateData({
                                                                                "walletBalance":doc.data['walletBalance']-399,
                                                                              }).then((value) {
                                                                                Firestore.instance.collection("users").document("oshoyatra2002@gmail.com")
                                                                                    .get()
                                                                                    .then((document) {
                                                                                  if (document.exists) {
                                                                                    Firestore.instance.collection("users").document(
                                                                                        "oshoyatra2002@gmail.com").updateData({
                                                                                      "walletBalance": document.data['walletBalance'] +
                                                                                          399,
                                                                                    }).then((v) {
                                                                                      Firestore.instance.collection("users").document(loggedInEmail).setData(
                                                                                          {
                                                                                            "subscription":planChoose,
                                                                                          },merge: true
                                                                                      ).then((value){
                                                                                        Flushbar(
                                                                                          flushbarPosition: FlushbarPosition.TOP,
                                                                                          shouldIconPulse: true,
                                                                                          isDismissible: true,
                                                                                          titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                                                                          messageText: Text("Rs 499 has been deducted from your Osho Wallet",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                                          duration: Duration(seconds: 3),
                                                                                          icon: Icon(Icons.check,color: Colors.white,),
                                                                                          backgroundColor:  Colors.green,
                                                                                        )..show(context).then((v){
                                                                                          Navigator.pop(context);
                                                                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                                                                                builder: (context){
                                                                                                  return SubscritionHomePage(userEmail: widget.userEmail,);
                                                                                                }
                                                                                            )).then((value){
                                                                                            Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").add({
                                                                                              "amount":399,
                                                                                              "fromName":doc.data['name'],
                                                                                              "toName":"Osho Silver Subscription",
                                                                                              "fromEmail":doc.data['email'],
                                                                                              "toEmail":"oshoyatra2002@gmail.com",
                                                                                              "time":DateTime.now().toIso8601String(),
                                                                                            }).then((value) {
                                                                                              Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").document(value.documentID).updateData(
                                                                                                  {
                                                                                                    "transactionId": value.documentID,
                                                                                                  });
                                                                                              Firestore.instance.collection("walletTransactions").document("oshoyatra2002@gmail.com").collection("transactions").document(value.documentID).setData({
                                                                                                "amount":399,
                                                                                                "fromName":doc.data['name'],
                                                                                                "toName":"Osho Silver Subscription",
                                                                                                "fromEmail":doc.data['email'],
                                                                                                "toEmail":"oshoyatra2002@gmail.com",
                                                                                                "time":DateTime.now().toIso8601String(),
                                                                                                "transactionId": value.documentID,
                                                                                              });
                                                                                            }
                                                                                            );
                                                                                          });
                                                                                            //payingDiamond=false;
                                                                                           // payingGold=false;
                                                                                            //payingSilver=false;
                                                                                            //plan=planChoose;

                                                                                        });

                                                                                      });
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                            }
                                                                            else{
                                                                              Flushbar(
                                                                                flushbarPosition: FlushbarPosition.TOP,
                                                                                shouldIconPulse: true,
                                                                                isDismissible: true,
                                                                                titleText: Text("Payment Failed",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                                                                messageText: Text("Insufficient Balance in Osho Wallet\nPlease add Money to your wallet",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                                duration: Duration(seconds: 2),
                                                                                icon: Icon(Icons.close,color: Colors.white,),
                                                                                backgroundColor: deepRed,
                                                                              )..show(context).then((value){
                                                                                setState(() {
                                                                                  payingDiamond=false;
                                                                                  payingGold=false;
                                                                                  payingSilver=false;
                                                                                });
                                                                              });
                                                                            }
                                                                          }
                                                                        });
                                                                      }
                                                                      else{
                                                                        openCheckout("Silver",399);
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.width,
                                                                      height: 50,
                                                                      decoration: BoxDecoration(
                                                                        color: deepRed,
                                                                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(12.0) ,bottomLeft: Radius.circular(12.0)),
                                                                      ),
                                                                      alignment: Alignment.bottomCenter,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Text("Confirm Payment",style: GoogleFonts.balooBhaina(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),
                                                                            processing?Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal:16.0),
                                                                              child: Container(
                                                                                  width: 22.0,
                                                                                  height: 22.0,
                                                                                  child: CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 2.0,)),
                                                                            ):Container()
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                      ]
                                                  )
                                              )));});});

                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget goldPlan(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Color(0xff5a348b),
          gradient: LinearGradient(
              colors: [Color(0xffebac38), Color(0xffde4d2a)],
              begin: Alignment.centerRight,
              end: Alignment(-1.0, -2.0)), //Gradient
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Text
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Icon(
                                      FontAwesomeIcons.dropbox,
                                      color: new Color(0xffffffff),
                                      size: 40.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'Gold',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Text(
                                      '₹ 499/month',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Two Column Table
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Services',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Yes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Text(
                            'Extra Activities',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        DataCell(
                          Icon(
                            FontAwesomeIcons.times,
                            color: Colors.white54,
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Text(
                            'Guide',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        DataCell(
                          Icon(
                            FontAwesomeIcons.times,
                            color: Colors.white54,
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Text(
                            'Parking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        DataCell(
                          Icon(FontAwesomeIcons.check,
                              color: new Color(0xffffffff)),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Text(
                            'Meditation classes ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        DataCell(
                          Icon(FontAwesomeIcons.check,
                              color: new Color(0xffffffff)),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Text(
                            'Wifi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        DataCell(
                          Icon(FontAwesomeIcons.check,
                              color: new Color(0xffffffff)),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Text(
                            '24/7 Support',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        DataCell(
                          Icon(
                            FontAwesomeIcons.times,
                            color: Colors.white54,
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Text(
                            'Meditation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        DataCell(
                          Icon(FontAwesomeIcons.check,
                              color: new Color(0xffffffff)),
                        ),
                      ]),
                    ],
                  ),

                  //Button
                  Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: RaisedButton(
                        color: new Color(0xffffffff),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Get Started',
                              style: GoogleFonts.balooBhai(
                                fontSize: 19,
                                color: new Color(0xffde4d2a),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            planChoose="Gold";
                            payingGold=true;
                          });

                          showDialog(context: context,
                              builder: (context){
                                return StatefulBuilder(
                                    builder: (context,setState){
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(vertical:120.0,horizontal: 0.0),
                                          child: AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                              ),
                                              contentPadding: const EdgeInsets.all(0),
                                              content:Card(
                                                  shape:RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                                  ),
                                                  child: Stack(
                                                      alignment: Alignment.bottomCenter,
                                                      children: <Widget>[
                                                        Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: <Widget>[
                                                                            Text("Confirm Payment",style: GoogleFonts.raleway(fontSize: 20.0,fontWeight: FontWeight.w600),),
                                                                            IconButton(
                                                                              icon: Icon(Icons.close),
                                                                              onPressed: (){
                                                                                setState(() {
                                                                                  processing=false;
                                                                                });
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ]
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(16.0),
                                                                    child: Text("Do you confirm Your payment of ₹ 499 to Osho Gold Subscription",
                                                                      style: GoogleFonts.raleway(fontSize: 18.0),
                                                                    ),
                                                                  ),


                                                                  Padding(
                                                                    padding: const EdgeInsets.all(16.0),
                                                                    child: FadingText('Long Press to Confirm',style: GoogleFonts.raleway(fontSize: 18.0),),
                                                                  ),

                                                                  InkWell(
                                                                    onLongPress: (){
                                                                      setState(() {
                                                                        processing=true;
                                                                      });
                                                                      if(walletPay==true){
                                                                        Firestore.instance.collection("users").document(widget.userEmail).get().then((doc){
                                                                          if(doc.exists){
                                                                            if(doc.data['walletBalance']>=499){
                                                                              Firestore.instance.collection("users").document(widget.userEmail).updateData({
                                                                                "walletBalance":doc.data['walletBalance']-499,
                                                                              }).then((value) {
                                                                                Firestore.instance.collection("users").document("oshoyatra2002@gmail.com")
                                                                                    .get()
                                                                                    .then((document) {
                                                                                  if (document.exists) {
                                                                                    Firestore.instance.collection("users").document(
                                                                                        "oshoyatra2002@gmail.com").updateData({
                                                                                      "walletBalance": document.data['walletBalance'] +
                                                                                          499,
                                                                                    }).then((v) {
                                                                                      Firestore.instance.collection("users").document(loggedInEmail).setData(
                                                                                          {
                                                                                            "subscription":planChoose,
                                                                                          },merge: true
                                                                                      ).then((value){
                                                                                        Flushbar(
                                                                                          flushbarPosition: FlushbarPosition.TOP,
                                                                                          shouldIconPulse: true,
                                                                                          isDismissible: true,
                                                                                          titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                                                                          messageText: Text("Rs 499 has been deducted from your Osho Wallet",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                                          duration: Duration(seconds: 3),
                                                                                          icon: Icon(Icons.check,color: Colors.white,),
                                                                                          backgroundColor:  Colors.green,
                                                                                        )..show(context).then((v){
                                                                                          Navigator.pop(context);
                                                                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                                                                              builder: (context){
                                                                                                return SubscritionHomePage(userEmail: widget.userEmail,);
                                                                                              }
                                                                                          )).then((value){
                                                                                            Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").add({
                                                                                              "amount":499,
                                                                                              "fromName":doc.data['name'],
                                                                                              "toName":"Osho Gold Subscription",
                                                                                              "fromEmail":doc.data['email'],
                                                                                              "toEmail":"oshoyatra2002@gmail.com",
                                                                                              "time":DateTime.now().toIso8601String(),
                                                                                            }).then((value) {
                                                                                              Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").document(value.documentID).updateData(
                                                                                                  {
                                                                                                    "transactionId": value.documentID,
                                                                                                  });
                                                                                              Firestore.instance.collection("walletTransactions").document("oshoyatra2002@gmail.com").collection("transactions").document(value.documentID).setData({
                                                                                                "amount":499,
                                                                                                "fromName":doc.data['name'],
                                                                                                "toName":"Osho Gold Subscription",
                                                                                                "fromEmail":doc.data['email'],
                                                                                                "toEmail":"oshoyatra2002@gmail.com",
                                                                                                "time":DateTime.now().toIso8601String(),
                                                                                                "transactionId": value.documentID,
                                                                                              });
                                                                                            }
                                                                                            );
                                                                                          });




                                                                                        });
                                                                                      });
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                            }
                                                                            else{
                                                                              Flushbar(
                                                                                flushbarPosition: FlushbarPosition.TOP,
                                                                                shouldIconPulse: true,
                                                                                isDismissible: true,
                                                                                titleText: Text("Payment Failed",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                                                                messageText: Text("Insufficient Balance in Osho Wallet\nPlease add Money to your wallet",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                                duration: Duration(seconds: 2),
                                                                                icon: Icon(Icons.close,color: Colors.white,),
                                                                                backgroundColor: deepRed,
                                                                              )..show(context).then((value){
                                                                                setState(() {
                                                                                  payingDiamond=false;
                                                                                  payingGold=false;
                                                                                  payingSilver=false;
                                                                                });
                                                                              });
                                                                            }
                                                                          }
                                                                        });
                                                                      }
                                                                      else{
                                                                        openCheckout("Gold",499);
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.width,
                                                                      height: 50,
                                                                      decoration: BoxDecoration(
                                                                        color: deepRed,
                                                                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(12.0) ,bottomLeft: Radius.circular(12.0)),
                                                                      ),
                                                                      alignment: Alignment.bottomCenter,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Text("Confirm Payment",style: GoogleFonts.balooBhaina(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),
                                                                            processing?Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal:16.0),
                                                                              child: Container(
                                                                                  width: 22.0,
                                                                                  height: 22.0,
                                                                                  child: CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 2.0,)),
                                                                            ):Container()
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                      ]
                                                  )
                                              )));});});

                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget diamondPLan(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Color(0xff5a348b),
          gradient: LinearGradient(
              colors: [Color(0xffcb3a57), Color(0xffcb3a57)],
              begin: Alignment.centerRight,
              end: Alignment(-1.0, -1.0)), //Gradient
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Text
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Icon(
                                      FontAwesomeIcons.soundcloud,
                                      color: new Color(0xffffffff),
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Text(
                                      'Diamond',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Text(
                                      '₹ 599/month',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Two Column Table
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                        ),
                        DataCell(
                          Text(
                            'Extra Activities',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                        ),
                        DataCell(
                          Text(
                            'Guide',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Icon(FontAwesomeIcons.check,
                              color: new Color(0xffffffff)),
                        ),
                        DataCell(
                          Text(
                            'Parking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Icon(FontAwesomeIcons.check,
                              color: new Color(0xffffffff)),
                        ),
                        DataCell(
                          Text(
                            'Meditation Classes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Icon(FontAwesomeIcons.check,
                              color: new Color(0xffffffff)),
                        ),
                        DataCell(
                          Text(
                            'Wifi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white54,
                          ),
                        ),
                        DataCell(
                          Text(
                            '24/7 Support',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ]),
                      DataRow(cells: <DataCell>[
                        DataCell(
                          Icon(FontAwesomeIcons.check,
                              color: new Color(0xffffffff)),
                        ),
                        DataCell(
                          Text(
                            'Religious Activities',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),

                  //Button
                  Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: RaisedButton(
                        color: new Color(0xffffffff),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Get Started',
                              style: GoogleFonts.balooBhai(
                                fontSize: 19,
                                color: new Color(0xffcb3a57),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            planChoose="Diamond";
                            payingDiamond=true;
                          });
                          showDialog(context: context,
                              builder: (context){
                                return StatefulBuilder(
                                    builder: (context,setState){
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(vertical:120.0,horizontal: 0.0),
                                          child: AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                              ),
                                              contentPadding: const EdgeInsets.all(0),
                                              content:Card(
                                                  shape:RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                                  ),
                                                  child: Stack(
                                                      alignment: Alignment.bottomCenter,
                                                      children: <Widget>[
                                                        Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: <Widget>[
                                                                            Text("Confirm Payment",style: GoogleFonts.raleway(fontSize: 20.0,fontWeight: FontWeight.w600),),
                                                                            IconButton(
                                                                              icon: Icon(Icons.close),
                                                                              onPressed: (){
                                                                                setState(() {
                                                                                  processing=false;
                                                                                });
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ]
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(16.0),
                                                                    child: Text("Do you confirm Your payment of ₹ 599 to Osho Diamond Subscription",
                                                                      style: GoogleFonts.raleway(fontSize: 18.0),
                                                                    ),
                                                                  ),


                                                                  Padding(
                                                                    padding: const EdgeInsets.all(16.0),
                                                                    child: FadingText('Long Press to Confirm',style: GoogleFonts.raleway(fontSize: 18.0),),
                                                                  ),

                                                                  InkWell(
                                                                    onLongPress: (){
                                                                      setState(() {
                                                                        processing=true;
                                                                      });
                                                                      if(walletPay==true){
                                                                        Firestore.instance.collection("users").document(widget.userEmail).get().then((doc){
                                                                          if(doc.exists){
                                                                            if(doc.data['walletBalance']>=599){
                                                                              Firestore.instance.collection("users").document(widget.userEmail).updateData({
                                                                                "walletBalance":doc.data['walletBalance']-599,
                                                                              }).then((value) {
                                                                                Firestore.instance.collection("users").document("oshoyatra2002@gmail.com")
                                                                                    .get()
                                                                                    .then((document) {
                                                                                  if (document.exists) {
                                                                                    Firestore.instance.collection("users").document(
                                                                                        "oshoyatra2002@gmail.com").updateData({
                                                                                      "walletBalance": document.data['walletBalance'] +
                                                                                          599,
                                                                                    }).then((v) {
                                                                                      Firestore.instance.collection("users").document(loggedInEmail).setData(
                                                                                          {
                                                                                            "subscription":planChoose,
                                                                                          },merge: true
                                                                                      ).then((value){
                                                                                        Flushbar(
                                                                                          flushbarPosition: FlushbarPosition.TOP,
                                                                                          shouldIconPulse: true,
                                                                                          isDismissible: true,
                                                                                          titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                                                                          messageText: Text("Rs 599 has been deducted from your Osho Wallet",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                                          duration: Duration(seconds: 3),
                                                                                          icon: Icon(Icons.check,color: Colors.white,),
                                                                                          backgroundColor:  Colors.green,
                                                                                        )..show(context).then((v){
                                                                                          Navigator.pop(context);
                                                                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                                                                              builder: (context){
                                                                                                return SubscritionHomePage(userEmail: widget.userEmail,);
                                                                                              }
                                                                                          )).then((value){
                                                                                            Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").add({
                                                                                              "amount":599,
                                                                                              "fromName":doc.data['name'],
                                                                                              "toName":"Osho Diamond Subscription",
                                                                                              "fromEmail":doc.data['email'],
                                                                                              "toEmail":"oshoyatra2002@gmail.com",
                                                                                              "time":DateTime.now().toIso8601String(),
                                                                                            }).then((value) {
                                                                                              Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").document(value.documentID).updateData(
                                                                                                  {
                                                                                                    "transactionId": value.documentID,
                                                                                                  });
                                                                                              Firestore.instance.collection("walletTransactions").document("oshoyatra2002@gmail.com").collection("transactions").document(value.documentID).setData({
                                                                                                "amount":599,
                                                                                                "fromName":doc.data['name'],
                                                                                                "toName":"Osho Diamond Subscription",
                                                                                                "fromEmail":doc.data['email'],
                                                                                                "toEmail":"oshoyatra2002@gmail.com",
                                                                                                "time":DateTime.now().toIso8601String(),
                                                                                                "transactionId": value.documentID,
                                                                                              });
                                                                                            }
                                                                                            );
                                                                                          });



                                                                                        });
                                                                                      });
                                                                                    });
                                                                                  }
                                                                                });
                                                                              });
                                                                            }
                                                                            else{
                                                                              Flushbar(
                                                                                flushbarPosition: FlushbarPosition.TOP,
                                                                                shouldIconPulse: true,
                                                                                isDismissible: true,
                                                                                titleText: Text("Payment Failed",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                                                                messageText: Text("Insufficient Balance in Osho Wallet\nPlease add Money to your wallet",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                                duration: Duration(seconds: 2),
                                                                                icon: Icon(Icons.close,color: Colors.white,),
                                                                                backgroundColor: deepRed,
                                                                              )..show(context).then((value){
                                                                                setState(() {
                                                                                  payingDiamond=false;
                                                                                  payingGold=false;
                                                                                  payingSilver=false;
                                                                                });
                                                                              });
                                                                            }
                                                                          }
                                                                        });
                                                                      }
                                                                      else{
                                                                        openCheckout("Diamond",599);
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.width,
                                                                      height: 50,
                                                                      decoration: BoxDecoration(
                                                                        color: deepRed,
                                                                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(12.0) ,bottomLeft: Radius.circular(12.0)),
                                                                      ),
                                                                      alignment: Alignment.bottomCenter,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Text("Confirm Payment",style: GoogleFonts.balooBhaina(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),
                                                                            processing?Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal:16.0),
                                                                              child: Container(
                                                                                  width: 22.0,
                                                                                  height: 22.0,
                                                                                  child: CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 2.0,)),
                                                                            ):Container()
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                      ]
                                                  )
                                              )));});});

                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> plans=[silverPlan(),goldPlan(),diamondPLan()];
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            payingSilver?LinearProgressIndicator():payingGold?LinearProgressIndicator():payingDiamond?LinearProgressIndicator():Container(),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Subscription",
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30.0),
                            ),
                            Text(
                              "Plans",
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 25.0),
                            ),
                          ],
                        ),

                        FloatingActionButton(
                          heroTag: 242524,
                          backgroundColor: Colors.redAccent,
                          child:Icon(Icons.reply,color: Colors.white,),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],),
                  ),
                  plan=="Inactive"?Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Switch(
                            value: walletPay,
                            onChanged: (value) {
                              setState(() {
                                walletPay = value;
                              });
                            },
                            activeTrackColor: Colors.indigoAccent,
                            activeColor: deepRed,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Text(
                            'Pay directly from Osho Wallet',
                            style: GoogleFonts.balooBhai(color: Colors.black,fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ):Container(),

                  plan=="Inactive"?Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: FadingText(
                      'Swipe to view Plans',
                      style: GoogleFonts.aBeeZee(color: Colors.black,fontSize: 18.0),
                    ),
                  ):Container(),

                  plan=="Inactive"?Container(
                    height: MediaQuery.of(context).size.height*0.9,
                    child: CarouselSlider(
                      items: plans.toList(),
                      options:CarouselOptions(
                        viewportFraction: 0.95,
                        enableInfiniteScroll: true,
                        reverse: false,
                        carouselController: CarouselController(),
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        height: MediaQuery.of(context).size.height*0.9,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ):Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text("Already subscribed to $plan Plan\nContact Ashram for changing/upgrading Plan",
                    style: GoogleFonts.aBeeZee(fontSize: 18,color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> plans=[];





ListTile myRowDataIcon(IconData iconVal, String rowVal) {
  return ListTile(
    leading: Icon(iconVal, color: new Color(0xffffffff)),
    title: Text(
      rowVal,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
