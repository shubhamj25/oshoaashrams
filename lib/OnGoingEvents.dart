import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'insideHotelPage.dart';
import 'organiserPageNotifications.dart';


List<OngoingEventCard> ongoingEvents=[];

class OnGoingEvents extends StatefulWidget {
  @override
  _OnGoingEventsState createState() => _OnGoingEventsState();
}

class _OnGoingEventsState extends State<OnGoingEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Ongoing",
                        style: GoogleFonts.aBeeZee(
                            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30.0),
                      ),
                      Text(
                        "Events",
                        style: GoogleFonts.aBeeZee(
                            color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 25.0),
                      ),
                    ],
                  ),

                  FloatingActionButton(
                    heroTag: 1,
                    backgroundColor: Colors.redAccent,
                    child:Icon(Icons.notifications,color: Colors.white,),
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              OrganiserNotifications()));
                    },
                  )
              ],),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("events").snapshots(),
              builder: (BuildContext context, snapshot){
                ongoingEvents.clear();
                if(snapshot.hasData){
                  for(int i=0;i<snapshot.data.documents.length;i++){
                    ongoingEvents.add(OngoingEventCard(snapshot.data.documents.elementAt(i).data['title'],snapshot.data.documents.elementAt(i).data['imageUrl']));
                  }
                }
                return snapshot.hasData ?SingleChildScrollView(
                  child: Column(
                    
                    children: ongoingEvents,
                  ),
                ):Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: LinearProgressIndicator(),
                );
              },
            ),
          ],
        ));
  }
}


class OngoingEventCard extends StatefulWidget {
  final String imageUrl,title;
  OngoingEventCard(this.title,this.imageUrl);
  @override
  _OngoingEventCardState createState() => _OngoingEventCardState();
}

class _OngoingEventCardState extends State<OngoingEventCard> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 6.0),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    HotelDetailsPage(eventName: widget.title,)));
          },
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fadeInDuration: Duration(milliseconds: 500),
                fadeInCurve: Curves.easeIn,
                imageBuilder: (context, imageProvider) => Container(
                  width:350,
                  height: 175,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(Colors.black26,BlendMode.darken),
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.symmetric(vertical:32.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: 200.0,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.aBeeZee(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
