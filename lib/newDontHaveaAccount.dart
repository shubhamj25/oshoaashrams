import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:rooms/constant/constant.dart';
import 'aeoui.dart';


String apiKey="Nzg1MDYjIyMyMDE4LTA2LTA2IDE2OjUzOjQ1";
Map<String, dynamic> emailData = {
  "subject":"Account Registration details",
  "from":"support@juvlon.com",
  "body":null,
  "to":null,
};

class NewSinup extends StatefulWidget {
  String message;
  NewSinup({this.message});
  @override
  _NewSinupState createState() => _NewSinupState();
}

class _NewSinupState extends State<NewSinup> {
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  final _nameController=TextEditingController();
  final _phoneController=TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey<ScaffoldState>();
  bool hidepass=true;
  bool loggingin=false;
  String _linkMessage;
  bool _isCreatingLink = false;
  bool sendingSignUpLink=false;

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      createUser(deepLink.queryParameters['name'],deepLink.queryParameters['phone'],deepLink.queryParameters['email'],deepLink.queryParameters['password'],deepLink.queryParameters['gender']);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context){
            return AeoUI(username: deepLink.queryParameters['email'],currentState: 4,);
          }
      ));
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            createUser(deepLink.queryParameters['name'],deepLink.queryParameters['phone'],deepLink.queryParameters['email'],deepLink.queryParameters['password'],deepLink.queryParameters['gender']);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context){
                  return AeoUI(username: deepLink.queryParameters['email'],currentState: 4,);
                }
            ));
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  void createUser(String name,String phone,String email,String password,String gender) async{
    //final FirebaseAuth auth = FirebaseAuth.instance;
    //FirebaseUser user;
    //user=(await auth.createUserWithEmailAndPassword(email: email, password:password)).user;
    Firestore.instance.collection("users").document(email.toString()).setData({
      "name":name,
      "phone":phone,
      "email":email,
      "gender":gender,
      "password":password,
    });
  }

  Future<String> _createDynamicLink(bool short,String name,String phone,String email,String password,String gender) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://oshoaashrams.page.link',
      link: Uri.parse('https://oshoaashrams.page.link/post?name=$name&phone=$phone&email=$email&password=$password&gender=$gender'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.oshoaashrams',
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
    return _linkMessage;
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
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
  }
  bool emailerror=false;
  bool passworderror=false;
  int  _selectedGender=0;
  String gender;
  List<DropdownMenuItem<int>> genderList = [
    DropdownMenuItem(
      child: new Text('Select Gender',style:TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),),
      value: 0,

    ),
    DropdownMenuItem(
      child: new Text('Male',style:TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),),
      value: 1
    ),
    DropdownMenuItem(
      child: new Text('Female',style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),),
      value: 2,
    ),
    DropdownMenuItem(
      child: new Text('Other',style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),),
      value: 3,
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                child: new DecoratedBox(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                new AssetImage('assets/images/LoginImage.jpeg'),
                            fit: BoxFit.fill))),
              ),

              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 40.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/OshoLogo.png',
                          height: 130.0,
                        ),
                        SizedBox(height: 30.0),
                        //email
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: !emailerror?Color(0xFF6CA8F1):Colors.redAccent,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: 80.0,
                              child: TextFormField(
                                controller: _emailController,
                                onSaved: (String value){
                                  setState(() {
                                    emailData['to']=_emailController.text.trim();
                                  });
                                },
                                validator:(String value){
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  Firestore.instance.collection("users").document("${_emailController.text.trim()}").get().then((doc){
                                    if(doc.exists){
                                      if (!regex.hasMatch(value)){
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                                          content: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal:12.0),
                                                child: Icon(Icons.close,color:Colors.white),
                                              ),
                                              Text("Invalid Email"),
                                            ],
                                          ),
                                        ));
                                        setState(() {
                                          emailerror=true;
                                        });
                                        return "Please enter a valid email";
                                      }
                                      else {
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                                          content: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal:12.0),
                                                child: Icon(Icons.error,color:Colors.white),
                                              ),
                                              Text("Email Already Registered"),
                                            ],
                                          ),
                                        ));
                                        setState(() {
                                          emailerror=true;
                                        });
                                        return "Email Already Registered";
                                      }
                                    }
                                    else{
                                      return null;
                                    }
                                  });
                                  return null;
                                },
                                onChanged: (String val){
                                  setState(() {
                                    emailerror=false;
                                  });
                                },
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Enter your Email',
                                  hintStyle: kHintTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            //password
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: !passworderror?Color(0xFF6CA8F1):Colors.redAccent,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: 80.0,
                              child: TextFormField(
                                controller: _passwordController,
                                validator: (String val){
                                  if(val.length<8){
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:12.0),
                                            child: Icon(Icons.error,color:Colors.white),
                                          ),
                                          Expanded(child: Text("Password must contain atleast 8 characters")),
                                        ],
                                      ),
                                    ));
                                    setState(() {
                                      passworderror=true;
                                    });
                                    return "Password must contain atleast 8 characters";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                obscureText: hidepass,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ),
                                onChanged: (String val){
                                  setState(() {
                                    passworderror=false;
                                  });
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                  errorMaxLines: null,
                                  contentPadding: EdgeInsets.only(top: 14.0,left:14),
                                  prefixIcon: IconButton(icon: Icon(hidepass?Icons.lock:Icons.lock_open,color: Colors.white,),onPressed: (){
                                    setState(() {
                                      if(hidepass==true){
                                        hidepass=false;
                                      }
                                      else if(hidepass==false){
                                        hidepass=true;
                                      }
                                    });
                                  },),
                                  hintText: 'Enter your Password',
                                  hintStyle: kHintTextStyle,
                                ),
                              ),
                            ),

                            SizedBox(height: 10.0),
                            //name
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Color(0xFF6CA8F1),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: 80.0,
                              child: TextFormField(
                                controller: _nameController,
                                validator: (String val){
                                  if(val==null||val==""){
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:12.0),
                                            child: Icon(Icons.error,color:Colors.white),
                                          ),
                                          Expanded(child: Text("Please enter your name")),
                                        ],
                                      ),
                                    ));
                                    return "Please enter your name";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                  errorMaxLines: null,
                                  contentPadding: EdgeInsets.only(top: 14.0,left:14.0),
                                  prefixIcon: Icon(Icons.person,color: Colors.white,),
                                  hintText: 'Name',
                                  hintStyle: kHintTextStyle,
                                ),
                              ),
                            ),

                            SizedBox(height: 10.0),
                            //phone
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Color(0xFF6CA8F1),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: 80.0,
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (String val){
                                  if(val.length!=10){
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:12.0),
                                            child: Icon(Icons.error,color:Colors.white),
                                          ),
                                          Expanded(child: Text("Phone Number must contain 10 digits")),
                                        ],
                                      ),
                                    ));

                                    return "Phone Number must contain 10 digits";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                  errorMaxLines: null,
                                  contentPadding: EdgeInsets.only(top: 14.0,left:14),
                                  prefixIcon: Icon(Icons.phone_android,color: Colors.white,),
                                  hintText: 'Mobile',
                                  hintStyle: kHintTextStyle,
                                ),
                              ),
                            ),

                            SizedBox(height: 10.0),
                            //gender
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Color(0xFF6CA8F1),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: 60.0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    icon: Icon(Icons.arrow_drop_down_circle,color:Colors.white),
                                    dropdownColor: Color(0xFF6CA8F1),
                                    focusColor:Color(0xFF6CA8F1),
                                    hint: new Text('Select Gender'),
                                    items: genderList,
                                    value: _selectedGender,
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
                                    },
                                    isExpanded: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                    ),
                                    underline: null,

                                  ),
                                )
                              ),
                            ),

                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 25.0),
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () async {
                              setState(() {
                                sendingSignUpLink=true;
                              });
                              if(_formKey.currentState.validate()){
                                _formKey.currentState.save();
                                String link;
                                if(!_isCreatingLink){
                                  link=await _createDynamicLink(true,_nameController.text,_phoneController.text.trim(),_emailController.text.trim(),_passwordController.text.trim(),gender);
                                }
                                emailData['body']="Click on the link below to confirm your account\n$link";
                                sendMail();
                                _scaffoldKey.currentState.showSnackBar(SnackBar(backgroundColor: Colors.green,content: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.check_circle,color: Colors.white,),
                                    ),
                                    Text("Confirmation sent to your Email"),
                                  ],
                                ),));
                              }
                              setState(() {
                                sendingSignUpLink=false;
                              });
                              /*
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => NewLoginScreeOne()));
                               */

                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Color.fromRGBO(253, 11, 23, 1),
                            child: Text(
                              'Sign Up',
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
              sendingSignUpLink?LinearProgressIndicator():Container(),
              widget.message!=null?Container(width:MediaQuery.of(context).size.width,height:50.0,color: Colors.blueAccent,child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(Icons.notification_important,color: Colors.white,),
                    ),
                    Expanded(child: Text("${widget.message}",style: TextStyle(color: Colors.white,fontSize:15.0),)),
                  ],
                ),
              ),):Container(),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: IconButton(
                    icon: Icon(Icons.arrow_back,color: Colors.white,),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Constants.LOGIN_PAGE);
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);


sendMail() async{
  var uri = new Uri.http('api2.juvlon.com', '/v4/httpSendMail');
  var data=json.encode({
    "ApiKey":apiKey,
    "requests":[emailData],
  });
  print(data);
  http.Response response = await http.post(uri,
      headers: {
        "Content-Type": "application/json"
      },
      body: data
  );
  print(response);
}