import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rooms/newLoginscreen2.dart';
import 'package:video_player/video_player.dart';



class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  // Future<void> _initialVideoPlayer;
  VideoPlayerController _controller;
  Timer timer;
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    // _initialVideoPlayer = _controller.initialize();
    _controller = VideoPlayerController.asset('assets/images/1080p.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(false);
          _controller.setVolume(0.0);
        });
      });

    Timer(
        Duration(seconds: 6),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => NewLoginScreenTwo())));
  }

//  Future<Timer> startTime() async {
//    var _duration = new Duration(seconds: 3);
//    return new Timer(_duration, navigationPage);
//  }
//
//  void navigationPage() {
//    Navigator.of(context).pushReplacementNamed(Constants.LOGIN_PAGE);
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    animationController = new AnimationController(
//        vsync: this, duration: new Duration(seconds: 8));
//    animation =
//        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
//
//    animation.addListener(() => this.setState(() {}));
//    animationController.forward();
//
//    setState(() {
//      _visible = !_visible;
//    });
//    startTime();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
//      backgroundColor: Colors.red,
//      body: Stack(
//        fit: StackFit.expand,
//        children: <Widget>[
//          new Column(
//            mainAxisAlignment: MainAxisAlignment.end,
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
////              Padding(
////                  padding: EdgeInsets.only(bottom: 30.0),
////                  child: new Image.asset(
////                    'assets/images/powered_by.jpg',
////                    height: 25.0,
////                    fit: BoxFit.scaleDown,
////                  ))
//            ],
//          ),
//          new Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              new Image.asset(
//                'assets/images/OshoLogo.png',
//                width: animation.value * 1600,
//                height: animation.value * 1600,
//              ),
//            ],
//          ),
//        ],
//      ),
    );
  }
}
