import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rooms/aeoui.dart';
import 'package:rooms/widgets/custom_icons_icons.dart';

List<Map<String,dynamic>> firebaseBooking=[];

List<PersonCard> persons=[];
class BookEvent extends StatefulWidget {
  final String eventName,userEmail;
  final int eventPrice;
  BookEvent({this.eventName, this.userEmail,this.eventPrice});
  @override
  _BookEventState createState() => _BookEventState();
}

class _BookEventState extends State<BookEvent> {
  bool adding=false;
  Razorpay _razorPay;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseBooking.clear();
    _razorPay=Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,_handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorPay.clear();
  }

  void openCheckout() async {
    var options;
    Firestore.instance.collection("users").document(widget.userEmail).get().then((doc){
      setState(() {
        options = {
          'key': 'rzp_test_PyfpsGv8KwvPDJ',
          'amount': widget.eventPrice*persons.length*100,
          'name': 'Osho Aaashrams',
          'description': '${widget.eventName} booking request by\n${widget.userEmail}',
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
    SafeArea(
      child: Flushbar(
        shouldIconPulse: true,
        isDismissible: true,
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
        messageText: Text("Booking Confirmed with id ${response.paymentId}",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
        duration: Duration(seconds: 1),
        icon: Icon(Icons.check,color: Colors.white,),
        backgroundColor:  Colors.green,
      )..show(context).then((value){
        Firestore.instance.collection("bookings").document(loggedInEmail).collection("${widget.userEmail}_bookings").add(
            {
              "eventName":widget.eventName,
              "email":widget.userEmail,
              "totalPrice":persons.length*widget.eventPrice,
              "bookedAt":Timestamp.now(),
              "personDetails":firebaseBooking,
            }
        ).then((value){
          Firestore.instance.collection("bookings").document(loggedInEmail).collection("${widget.userEmail}_bookings").document(value.documentID).updateData({
            "bookingId":value.documentID,
          });
          Firestore.instance.collection("bookings").document(loggedInEmail).collection('${widget.userEmail}_${widget.eventName}_persons').getDocuments().then((snapshot) {
            for (DocumentSnapshot ds in snapshot.documents){
              ds.reference.delete();
            }});
          setState(() {
            adding=false;
          });
        });

        Navigator.pop(context);

      }),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    SafeArea(
      child: Flushbar(
        shouldIconPulse: true,
        isDismissible: true,
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text("Payment Failed",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
        messageText: Text("${response.message}",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
        duration: Duration(seconds: 1),
        icon: Icon(Icons.close,color: Colors.white,),
        backgroundColor:  Colors.red,
      )..show(context).then((value){
        Firestore.instance.collection("bookings").document(loggedInEmail).collection('${widget.userEmail}_${widget.eventName}_persons').getDocuments().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.documents){
            ds.reference.delete();
          }});
        Navigator.pop(context);
      }),
    );
  }


  void _handleExternalWallet(ExternalWalletResponse response) {
    SafeArea(
      child: Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        shouldIconPulse: true,
        isDismissible: true,
        titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
        messageText: Text("Payment Made using ${response.walletName}",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
        duration: Duration(seconds: 1),
        icon: Icon(Icons.check,color: Colors.white,),
        backgroundColor:  Colors.green,
      )..show(context).then((value){
        Firestore.instance.collection("bookings").document(loggedInEmail).collection("${widget.userEmail}_bookings").add(
            {
              "eventName":widget.eventName,
              "email":widget.userEmail,
              "totalPrice":persons.length*widget.eventPrice,
              "bookedAt":Timestamp.now(),
              "personDetails":firebaseBooking,
            }
        ).then((value){

          Firestore.instance.collection("bookings").document(loggedInEmail).collection("${widget.userEmail}_bookings").document(value.documentID).updateData({
            "bookingId":value.documentID,
          });
          Firestore.instance.collection("bookings").document(loggedInEmail).collection('${widget.userEmail}_${widget.eventName}_persons').getDocuments().then((snapshot) {
            for (DocumentSnapshot ds in snapshot.documents){
              ds.reference.delete();
            }});
          setState(() {
            adding=false;
          });
        });
        Navigator.pop(context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom:60.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    adding?LinearProgressIndicator():Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Booking",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 35.0),
                          ),

                          FloatingActionButton(
                            heroTag: 1,
                            backgroundColor: Colors.redAccent,
                            child:Icon(Icons.close,color: Colors.white,),
                            onPressed: () {
                              Firestore.instance.collection("bookings").document(loggedInEmail).collection('${widget.userEmail}_${widget.eventName}_persons').getDocuments().then((snapshot) {
                                for (DocumentSnapshot ds in snapshot.documents){
                                  ds.reference.delete();
                                }});
                              Navigator.pop(context);
                            },
                          )
                        ],),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "Event Location",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.red,fontSize: 21.0,fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              widget.eventName,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.w500),
                            ),
                          ),

                          ListTile(
                            title: Text(
                              "Price",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.red,fontSize: 21.0,fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              "₹ ${widget.eventPrice} /per person per night",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.w500),
                            ),
                          ),

                        ],
                      ),
                    ),
                    FadingText('Long Press to Pay',style: GoogleFonts.aBeeZee(fontSize: 16.0),),

                    Padding(
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
                    ),

                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom:20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.person_add,color: Color.fromRGBO(253, 11, 23, 1),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Add Persons",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,color:  Color.fromRGBO(253, 11, 23, 1)),),
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        showDialog(
                            context:context,
                            builder:(context){
                              return StatefulBuilder(
                                  builder: (context,setState){
                                    return AddPersonCard(widget.eventName,widget.userEmail);
                                  }
                              );
                            }
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom:50.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(bottom:8.0,left: 8.0,right:8.0),
                              child:StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance.collection("bookings").document(loggedInEmail).collection("${widget.userEmail}_${widget.eventName}_persons").snapshots(),
                                builder: (context,snapshot){
                                  persons.clear();
                                  firebaseBooking.clear();
                                  Firestore.instance.collection("users").document(widget.userEmail.toString()).get().then((doc){
                                    if(doc.exists){
                                      Firestore.instance.collection("bookings").document(loggedInEmail).collection("${widget.userEmail}_${widget.eventName}_persons").document(doc.data['name'].toString()).setData({
                                        "name":doc.data['name'],
                                        "email":doc.data['email'],
                                        "gender":doc.data['gender'],
                                        "age":doc.data['age'],
                                        "eventName":widget.eventName,
                                      });
                                    }
                                  });
                                  if(snapshot.hasData){
                                    for(int i=0;i<snapshot.data.documents.length;i++){
                                      persons.add(PersonCard(snapshot.data.documents.elementAt(i).data['name'], snapshot.data.documents.elementAt(i).data['email'], snapshot.data.documents.elementAt(i).data['age'], snapshot.data.documents.elementAt(i).data['gender'],snapshot.data.documents.elementAt(i).data['eventName']));
                                      firebaseBooking.add({"name":snapshot.data.documents.elementAt(i).data['name'],"email": snapshot.data.documents.elementAt(i).data['email'],"age": snapshot.data.documents.elementAt(i).data['age'],"gender": snapshot.data.documents.elementAt(i).data['gender'],"eventName":snapshot.data.documents.elementAt(i).data['eventName']});
                                    }
                                  }
                                  return snapshot.hasData?Column(
                                    children: persons,
                                  ):Center(child: CircularProgressIndicator());
                                },
                              )
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(walletPay?"Pay from Wallet":"Proceed to Pay",style: GoogleFonts.balooBhai(fontSize: 22.0,color: Colors.white),),
                    adding?Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(width:25,height:25,child:CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 2,)),
                    ):Container()
                  ],
                ),
                color: Color.fromRGBO(253, 11, 23, 1),
                onLongPress: (){
                  setState(() {
                    adding=true;
                  });
                  if(walletPay==true){
                    Firestore.instance.collection("users").document(widget.userEmail).get().then((doc){
                      if(doc.exists){
                        if(doc.data['walletBalance']>=widget.eventPrice*persons.length){
                          Firestore.instance.collection("users").document(widget.userEmail).updateData({
                            "walletBalance":doc.data['walletBalance']-widget.eventPrice*persons.length,
                          }).then((value) {
                            Firestore.instance.collection("users").document("oshoyatra2002@gmail.com")
                                .get()
                                .then((document) {
                              if (document.exists) {
                                Firestore.instance.collection("users").document(
                                    "oshoyatra2002@gmail.com").updateData({
                                  "walletBalance": document.data['walletBalance'] +
                                      widget.eventPrice * persons.length,
                                }).then((v) {
                                  Firestore.instance.collection("bookings").document(loggedInEmail).collection("${widget.userEmail}_bookings").add(
                                      {
                                        "eventName":widget.eventName,
                                        "email":widget.userEmail,
                                        "totalPrice":persons.length*widget.eventPrice,
                                        "bookedAt":Timestamp.now(),
                                        "personDetails":firebaseBooking,
                                      }
                                  ).then((value){
                                    Flushbar(
                                      flushbarPosition: FlushbarPosition.TOP,
                                      shouldIconPulse: true,
                                      isDismissible: true,
                                      titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                      messageText: Text("Rs ${widget.eventPrice*persons.length} has been deducted from your Osho Wallet",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                      duration: Duration(seconds: 3),
                                      icon: Icon(Icons.check,color: Colors.white,),
                                      backgroundColor:  Colors.green,
                                    )..show(context).then((v){
                                      Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").add({
                                        "amount":widget.eventPrice*persons.length,
                                        "fromName":doc.data['name'],
                                        "toName":"Osho Ashrams",
                                        "fromEmail":doc.data['email'],
                                        "toEmail":"oshoyatra2002@gmail.com",
                                        "time":DateTime.now().toIso8601String(),
                                      }).then((value) {
                                        Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").document(value.documentID).updateData(
                                            {
                                              "transactionId": value.documentID,
                                            });
                                        Firestore.instance.collection("walletTransactions").document("oshoyatra2002@gmail.com").collection("transactions").document(value.documentID).setData({
                                          "amount":widget.eventPrice*persons.length,
                                          "fromName":doc.data['name'],
                                          "toName":"Osho Ashrams",
                                          "fromEmail":doc.data['email'],
                                          "toEmail":"oshoyatra2002@gmail.com",
                                          "time":DateTime.now().toIso8601String(),
                                          "transactionId": value.documentID,
                                        });
                                      }
                                      );
                                      Navigator.pop(context);
                                    });

                                    Firestore.instance.collection("bookings").document(loggedInEmail).collection("${widget.userEmail}_bookings").document(value.documentID).updateData({
                                      "bookingId":value.documentID,
                                    });
                                    Firestore.instance.collection("bookings").document(loggedInEmail).collection('${widget.userEmail}_${widget.eventName}_persons').getDocuments().then((snapshot) {
                                      for (DocumentSnapshot ds in snapshot.documents){
                                        ds.reference.delete();
                                      }});
                                    setState(() {
                                      adding=false;
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
                              adding=false;
                            });
                          });
                        }
                      }
                    });
                  }
                  else{
                    openCheckout();
                  }
                 },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PersonCard extends StatefulWidget {
  final String name,email,gender,age,eventName;
  PersonCard(this.name,this.email,this.age,this.gender, this.eventName);
  @override
  _PersonCardState createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseBooking.add({
      "name":widget.name,
      "email":widget.email,
      "gender":widget.gender,
      "age":widget.age,
      "eventCode":widget.eventName,
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        elevation: 12.0,
        child:
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.contacts,size: 25.0,color: Colors.blueAccent,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.0),),
                  ),
                ],
              ),
             IconButton(icon:Icon(Icons.delete,color: Colors.red,size: 25.0,),
             onPressed: (){
              Firestore.instance.collection("bookings").document(loggedInEmail).collection("${loggedInEmail}_${widget.eventName}_persons").document(widget.name).delete().then((value){
                persons.remove(PersonCard(widget.name,widget.email,widget.age, widget.gender, widget.eventName));
                firebaseBooking.remove({
                  "name":widget.name,
                  "email":widget.email,
                  "gender":widget.gender,
                  "age":widget.age,
                  "eventCode":widget.eventName,
                });
              });
                },
             )
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 85,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Text("Name:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                      ),
                    ),
                    Expanded(
                      child: Text(widget.name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                    )
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      width: 85,
                      child: Text("Email:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                    ),
                    Expanded(
                      child: Text(widget.email,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                    )
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      width: 85,
                      child: Text("Gender:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                    ),
                    Expanded(
                      child: Text(widget.gender,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                    )
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      width: 85.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Text("Age:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                      ),
                    ),
                    Expanded(
                      child: Text(widget.age,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}


class AddPersonCard extends StatefulWidget {
  final String userEmail,eventName;
  AddPersonCard(this.eventName,this.userEmail);
  @override
  _AddPersonCardState createState() => _AddPersonCardState();
}

class _AddPersonCardState extends State<AddPersonCard> {
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ageController=TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context,setState){
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          content:Container(
            height: MediaQuery.of(context).size.height*0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(Icons.person_add,size: 25,color: Colors.blueAccent,),
                                  ),
                                  Text("Add person",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.w600),),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.close,color: Colors.red,),
                                onPressed: ()=>Navigator.pop(context),
                              )
                            ],
                          ),
                          Container(
                            height: 400.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color:Colors.black,fontWeight: FontWeight.w700),
                                          validator: (String value){
                                            if(value==null||value==""){
                                              return "Field cannot be empty";
                                            }
                                            else{
                                              return null;
                                            }
                                          },
                                          onChanged: (String v){
                                            _formKey.currentState.validate();
                                          },
                                          keyboardType: TextInputType.text,
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            labelText: "Name",
                                            labelStyle:TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 5.0),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.text_fields,color: Colors.black,),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color:Colors.black,fontWeight: FontWeight.w700),
                                          controller: emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          validator:(String value){
                                            Pattern pattern =
                                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                            RegExp regex = new RegExp(pattern);
                                            if (!regex.hasMatch(value)) {
                                              return "Enter a valid email";
                                            }
                                            else{
                                              return null;
                                            }
                                          },
                                          onChanged: (String val){
                                            _formKey.currentState.validate();
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Email",
                                            labelStyle:TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 5.0),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.alternate_email,color: Colors.black,),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Material(
                                          elevation: 5.0,
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:18.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField(
                                                icon: Icon(Icons.arrow_drop_down_circle,color:Colors.blue),
                                                hint: new Text('Select Gender'),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                items: genderList,
                                                validator: (int value){
                                                  if(value==0){
                                                    return "Please select your gender";
                                                  }
                                                  else{
                                                    return null;
                                                  }
                                                },
                                                value: _selectedGender,
                                                onChanged: (value) {
                                                  _formKey.currentState.validate();
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
                                                },
                                                isExpanded: true,
                                                style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color:Colors.black,fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color:Colors.black,fontWeight: FontWeight.w700),
                                          onSaved: (String val)=>null,
                                          controller: ageController,
                                          onChanged: (String v){
                                            _formKey.currentState.validate();
                                          },
                                          validator: (String value){
                                            if(value==null||value==""){
                                              return "Field cannot be empty";
                                            }
                                            else if(int.parse(value)>100){
                                              return "Enter a valid Age";
                                            }
                                            else{
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: "Age",
                                              labelStyle:TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 5.0),
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.date_range,color: Colors.black,),
                                              ),
                                              border: InputBorder.none

                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Text("Add Person",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
                    ),
                    color:  Color.fromRGBO(253, 11, 23, 1),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        Firestore.instance.collection("bookings").document(loggedInEmail).collection("${widget.userEmail}_${widget.eventName}_persons").document(nameController.text.toString().trim()).setData({
                          "name":nameController.text,
                          "email":emailController.text.trim(),
                          "gender":gender,
                          "age":ageController.text.trim(),
                          "eventName":widget.eventName,
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
