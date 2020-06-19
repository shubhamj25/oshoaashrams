import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/bookEvent.dart';
import 'package:rooms/widgets/custom_icons_icons.dart';
import 'aeoui.dart';

class HotelDetailsPagefromSaved extends StatefulWidget {
  final String eventName;
  HotelDetailsPagefromSaved({this.eventName});
  @override
  _HotelDetailsPagefromSavedState createState() => _HotelDetailsPagefromSavedState();
}

class _HotelDetailsPagefromSavedState extends State<HotelDetailsPagefromSaved> {
  List<Icon> starRating=[];
  bool favourite=false;
  bool verifying=false;
  final GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: StreamBuilder(
            stream: Firestore.instance.collection("events").document(widget.eventName).snapshots(),
            builder: (context, snapshot) {
              starRating.clear();
              if(snapshot.hasData){
                Firestore.instance.collection("savedEvents").document(loggedInEmail).collection("saved").document(snapshot.data['title'].toString()).get().then((doc){
                    if(doc.exists){
                      setState(() {
                        favourite=true;
                      });
                    }
                    else{
                      setState(() {
                        favourite=false;
                      });
                    }
                });
                double rating=snapshot.data['rating'];
                int actualRating=rating.round();
                for(int i=0;i<actualRating;i++){
                  starRating.add(Icon(
                    Icons.star,
                    color: Colors.red,
                  ),);
                }
                for(int j=actualRating;j<5;j++){
                  starRating.add(Icon(
                    Icons.star_border,
                    color: Colors.red,
                  ),);
                }
              }
              return !snapshot.hasData?Center(child: CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 2,)):Stack(
                children: <Widget>[

                  /*Container(
                    foregroundDecoration: BoxDecoration(color: Colors.black26),
                    height: 400,
                    child: Image.asset(image, fit: BoxFit.cover)),*/

                  CachedNetworkImage(
                    imageUrl: snapshot.data['imageUrl'],
                    fadeInDuration: Duration(milliseconds: 500),
                    fadeInCurve: Curves.easeIn,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(Colors.black26,BlendMode.darken),
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => LinearProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),

                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                              elevation: 12.0,
                              child:  Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.favorite,color: deepRed,),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Interested",style: GoogleFonts.balooBhai(fontSize:18),),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: Firestore.instance.collection("events").document(snapshot.data['title']).snapshots(),
                                      builder: (context, snap) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top:30.0,left:55.0),
                                          child: AnimatedCount(count: !snap.hasData?0:snap.data['interested'], duration:  Duration(seconds: 4)),
                                        );
                                      }
                                  )

                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            snapshot.data['title'],
                            style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 16.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Text(
                                "${List.from(snapshot.data['reviews']).length} reviews",
                                style: TextStyle(color: Colors.white, fontSize: 13.0),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                  backgroundColor: !favourite?Colors.grey:Colors.white,
                                  child: Icon(Icons.favorite,color: !favourite?Colors.white:Colors.red,),
                                  heroTag: 3,
                                  onPressed: ()=>null
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children:starRating,
                                        ),
                                        Text.rich(
                                          TextSpan(children: [
                                            WidgetSpan(
                                                child: Icon(
                                                  Icons.location_on,
                                                  size: 16.0,
                                                  color: Colors.grey,
                                                )),
                                            TextSpan(text: snapshot.data['location'])
                                          ]),
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "₹ ${snapshot.data['price']}",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      Text(
                                        "/per night",
                                        style: TextStyle(
                                            fontSize: 12.0, color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 30.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0)),
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    textColor: Colors.white,
                                    child: Text(
                                      "Book",
                                      style: TextStyle(fontWeight: FontWeight.normal),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 32.0,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        verifying=true;
                                      });
                                      Firestore.instance.collection("users").document(loggedInEmail).get().then((doc){
                                        if((doc.data['name']!=null&&doc.data['name']!="")&&(doc.data['email']!=null&&doc.data['email']!="")&&(doc.data['gender']!=null&&doc.data['gender']!="")&&(doc.data['age']!=null&&doc.data['age']!="")){
                                          Navigator.push(context, MaterialPageRoute(builder: (context){
                                            return BookEvent(eventName: snapshot.data['title'],userEmail: loggedInEmail,eventPrice: snapshot.data['price'],ashramEmail: snapshot.data['email'],ashramName: snapshot.data['ashram'],);
                                          }));
                                        }
                                        else{
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal:5.0),
                                                  child: Icon(Icons.error,color: Colors.white,),
                                                ),
                                                Expanded(
                                                  child: Text("Complete your profile first from the dashboard",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Color.fromRGBO(253, 11, 23, 1),
                                          ));
                                        }
                                        setState(() {
                                          verifying=false;
                                        });
                                      });
                                    },
                                  ),
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0)),
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    textColor: Colors.white,
                                    child: Text(
                                      !favourite?"Interested":"Remove Saved",
                                      style: TextStyle(fontWeight: FontWeight.normal),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 32.0,
                                    ),
                                    onPressed: () {
                                      !favourite?Firestore.instance.collection("savedEvents").document(loggedInEmail).collection("saved").document(snapshot.data['title'])
                                          .setData({
                                        "eventName":snapshot.data['title'],
                                        "imageUrl":snapshot.data['imageUrl'],
                                        "description":snapshot.data['description'],
                                        "location":snapshot.data['location'],
                                        "email":snapshot.data['email'],
                                        "ashram":snapshot.data['ashram'],
                                        "start":snapshot.data['start'],
                                        "end":snapshot.data['end'],
                                      }).then((value){
                                        Firestore.instance.collection("events").document(snapshot.data['title'].toString()).updateData({
                                          "interested":snapshot.data['interested']+1,
                                        });
                                      })

                                          :
                                      Firestore.instance.collection("savedEvents").document(loggedInEmail).collection("saved").document(snapshot.data['title']).delete().then((value){
                                        Firestore.instance.collection("events").document(snapshot.data['title'].toString()).updateData({
                                          "interested":snapshot.data['interested']-1,
                                        });
                                      });
                                      !favourite?_scaffoldKey.currentState.showSnackBar(SnackBar(
                                          content: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal:5.0),
                                                child: Icon(Icons.favorite,color: Colors.white,),
                                              ),
                                              Text("Added to Saved",
                                                style: GoogleFonts.balooBhaina(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.green),
                                      )
                                          :_scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:5.0),
                                              child: Icon(Icons.delete,color: Colors.white,),
                                            ),
                                            Text("Removed from Saved",
                                              style: GoogleFonts.balooBhaina(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Color.fromRGBO(253, 11, 23, 1),
                                      ));

                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.0,),
                              const SizedBox(height: 30.0),
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,fontFamily: 'Raleway', fontSize: 22.0),
                              ),
                              const SizedBox(height: 10.0),
                              Text("${snapshot.data['description']}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w200,fontFamily: 'Raleway', fontSize: 18.0),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 8),
                                      child: Icon(Icons.event_available,color:Colors.green,size: 30,),
                                    ),
                                    Text(
                                      "Start\n${snapshot.data['start']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,fontFamily: 'Raleway', fontSize: 16.0),
                                    ),
                                  ],
                                ),

                              ),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 8),
                                      child: Icon(Icons.event_busy,color:deepRed,size: 30,),
                                    ),
                                    Text(
                                      "End\n${snapshot.data['end']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,fontFamily: 'Raleway', fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(CustomIcons.place_of_worship,color:deepRed,size: 20,),
                                  ),
                                  Text("${snapshot.data['ashram']}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,fontFamily: 'Raleway', fontSize: 18.0),
                                  ),
                                ],
                              ),

                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.location_on,color: Colors.blueAccent,),
                                  ),
                                  Text("${snapshot.data['location']}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,fontFamily: 'Raleway', fontSize: 18.0),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                elevation: 8,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:16,vertical:8.0),
                                          child: Text("Reviews (${List.from(snapshot.data['reviews']).length-1})",style: GoogleFonts.balooBhaina(fontSize:18,color:Colors.black54),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:16,vertical:8.0),
                                          child: Icon(Icons.rate_review,color: Colors.blueAccent,size: 30,),
                                        ),
                                      ],
                                    ),
                                    List.from(snapshot.data['reviews']).length!=1?Scrollbar(
                                      isAlwaysShown: true,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight:300,
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: List.from(snapshot.data['reviews']).length,
                                            itemBuilder: (context,index){
                                              return List.from(snapshot.data['reviews']).reversed.elementAt(index).toString()!=""?
                                              ListTile(
                                                contentPadding: const EdgeInsets.all(0),
                                                trailing:Icon(Icons.account_circle,color: Colors.blueGrey,),
                                                title:Text("${List.from(snapshot.data['reviews']).reversed.elementAt(index).toString()}",
                                                  style: GoogleFonts.aBeeZee(fontSize:16),
                                                ),
                                              ):Container();
                                            },
                                          ),
                                        ),
                                      ),
                                    ):Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text("No reviews yet",style: GoogleFonts.balooBhai(fontSize: 16,color: Colors.grey),),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      title: Text(
                        "",
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  verifying?LinearProgressIndicator():Container()
                ],
              );
            }
        ),
      ),
    );
  }
}

class AnimatedCount extends ImplicitlyAnimatedWidget {
  final int count;

  AnimatedCount({
    Key key,
    @required this.count,
    @required Duration duration,
    Curve curve = Curves.linear
  }) : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween _count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text(_count.evaluate(animation).toString(),style:GoogleFonts.aBeeZee(fontSize: 16),textAlign: TextAlign.center,),
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _count = visitor(_count, widget.count, (dynamic value) => new IntTween(begin: value));
  }
}