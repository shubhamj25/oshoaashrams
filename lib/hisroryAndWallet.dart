import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/walletCardScreen.dart';
import 'package:rooms/walletHomescreen.dart';
import 'package:rooms/widgets/custom_icons_icons.dart';

import 'MyRide.dart';
import 'aeoui.dart';

class WalletApp extends StatefulWidget {
  final String email;
  WalletApp(this.email);
  @override
  _WalletAppState createState() => _WalletAppState();
}

class _WalletAppState extends State<WalletApp> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    var screens = [
      WalletHomeScreen(email: widget.email,),
      CardScreen(),
      MoneyRequests(email: widget.email,),
    ]; //screens for each tab
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 0, 0, 1),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              title: Text("Card"),
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(CustomIcons.money_bill),
              title: Text("Requests"),)
        ],
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        showUnselectedLabels: true,
        iconSize: 30,
      ),
      body: screens[selectedTab],
    );
  }
}

List<MoneyReqCard> moneyReq=[];

class MoneyRequests extends StatefulWidget {
  final String email;
  MoneyRequests({this.email});
  @override
  _MoneyRequestsState createState() => _MoneyRequestsState();
}

class _MoneyRequestsState extends State<MoneyRequests> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Money Requests",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Following of your friends have requested help from you !",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Colors.grey),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("walletRequests").document(widget.email).collection("requests").snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      moneyReq.clear();
                      for(int i=0;i<snapshot.data.documents.length;i++){
                        moneyReq.add(MoneyReqCard(snapshot.data.documents.elementAt(i).data['fromImg'],
                            snapshot.data.documents.elementAt(i).data['fromName'],
                            snapshot.data.documents.elementAt(i).data['amount'],
                            snapshot.data.documents.elementAt(i).data['fromEmail'],
                            snapshot.data.documents.elementAt(i).data['purpose'],
                            DateTime.parse(snapshot.data.documents.elementAt(i).data['receivedOn']),
                            snapshot.data.documents.elementAt(i).data['reqId'],
                        ));
                      }
                    }
                    return !snapshot.hasData?Center(child: CircularProgressIndicator())
                        :Column(children:moneyReq,);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoneyReqCard extends StatefulWidget {
  final String fromEmail,purpose,fromName,fromImg,id;
  final DateTime receivedOn;
  final int amount;
  MoneyReqCard(this.fromImg,this.fromName,this.amount,this.fromEmail,this.purpose,this.receivedOn, this.id);
  @override
  _MoneyReqCardState createState() => _MoneyReqCardState();
}

class _MoneyReqCardState extends State<MoneyReqCard> {
  bool processing=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
      child: Card(
        elevation: 12.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
                    child: Text("${widget.receivedOn.day}, ${month(widget.receivedOn.month)} ${widget.receivedOn.year} @ ${widget.receivedOn.hour}:${widget.receivedOn.minute} hrs",textAlign: TextAlign.right,
                    style: GoogleFonts.raleway(fontStyle: FontStyle.italic,fontWeight: FontWeight.w600,color: Colors.grey),
                    ),
                  ),
              ),
              ListTile(
               leading:Material(
                 shape: CircleBorder(),
                 child: Container(
                   width: 60.0,
                   height: 60.0,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     border: Border.all(color:deepRed,width: 3.0),
                   ),
                   child: CachedNetworkImage(
                     imageUrl: widget.fromImg,
                     fadeInDuration: Duration(milliseconds: 500),
                     fadeInCurve: Curves.easeIn,
                     imageBuilder: (context, imageProvider) => Container(
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         image: DecorationImage(
                             image: imageProvider, fit: BoxFit.cover),
                       ),
                     ),
                     placeholder: (context, url) => Padding(
                       padding: const EdgeInsets.all(32.0),
                       child: CircularProgressIndicator(),
                     ),
                     errorWidget: (context, url, error) => Icon(Icons.error),
                   ),
                 ),
               ),
               title: Text("${widget.fromName} has requested Rs ${widget.amount} from you", style: TextStyle(
                   fontWeight: FontWeight.w900,
                   fontSize: 18,
                   color: Colors.black54),
               ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("${widget.fromEmail} requested this amount on purpose  of\n${widget.purpose}", style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.grey),),
                ),

              ),
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0)),
                      ),
                      width: MediaQuery.of(context).size.width*0.43,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0)),
                        ),
                        child: Text("Send",style: GoogleFonts.balooBhaina(color: Colors.white,fontSize: 16.0),),
                        color: deepRed,
                        onPressed: (){
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
                                                                            Text("Send Money",style: GoogleFonts.raleway(fontSize: 20.0,fontWeight: FontWeight.w600),),
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
                                                                    child: Text("Do you confirm Your payment of ₹ ${widget.amount} to ${widget.fromEmail} i.e ${widget.fromName} ?",
                                                                      style: GoogleFonts.raleway(fontSize: 18.0),
                                                                    ),
                                                                  ),

                                                                  InkWell(
                                                                    onTap: (){
                                                                      setState(() {
                                                                        processing=true;
                                                                      });
                                                                      Firestore.instance.collection("users").document(loggedInEmail).get().then((doc){
                                                                        if(doc.exists){
                                                                          if(doc.data['walletBalance']>=widget.amount){
                                                                            Firestore.instance.collection("users").document(loggedInEmail).updateData({
                                                                              "walletBalance":doc.data['walletBalance']-widget.amount,
                                                                            }).then((value){
                                                                              Firestore.instance.collection("users").document(widget.fromEmail).get().then((document){
                                                                                if(document.exists){
                                                                                  Firestore.instance.collection("users").document(widget.fromEmail).updateData({
                                                                                    "walletBalance":document.data['walletBalance']+widget.amount,
                                                                                  }).then((v){
                                                                                    setState(() {
                                                                                      processing=false;
                                                                                    });
                                                                                    Firestore.instance.collection("walletRequests").document(loggedInEmail).collection("requests").document(widget.id).delete();
                                                                                    Navigator.pop(context);
                                                                                    Flushbar(
                                                                                      flushbarPosition: FlushbarPosition.TOP,
                                                                                      shouldIconPulse: true,
                                                                                      isDismissible: true,
                                                                                      titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                                                                      messageText: Text("${widget.amount} has benn deducted from your Osho Wallet",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                                      duration: Duration(seconds: 2),
                                                                                      icon: Icon(Icons.check_circle,color: Colors.white,),
                                                                                      backgroundColor:  Colors.green,
                                                                                    )..show(context);
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
                                                                              messageText: Text("Insufficient Balance in Osho Wallet.Please Add money to your Osho Wallet for InApp Transactions.",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                              duration: Duration(seconds: 2),
                                                                              icon: Icon(Icons.close,color: Colors.white,),
                                                                              backgroundColor:  deepRed,
                                                                            )..show(context).then((value){
                                                                              setState(() {
                                                                                processing=false;
                                                                              });
                                                                              Navigator.pop(context);
                                                                            });
                                                                          }
                                                                        }
                                                                      });

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
                        }
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0)),
                      ),
                      width: MediaQuery.of(context).size.width*0.43,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0)),
                        ),
                        child: Text("Reject",style: GoogleFonts.balooBhaina(color: Colors.white,fontSize: 16.0),),
                        color: deepRed,
                        onPressed: (){
                          Firestore.instance.collection("walletRequests").document(loggedInEmail).collection("requests").document(widget.id).delete();
                        },
                      ),
                    )
                  ],
                ),
              ),
             ],
          ),
        ),
      ),
    );
  }
}
