import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rooms/splashscreen.dart';
import 'aeoui.dart';
import 'constant/constant.dart';
import 'newLoginscreen2.dart';

Future<void> main() async{
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseApp.configure(
      name:'osho-aashrams',
      options: Platform.isAndroid
          ?const FirebaseOptions(
          googleAppID: '1:140743109004:android:6bda2beb830f01c5c3cea9',
          apiKey: "AIzaSyCYyJga1N4I3LvFABlysP60jkN3ckcReZc",
          databaseURL: "https://osho-b6c37.firebaseio.com/"
      ):null);
  runApp(MaterialApp(
    title: 'OSHO ',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    routes: <String, WidgetBuilder>{
      Constants.SPLASH_SCREEN: (BuildContext context) =>
          AnimatedSplashScreen(),
      Constants.LOGIN_PAGE: (BuildContext context) => NewLoginScreenTwo(),
      Constants.AEO_UI: (BuildContext context) => AeoUI(),
    },
    initialRoute: Constants.SPLASH_SCREEN,
  ));
}
