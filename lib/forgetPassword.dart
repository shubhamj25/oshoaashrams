import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/newLoginscreen2.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  //bool _rememberMe = false;
  final _emailController=TextEditingController();
  final _confirmPasswordController=TextEditingController();
  final _newPasswordController=TextEditingController();
  /* Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }*/
  final GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey<ScaffoldState>();
  bool verifying =false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                    child: new DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AdvancedNetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/osho-b6c37.appspot.com/o/login.jpeg?alt=media&token=cffc99ce-ed62-4a83-83ba-f4ada63551f4",
                              useDiskCache: true,
                            ),
                          ),
                        )
                    )
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 70.0,
                    ),
                    child: Form(
                      key:_formKey ,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/OshoLogo.png',
                            height: 130.0,
                          ),
                          SizedBox(height: 30.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: kBoxDecorationStyle,
                                height: 60.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.6,
                                      child: TextFormField(
                                        cursorColor: Colors.white,
                                        keyboardType: TextInputType.emailAddress,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                        ),
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
                                        decoration: InputDecoration(
                                          errorMaxLines: 2,
                                          hintStyle: TextStyle(color: Colors.white),
                                          errorStyle: GoogleFonts.balooBhaina(color: Colors.white),
                                          contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                          border: InputBorder.none,
                                          hintText: 'Enter New Password',
                                        ),
                                        controller: _emailController,
                                      ),
                                    ),
                                    Icon(Icons.alternate_email,color:Colors.white)
                                  ],
                                ),

                              ),

                              SizedBox(height: 10.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: kBoxDecorationStyle,
                                height: 60.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.6,
                                      child: TextFormField(
                                        cursorColor: Colors.white,
                                        keyboardType: TextInputType.emailAddress,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                        ),
                                        validator: (value){
                                          if(value==null||value==""){
                                            return "Password Field Empty";
                                          }
                                          else{
                                            return null;
                                          }
                                        },
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          errorMaxLines: 2,
                                          hintStyle: TextStyle(color: Colors.white),
                                          errorStyle: GoogleFonts.balooBhaina(color: Colors.white),
                                          contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                          border: InputBorder.none,
                                          hintText: 'Enter New Password',
                                        ),
                                        controller: _newPasswordController,
                                      ),
                                    ),
                                    Icon(Icons.lock,color: Colors.white,),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: kBoxDecorationStyle,
                                height: 60.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.6,
                                      child: TextFormField(
                                        cursorColor: Colors.white,
                                        keyboardType: TextInputType.emailAddress,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Raleway',
                                        ),
                                        validator: (value){
                                          if(value==null||value==""){
                                            return "Password Field Empty";
                                          }
                                          else if(_newPasswordController.text!=_confirmPasswordController.text){
                                            return "Passwords do not Match";
                                          }
                                          else{
                                            return null;
                                          }
                                        },
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          errorMaxLines: 2,
                                          hintStyle: TextStyle(color: Colors.white),
                                          errorStyle: GoogleFonts.balooBhaina(color: Colors.white),
                                          contentPadding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
                                          border: InputBorder.none,
                                          hintText: 'Confirm New Password',
                                        ),
                                        controller: _confirmPasswordController,
                                      ),
                                    ),
                                    Icon(Icons.lock,color: Colors.white,)
                                  ],
                                ),

                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            width: double.infinity,
                            child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () async {
                                if(_formKey.currentState.validate()){
                                  Firestore.instance.collection("users").document("${_emailController.text.trim()}").get().then((doc) async {
                                    setState(() {
                                      verifying=true;
                                    });
                                    if(doc.exists){
                                      Firestore.instance.collection("users").document(doc.data['email']).updateData({
                                        "password":_confirmPasswordController.text,
                                      }).then((value){
                                        Navigator.of(context).push(new MaterialPageRoute(
                                            builder: (BuildContext context) => NewLoginScreenTwo(message: "Password has been reset Successfully",)));
                                      });
                                     }
                                    else{
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(backgroundColor: Colors.red,content: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(Icons.close,color:Colors.white),
                                          ),
                                          Text("Email not Registered"),
                                        ],
                                      ),));
                                    }
                                  });
                                }
                               },
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Color.fromRGBO(253, 11, 23, 1),
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                verifying?LinearProgressIndicator():Container(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(icon: Icon(Icons.arrow_back,color:Colors.white),
                  onPressed: ()=>Navigator.pop(context),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


final kBoxDecorationStyle = BoxDecoration(
  color: Colors.deepOrangeAccent,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
