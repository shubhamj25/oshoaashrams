import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rooms/constant/constant.dart';
import 'package:rooms/forgetPassword.dart';
import 'package:rooms/newDontHaveaAccount.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rooms/userProfilePafe.dart';
import 'aeoui.dart';
import 'package:http/http.dart'as http;


class NewLoginScreenTwo extends StatefulWidget {
  String message;
  NewLoginScreenTwo({this.message});
  @override
  _NewLoginScreenTwoState createState() => _NewLoginScreenTwoState();
}

class _NewLoginScreenTwoState extends State<NewLoginScreenTwo> {




bool userexists=false;
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
      createUser(deepLink.queryParameters['name'],deepLink.queryParameters['mobile'],deepLink.queryParameters['email'],deepLink.queryParameters['password'],deepLink.queryParameters['password']);
     _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("SignUp Successful"),));
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            createUser(deepLink.queryParameters['name'],deepLink.queryParameters['mobile'],deepLink.queryParameters['email'],deepLink.queryParameters['password'],deepLink.queryParameters['password']);
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("SignUp Successful"),));
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  void createUser(String name,String mobile,String email,String password,String gender) async{
   // final FirebaseAuth auth = FirebaseAuth.instance;
    //FirebaseUser user;
    //user=(await auth.createUserWithEmailAndPassword(email: email, password:password)).user;
    Firestore.instance.collection("users").document(email.toString()).setData({
      "name":name,
      "mobile":mobile,
      "email":email,
      "gender":gender,
      "password":password,
    });
  }

  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey<ScaffoldState>();
  bool _rememberMe = false;
  bool loggingin=false;
  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.0,
        width: 50.0,
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
  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () async {
              setState(() {
                loggingin=true;
              });
              initiateFacebookLogin();},

            AssetImage(
              'assets/images/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () async {
              setState(() {
                loggingin=true;
              });
              signInWithGoogle().whenComplete(() => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
                return AeoUI(username: email,);
              }) ));
            },
            AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => NewSinup()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
 bool hidepass=false;

  void initiateFacebookLogin() async {
    var facebookLoginResult =
    await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult
                .accessToken.token}&picture?width=500,height=500');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        onLoginStatusChanged(true, profileData: profile);
        break;
    }
  }

  void onLoginStatusChanged(bool isLoggedIn,{Map<String,dynamic> profileData}) {
    setState(() {
      if(isLoggedIn){
        Firestore.instance.collection("users").document("${profileData['email']}").get().then((doc){
          if(doc.exists){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return AeoUI(username: profileData['email'],);
            }));
          }
          else{
            Firestore.instance.collection("users").document("${profileData['email']}").setData({
              "uid":profileData['access_token'],
              "name":profileData['name'],
              "email":profileData['email'],
              "photoURL":profileData['picture'],
              "password":"oshoaashrams"
            },merge: true);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return AeoUI(username: profileData['email'],);
            }));
         /*   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
              children: <Widget>[
                Icon(Icons.warning),
                Text("SignUp First Please",style: TextStyle(color: Colors.white),),
              ],
            ),backgroundColor: Colors.red,));

          */
          }
        });
      }
      loggingin=false;
    });
  }


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
                      vertical: 100.0,
                    ),
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
                              child: TextFormField(
                                controller: _emailController,
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
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle,
                              height: 60.0,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: hidepass,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
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
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => ForgetPassword()));
                            },
                            padding: EdgeInsets.only(right: 0.0),
                            child: Text(
                              'Forgot Password?',
                              style: kLabelStyle,
                            ),
                          ),
                        ),
                        Container(
                          height: 20.0,
                          child: Row(
                            children: <Widget>[
                              Theme(
                                data: ThemeData(unselectedWidgetColor: Colors.white),
                                child: Checkbox(
                                  value: _rememberMe,
                                  checkColor: Colors.green,
                                  activeColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                'Remember me',
                                style: kLabelStyle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 25.0),
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              setState(() {
                                loggingin=true;
                              });
                              Firestore.instance.collection("users").document("${_emailController.text.trim()}").get().then((doc){
                                if(doc.exists){
                                  if(_passwordController.text.trim()==doc.data['password']){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                                      return AeoUI(username: _emailController.text.trim(),);
                                    }));
                                  }else{
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(backgroundColor: Colors.red,content: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(Icons.close,color:Colors.white),
                                        ),
                                        Text("Invalid Credentials"),
                                      ],
                                    ),));
                                  }
                                }
                                else{
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(backgroundColor: Colors.red,content: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(Icons.error,color:Colors.white),
                                      ),
                                      Text("SignUp First Please"),
                                    ],
                                  ),));
                                }
                                setState(() {
                                  loggingin=false;
                                });
                              });
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Color.fromRGBO(253, 11, 23, 1),
                            child: Text(
                              'LOGIN',
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
                        Column(
                          children: <Widget>[
                            Text(
                              '- OR -',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 17.0
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Text(
                              'Sign in with ?',
                              style: TextStyle(fontSize: 18.0,color: Colors.white,fontFamily: 'OpenSans',),
                            ),
                          ],
                        ),
                        _buildSocialBtnRow(),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                ),
                widget.message!=null?Container(width:MediaQuery.of(context).size.width,height:50.0,color: Colors.blueAccent,child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.account_circle,color: Colors.white,),
                      ),
                      Expanded(child: Text("${widget.message}",style: TextStyle(color: Colors.white,fontSize:15.0),)),
                    ],
                  ),
                ),):Container(),
                loggingin?LinearProgressIndicator():Container()
              ],
            ),
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



final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
var facebookLogin = FacebookLogin();
Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  updateUserData(user);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}

String email;
void updateUserData(FirebaseUser user) async {
  email=user.email;
  Firestore.instance.collection("users").document(user.email).get().then((value){
    if(!value.exists){
      DocumentReference ref = Firestore.instance.collection('users').document(user.email);
      return ref.setData({
        'uid': user.uid,
        'email': user.email,
        'phone':user.phoneNumber,
        'photoURL': user.photoUrl,
        'name': user.displayName,
        'lastSeen': DateTime.now(),
        "password":"oshoaashrams"
      }, merge: true);
    }
    else
      {
        return null;
      }
  });

}
