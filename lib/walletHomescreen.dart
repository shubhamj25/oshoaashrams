

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rooms/MyRide.dart';
import 'package:rooms/aeoui.dart';
import 'package:rooms/widgets/custom_icons_icons.dart';

List<Map<String,dynamic>> transactions=[];

class WalletHomeScreen extends StatefulWidget {
  final String email;
  WalletHomeScreen({this.email});
  @override
  _WalletHomeScreenState createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {
  bool _sendEmailRegistered=true;
  final _addAmountController=TextEditingController();
  final _reqAmountController=TextEditingController();
  final _sendAmountController=TextEditingController();
  final _reqEmailController=TextEditingController();
  final _sendEmailController=TextEditingController();
  final _reqPurposeController=TextEditingController();
  final _sendPurposeController=TextEditingController();
  final _addMoneyFormKey = GlobalKey<FormState>();
  final _requestMoneyFormKey = GlobalKey<FormState>();
  final _sendMoneyFormKey = GlobalKey<FormState>();
  String _sendAmount;
  String _sendEmail;
  bool processing=false;
  Razorpay _razorPay;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  void openCheckout(String amount) async {
    var options;
    Firestore.instance.collection("users").document(widget.email).get().then((doc){
      setState(() {
        options = {
          'key': 'rzp_test_PyfpsGv8KwvPDJ',
          'name': 'Osho Aaashrams',
          'amount': int.parse(amount)*100,
          'description': 'Add money to ${doc.data['email']}\'s wallet',
          'prefill': {'contact': doc.data['phone'], 'email': doc.data['email']},
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

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    Flushbar(
      shouldIconPulse: true,
      isDismissible: true,
      flushbarPosition: FlushbarPosition.TOP,
      titleText: Text("Money Added Successfully",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
      messageText: Text("Payment id ${response.paymentId}",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
      duration: Duration(seconds: 1),
      icon: Icon(Icons.check,color: Colors.white,),
      backgroundColor:  Colors.green,
    )..show(context).then((value){
      Firestore.instance.collection("users").document(widget.email).get().then((doc){
        Firestore.instance.collection("users").document(widget.email).updateData({
          "walletBalance":doc.data['walletBalance'] + int.parse(_addAmountController.text),
        });
        _addAmountController.clear();
        setState(() {
          processing=false;
        });
      });
    });
  }

  _handlePaymentError(PaymentFailureResponse response) {
    Flushbar(
      shouldIconPulse: true,
      isDismissible: true,
      flushbarPosition: FlushbarPosition.TOP,
      titleText: Text("Payment Failed",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
      messageText: Text("${response.message}",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
      duration: Duration(seconds: 1),
      icon: Icon(Icons.close,color: Colors.white,),
      backgroundColor:  Colors.red,
    )..show(context).then((value){
      _addAmountController.clear();
      setState(() {
        processing=false;
      });
    });
  }

  _handleExternalWallet(ExternalWalletResponse response) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      shouldIconPulse: true,
      isDismissible: true,
      titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
      messageText: Text("Payment Made using ${response.walletName}",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
      duration: Duration(seconds: 1),
      icon: Icon(Icons.check,color: Colors.white,),
      backgroundColor:  Colors.green,
    )..show(context).then((value){
      Firestore.instance.collection("users").document(widget.email).get().then((doc){
        Firestore.instance.collection("users").document(widget.email).updateData({
          "walletBalance":doc.data['walletBalance'] + int.parse(_addAmountController.text),
        });
        _addAmountController.clear();
        setState(() {
          processing=false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: Firestore.instance.collection("users").document(widget.email).snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData?Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(child:CircularProgressIndicator()),
          ):Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                //Container for top data
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            " ₹ ${snapshot.data['walletBalance']}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon:Icon(Icons.home,
                                  color: Colors.white,
                                    size: 35,
                                ),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2.0,color: Colors.white),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data['photoURL'],
                                        fit: BoxFit.contain,
                                      )
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "Available Balance",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap:(){
                              showDialog(context: context,
                              builder: (context){
                                return StatefulBuilder(
                                  builder: (context,setState){
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical:60.0),
                                      child: AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                        ),
                                        contentPadding: const EdgeInsets.all(0),
                                        content:Card(
                                          shape:RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                          ),
                                          child: Scaffold(
                                            body: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Text("Add Money to\nWallet",style: GoogleFonts.raleway(fontSize: 20.0,fontWeight: FontWeight.w600),),
                                                            IconButton(
                                                              icon: Icon(Icons.close),
                                                              onPressed: (){
                                                                setState(() {
                                                                  processing=false;
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Form(
                                                        key: _addMoneyFormKey,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Material(
                                                            elevation: 12.0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.all(Radius.circular(12.0))
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: <Widget>[
                                                                Container(
                                                                  width:MediaQuery.of(context).size.width*0.55,
                                                                  child: TextFormField(
                                                                    validator: (value){
                                                                      if(value==""||value==null){
                                                                        return "Please enter a Amount";
                                                                      }
                                                                      else{
                                                                        return null;
                                                                      }
                                                                    },
                                                                    keyboardType: TextInputType.number,
                                                                    controller: _addAmountController,
                                                                    cursorColor: Colors.blueAccent,
                                                                    style: TextStyle(
                                                                      fontSize: 22.0,
                                                                        color: Colors.blueAccent,
                                                                        fontFamily: 'Raleway',
                                                                        fontWeight: FontWeight.bold
                                                                    ),
                                                                    onChanged: (v)=>_addMoneyFormKey.currentState.validate(),
                                                                    decoration: InputDecoration(
                                                                      errorMaxLines: 2,
                                                                      errorStyle: GoogleFonts.balooBhaina(color:deepRed),
                                                                      hintStyle: TextStyle(color: Colors.black38,fontSize: 16.0),
                                                                      contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                                                      border: InputBorder.none,
                                                                      hintText: 'Amount',
                                                                    ),
                                                                  ),
                                                                ),
                                                                Icon(CustomIcons.rupee_sign,size:18),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      processing=true;
                                                    });
                                                    if(_addMoneyFormKey.currentState.validate()){
                                                      openCheckout(_addAmountController.text);
                                                      Navigator.pop(context);
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
                                                          Text("Proceed",style: GoogleFonts.balooBhaina(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),
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
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              );
                             },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                    child: Icon(
                                      Icons.monetization_on,
                                      color: Colors.red[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Add Money",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap:(){
                              showDialog(context: context,
                                  builder: (context){
                                    return StatefulBuilder(
                                      builder: (context,setState){
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                          ),
                                          contentPadding: const EdgeInsets.all(0),
                                          content:Card(
                                            shape:RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                            ),
                                            child: Scaffold(
                                              body: Stack(
                                                alignment: Alignment.bottomCenter,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      height: MediaQuery.of(context).size.height,
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Text("Request Money",style: GoogleFonts.raleway(fontSize: 20.0,fontWeight: FontWeight.w600),),
                                                                  IconButton(
                                                                    icon: Icon(Icons.close),
                                                                    onPressed: (){
                                                                      setState(() {
                                                                        processing=false;
                                                                      });
                                                                      _reqAmountController.clear();
                                                                      _reqEmailController.clear();
                                                                      _reqPurposeController.clear();
                                                                      Navigator.pop(context);
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Form(
                                                              key: _requestMoneyFormKey,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: Material(
                                                                      elevation: 12.0,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Container(
                                                                            width:MediaQuery.of(context).size.width*0.55,
                                                                            child: TextFormField(
                                                                              validator: (value){
                                                                                if(value==""||value==null){
                                                                                  return "Please enter a Amount";
                                                                                }
                                                                                else{
                                                                                  return null;
                                                                                }
                                                                              },
                                                                              onChanged: (v)=>_addMoneyFormKey.currentState.validate(),
                                                                              keyboardType: TextInputType.number,
                                                                              controller: _reqAmountController,
                                                                              cursorColor: Colors.blueAccent,
                                                                              style: TextStyle(
                                                                                  fontSize: 22.0,
                                                                                  color: Colors.blueAccent,
                                                                                  fontFamily: 'Raleway',
                                                                                  fontWeight: FontWeight.bold
                                                                              ),
                                                                              decoration: InputDecoration(
                                                                                  errorMaxLines: 2,
                                                                                  errorStyle: GoogleFonts.balooBhaina(color:deepRed),
                                                                                  hintStyle: TextStyle(color: Colors.black38,fontSize: 16),
                                                                                  contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                                                                  border: InputBorder.none,
                                                                                  hintText: 'Amount'
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Icon(CustomIcons.rupee_sign,size: 18,),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: Material(
                                                                      elevation: 12.0,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Container(
                                                                            width:MediaQuery.of(context).size.width*0.55,
                                                                            child: TextFormField(
                                                                              validator:(String value){
                                                                                Pattern pattern =
                                                                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                                                RegExp regex = new RegExp(pattern);
                                                                                if(value==null||value==""){
                                                                                  return "Empty Field";
                                                                                }
                                                                                else if (!regex.hasMatch(value)) {
                                                                                  return "Enter a valid email";
                                                                                }
                                                                                else{
                                                                                  return null;
                                                                                }
                                                                              },

                                                                              onChanged: (v)=>_addMoneyFormKey.currentState.validate(),
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              controller: _reqEmailController,
                                                                              cursorColor: Colors.blueAccent,
                                                                              style: TextStyle(
                                                                                  color: Colors.blueAccent,
                                                                                  fontFamily: 'Raleway',
                                                                                  fontWeight: FontWeight.bold
                                                                              ),
                                                                              decoration: InputDecoration(
                                                                                  errorMaxLines: 2,
                                                                                  errorStyle: GoogleFonts.balooBhaina(color: deepRed),
                                                                                  hintStyle: TextStyle(color: Colors.black38),
                                                                                  contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                                                                  border: InputBorder.none,
                                                                                  hintText: 'Request from Email'
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Icon(Icons.alternate_email),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:50.0),
                                                                    child: Material(
                                                                      elevation: 12.0,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Container(
                                                                            width:MediaQuery.of(context).size.width*0.55,
                                                                            child: TextFormField(
                                                                              validator: (value){
                                                                                if(value==""||value==null){
                                                                                  return "Please enter Something";
                                                                                }
                                                                                else{
                                                                                  return null;
                                                                                }
                                                                              },
                                                                              onChanged: (v)=>_addMoneyFormKey.currentState.validate(),
                                                                              controller: _reqPurposeController,
                                                                              cursorColor: Colors.blueAccent,
                                                                              style: TextStyle(
                                                                                  fontSize: 22.0,
                                                                                  color: Colors.blueAccent,
                                                                                  fontFamily: 'Raleway',
                                                                                  fontWeight: FontWeight.bold
                                                                              ),
                                                                              maxLines: 3,
                                                                              decoration: InputDecoration(
                                                                                  errorMaxLines: 2,
                                                                                  errorStyle: GoogleFonts.balooBhaina(color:deepRed),
                                                                                  hintStyle: TextStyle(color: Colors.black38,fontSize: 16),
                                                                                  contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                                                                  border: InputBorder.none,
                                                                                  hintText: 'Purpose'
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Icon(Icons.textsms,),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        processing=true;
                                                      });
                                                      if(_requestMoneyFormKey.currentState.validate()){
                                                        Firestore.instance.collection("users").document(widget.email).get().then((doc){
                                                          if(doc.exists){
                                                            Firestore.instance.collection("walletRequests").document("${_reqEmailController.text}").collection("requests").add({
                                                              "amount":int.parse(_reqAmountController.text),
                                                              "fromEmail":doc.data['email'],
                                                              "purpose":_reqPurposeController.text,
                                                              "fromName":doc.data['name'],
                                                              "fromImg":doc.data['photoURL'],
                                                              "receivedOn":DateTime.now().toIso8601String(),
                                                            }).then((doc){
                                                              Firestore.instance.collection("walletRequests").document("${_reqEmailController.text}").collection("requests").document(doc.documentID).updateData({
                                                                "reqId":doc.documentID,
                                                              }).then((value){
                                                                Navigator.pop(context);
                                                              });
                                                            });
                                                          }
                                                        });
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
                                                            Text("Send Request",style: GoogleFonts.balooBhaina(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),
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
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                              );
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.red[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Request",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),


                          InkWell(
                            onTap: (){
                              showDialog(context: context,
                                  builder: (context){
                                    return StatefulBuilder(
                                        builder: (context,setState){
                                          return AlertDialog(
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
                                                            child: Form(
                                                              key:_sendMoneyFormKey,
                                                              child: SingleChildScrollView(
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
                                                                                    _sendAmountController.clear();
                                                                                    _sendPurposeController.clear();
                                                                                    _sendEmailController.clear();
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                              ]
                                                                          )
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(5.0),
                                                                        child: Material(
                                                                          elevation: 12.0,
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(12.0))
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                width:MediaQuery.of(context).size.width*0.55,
                                                                                child: TextFormField(
                                                                                  validator: (value){
                                                                                    if(value==""||value==null){
                                                                                      return "Please enter a Amount";
                                                                                    }
                                                                                    else{
                                                                                      return null;
                                                                                    }
                                                                                  },
                                                                                  onChanged: (v){
                                                                                    setState(() {
                                                                                      _sendAmount=v;
                                                                                    });
                                                                                    _sendMoneyFormKey.currentState.validate();},
                                                                                  keyboardType: TextInputType.number,
                                                                                  controller: _sendAmountController,
                                                                                  cursorColor: Colors.blueAccent,
                                                                                  style: TextStyle(
                                                                                      fontSize: 22.0,
                                                                                      color: Colors.blueAccent,
                                                                                      fontFamily: 'Raleway',
                                                                                      fontWeight: FontWeight.bold
                                                                                  ),
                                                                                  decoration: InputDecoration(
                                                                                      errorMaxLines: 2,
                                                                                      errorStyle: GoogleFonts.balooBhaina(color:deepRed),
                                                                                      hintStyle: TextStyle(color: Colors.black38,fontSize: 16),
                                                                                      contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                                                                      border: InputBorder.none,
                                                                                      hintText: 'Amount'
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Icon(CustomIcons.rupee_sign,size: 18,),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(5.0),
                                                                        child: Material(
                                                                          elevation: 12.0,
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(12.0))
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                width:MediaQuery.of(context).size.width*0.55,
                                                                                child: TextFormField(
                                                                                  validator:(String value){
                                                                                    Firestore.instance.collection("users").document(_sendEmail).get().then((value){
                                                                                      if(value.exists){
                                                                                          _sendEmailRegistered=true;
                                                                                      }
                                                                                      else{
                                                                                          _sendEmailRegistered=false;
                                                                                      }
                                                                                    });
                                                                                    Pattern pattern =
                                                                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                                                    RegExp regex = new RegExp(pattern);
                                                                                    if(value==null||value==""){
                                                                                      return "Empty Field";
                                                                                    }
                                                                                    else if (!regex.hasMatch(value)) {
                                                                                      return "Enter a valid email";
                                                                                    }
                                                                                    else if(_sendEmailRegistered==false){
                                                                                      return "Unregistered Email";
                                                                                    }
                                                                                    else {
                                                                                     return null;
                                                                                    }
                                                                                  },
                                                                                  onChanged: (v){
                                                                                    setState(() {
                                                                                      _sendEmail=v;
                                                                                    });
                                                                                    },
                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                  controller: _sendEmailController,
                                                                                  cursorColor: Colors.blueAccent,
                                                                                  style: TextStyle(
                                                                                      color: Colors.blueAccent,
                                                                                      fontFamily: 'Raleway',
                                                                                      fontWeight: FontWeight.bold
                                                                                  ),
                                                                                  decoration: InputDecoration(
                                                                                      errorMaxLines: 2,
                                                                                      errorStyle: GoogleFonts.balooBhaina(color: deepRed),
                                                                                      hintStyle: TextStyle(color: Colors.black38),
                                                                                      contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                                                                      border: InputBorder.none,
                                                                                      hintText: 'Send to Email'
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Icon(Icons.alternate_email),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:50.0),
                                                                        child: Material(
                                                                          elevation: 12.0,
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(12.0))
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                width:MediaQuery.of(context).size.width*0.55,
                                                                                child: TextFormField(
                                                                                  validator: (value){
                                                                                    if(value==""||value==null){
                                                                                      return "Please enter Something";
                                                                                    }
                                                                                    else{
                                                                                      return null;
                                                                                    }
                                                                                  },
                                                                                  onChanged: (v)=>_sendMoneyFormKey.currentState.validate(),
                                                                                  controller: _sendPurposeController,
                                                                                  cursorColor: Colors.blueAccent,
                                                                                  style: TextStyle(
                                                                                      fontSize: 16.0,
                                                                                      color: Colors.blueAccent,
                                                                                      fontFamily: 'Raleway',
                                                                                      fontWeight: FontWeight.bold
                                                                                  ),
                                                                                  maxLines: 3,
                                                                                  decoration: InputDecoration(
                                                                                      errorMaxLines: 2,
                                                                                      errorStyle: GoogleFonts.balooBhaina(color:deepRed),
                                                                                      hintStyle: TextStyle(color: Colors.black38,fontSize: 16),
                                                                                      contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                                                                      border: InputBorder.none,
                                                                                      hintText: 'Purpose'
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Icon(Icons.textsms,),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(16.0),
                                                                        child: Text("Do you confirm Your payment of ₹ ${_sendAmount!=""&&_sendAmount!=null?0+int.parse(_sendAmount):0} to $_sendEmail ?\n",
                                                                          style: GoogleFonts.raleway(fontSize: 18.0,fontWeight: FontWeight.w600),
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
                                                                          if(_sendMoneyFormKey.currentState.validate()){
                                                                            Firestore.instance.collection("users").document(loggedInEmail).get().then((doc){
                                                                              if(doc.exists){
                                                                                if(doc.data['walletBalance']>=int.parse(_sendAmountController.text)){
                                                                                  Firestore.instance.collection("users").document(loggedInEmail).updateData({
                                                                                    "walletBalance":doc.data['walletBalance']-int.parse(_sendAmountController.text),
                                                                                  }).then((value){
                                                                                    Firestore.instance.collection("users").document(_sendEmailController.text).get().then((document){
                                                                                      if(document.exists){
                                                                                        Firestore.instance.collection("users").document(_sendEmailController.text).updateData({
                                                                                          "walletBalance":document.data['walletBalance']+int.parse(_sendAmountController.text),
                                                                                        }).then((v){

                                                                                          Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").add({
                                                                                            "amount": int.parse(_sendAmountController.text),
                                                                                            "fromName":doc.data['name'],
                                                                                            "toName":document.data['name'],
                                                                                            "fromEmail":doc.data['email'],
                                                                                            "toEmail":document.data['email'],
                                                                                            "time":DateTime.now().toIso8601String(),
                                                                                          }).then((value) {
                                                                                            Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").document(value.documentID).updateData(
                                                                                                {
                                                                                                  "transactionId": value.documentID,
                                                                                                });
                                                                                            Firestore.instance.collection("walletTransactions").document(_sendEmailController.text.trim()).collection("transactions").document(value.documentID).setData({
                                                                                              "amount": int.parse(_sendAmountController.text),
                                                                                              "fromName":doc.data['name'],
                                                                                              "toName":document.data['name'],
                                                                                              "fromEmail":doc.data['email'],
                                                                                              "toEmail":document.data['email'],
                                                                                              "time":DateTime.now().toIso8601String(),
                                                                                              "transactionId": value.documentID,
                                                                                            });
                                                                                          }
                                                                                          );


                                                                                          setState(() {
                                                                                            processing=false;
                                                                                          });
                                                                                          Navigator.pop(context);
                                                                                          Flushbar(
                                                                                            flushbarPosition: FlushbarPosition.TOP,
                                                                                            shouldIconPulse: true,
                                                                                            isDismissible: true,
                                                                                            titleText: Text("Payment Successful",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                                                                            messageText: Text("${int.parse(_sendAmountController.text)} has been deducted from your Osho Wallet",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                                            duration: Duration(seconds: 3),
                                                                                            icon: Icon(Icons.check_circle,color: Colors.white,),
                                                                                            backgroundColor:  Colors.green,
                                                                                          )..show(context).then((value){
                                                                                            _sendAmountController.clear();
                                                                                            _sendPurposeController.clear();
                                                                                            _sendEmailController.clear();
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
                                                                                    messageText: Text("Insufficient Balance in Osho Wallet.Please Add money to your Osho Wallet for InApp Transactions.",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                                                                    duration: Duration(seconds: 3),
                                                                                    icon: Icon(Icons.close,color: Colors.white,),
                                                                                    backgroundColor:  deepRed,
                                                                                  )..show(context).then((value){
                                                                                    setState(() {
                                                                                      processing=false;
                                                                                    });
                                                                                    _sendAmountController.clear();
                                                                                    _sendPurposeController.clear();
                                                                                    _sendEmailController.clear();
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                }
                                                                              }
                                                                            });
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
                                                                ),
                                                              ),
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ));});});
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                    child: Icon(
                                      Icons.attach_money,
                                      color: Colors.red[900],
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Send Money",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                         /* Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: Colors.red[900],
                                    size: 30,
                                  ),
                                  padding: EdgeInsets.all(12),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Passbook",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          )*/
                        ],
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:40.0),
                  child: DraggableScrollableSheet(
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(243, 245, 248, 1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 24,
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.history),
                                    ),
                                    Text(
                                      "Transactions",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 24,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 32),
                              ),
                              SizedBox(
                                height: 24,
                              ),

                              //Container for buttons
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 32),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Income",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                color: Colors.grey[900]),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[200],
                                                blurRadius: 10.0,
                                                spreadRadius: 4.5)
                                          ]),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.orange,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Expenses",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                color: Colors.grey[900]),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[200],
                                                blurRadius: 10.0,
                                                spreadRadius: 4.5)
                                          ]),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 16,
                              ),
                              //Container Listview for expenses and incomes
                              Container(
                                child: Text(
                                  "All",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[500]),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 32),
                              ),

                              SizedBox(
                                height: 16,
                              ),

                              StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance.collection("walletTransactions").document(loggedInEmail).collection("transactions").orderBy('time',descending: true).snapshots(),
                                builder: (context, snapshot) {
                                  return !snapshot.hasData?Center(
                                    child: Container(
                                      width: 27.0,
                                      height: 27.0,
                                      child: Center(child: CircularProgressIndicator(strokeWidth: 2,backgroundColor: Colors.white,)),
                                    ),
                                  ):snapshot.data.documents.length==0?Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text("No Recent Transactions"
                                      , style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ):ListView.builder(
                                    itemBuilder: (context, index) {
                                      return TransactionCard(snapshot.data.documents.elementAt(index).data['amount'],
                                          DateTime.parse(snapshot.data.documents.elementAt(index).data['time']),
                                          snapshot.data.documents.elementAt(index).data['fromName'],
                                          snapshot.data.documents.elementAt(index).data['toName'],
                                          snapshot.data.documents.elementAt(index).data['fromEmail'],
                                          snapshot.data.documents.elementAt(index).data['fromName']);
                                    },
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    padding: EdgeInsets.all(0),
                                    controller: ScrollController(keepScrollOffset: false),
                                  );
                                }
                              ),

                              //now expense
                            ],
                          ),
                          controller: scrollController,
                        ),
                      );
                    },
                    initialChildSize: 0.65,
                    minChildSize: 0.65,
                    maxChildSize: 1,
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}

class TransactionCard extends StatefulWidget {
  final int amount;
  final DateTime time;
  final String fromName,toName,fromEmail,toEmail;
  TransactionCard(this.amount, this.time, this.fromName, this.toName, this.fromEmail, this.toEmail);
  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(
                    Radius.circular(18))),
            child: Icon(
              Icons.date_range,
              color: Colors.red[900],
            ),
            padding: EdgeInsets.all(12),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Payment",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900]),
                ),
                Text(
                  widget.fromEmail!=loggedInEmail?"Payment from\n${widget.fromName}":"Payment to\n${widget.toName}",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                widget.fromEmail!=loggedInEmail?"+₹ ${widget.amount}":"-₹ ${widget.amount}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color:  widget.fromEmail!=loggedInEmail?Colors.lightGreen:Colors.orange),
              ),
              Text(
                "${widget.time.day} ${month(widget.time.month)}",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
