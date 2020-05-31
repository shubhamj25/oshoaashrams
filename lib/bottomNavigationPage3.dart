import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rooms/insideHotelPagefromSaved.dart';
import 'organiserPageNotifications.dart';

List<SavedEventCard> savedEvents=[];
List<String> events=[];
class SavedPage extends StatefulWidget {
  final String email;
  SavedPage({this.email});
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(
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
                      "Saved",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 35.0),
                    ),
                    Text(
                      "Events",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30.0),
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
            stream: Firestore.instance.collection("saved_${widget.email}").snapshots(),
            builder: (context,snapshot){
              savedEvents.clear();
              if(snapshot.hasData){
                for(int i=0;i<snapshot.data.documents.length;i++){
                  savedEvents.add(SavedEventCard(snapshot.data.documents.elementAt(i).data['eventName'],snapshot.data.documents.elementAt(i).data['imageUrl']));
                }
              }
              return !snapshot.hasData?Padding(
                padding: const EdgeInsets.all(32.0),
                child: LinearProgressIndicator(),
              )
                  :
               ListView(
                 shrinkWrap: true,
                 children: savedEvents,
               );
            },
          )

        ],
      ),
    );
  }
}

class SavedEventCard extends StatefulWidget {
  final String imageUrl,title;
  SavedEventCard(this.title,this.imageUrl);
  @override
  _SavedEventCardState createState() => _SavedEventCardState();
}

class _SavedEventCardState extends State<SavedEventCard> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    HotelDetailsPagefromSaved(eventName: widget.title,)));
          },
          child: Column(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fadeInDuration: Duration(milliseconds: 500),
                fadeInCurve: Curves.easeIn,
                imageBuilder: (context, imageProvider) => Container(
                  width:350,
                  height: 175,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
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
