

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/widgets/custom_icons_icons.dart';

import 'aeoui.dart';
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
        body: SingleChildScrollView(
          child: Column(
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
                      ongoingEvents.add(OngoingEventCard(snapshot.data.documents.elementAt(i).data['title']
                          ,snapshot.data.documents.elementAt(i).data['imageUrl'],
                          snapshot.data.documents.elementAt(i).data['description'],
                          snapshot.data.documents.elementAt(i).data['location']
                      ));
                    }
                  }
                  return snapshot.hasData ?Column(
                    children: ongoingEvents,
                  ):
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Container(width: 27,height: 27,child: CircularProgressIndicator(strokeWidth: 2,backgroundColor: Colors.white,)),
                  );
                },
              ),
            ],
          ),
        ));
  }
}


class OngoingEventCard extends StatefulWidget {
  final String imageUrl,title,description,location;
  OngoingEventCard(this.title,this.imageUrl, this.description, this.location);
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
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Column(
          children: <Widget>[
            Stack(
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
                      borderRadius: BorderRadius.only(topRight:Radius.circular(12.0),topLeft:Radius.circular(12.0)),
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
                Positioned(
                  top:8.0,
                  left: MediaQuery.of(context).size.width*0.48,
                  child: RaisedButton(
                    elevation: 12.0,
                    color: deepRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HotelDetailsPage(eventName: widget.title,)));
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(CustomIcons.hotel,size: 16,color: Colors.white,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Register",style: GoogleFonts.balooBhai(fontSize:16.0,color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading:Icon(Icons.event),
                        title:Text("Description",  style: GoogleFonts.balooBhai(fontSize: 18),),
                        subtitle: Text("${widget.description}",
                          style: GoogleFonts.raleway(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading:Icon(Icons.location_on),
                        title:Text("Location",  style: GoogleFonts.balooBhai(fontSize: 18),),
                        subtitle: Text("${widget.location}",
                          style: GoogleFonts.raleway(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
