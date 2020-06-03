import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:rooms/aeoui.dart';
import 'organiserPageNotifications.dart';


List<BookingCard>bookings=[];

class BookingPage extends StatefulWidget {
  final String email;
  BookingPage({this.email});
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: new Column(
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
                        "Booking",
                        style: TextStyle(
                            color: Color.fromRGBO(253, 11, 23, 1), fontWeight: FontWeight.bold, fontSize: 35.0),
                      ),
                      Text(
                        "History",
                        style: TextStyle(
                            color: Color.fromRGBO(253, 11, 23, 1), fontWeight: FontWeight.bold, fontSize: 30.0),
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
              stream: Firestore.instance.collection("${widget.email}_bookings").snapshots(),
              builder: (context,snapshot){
                bookings.clear();
                if(snapshot.hasData){
                  for(int i=0;i<snapshot.data.documents.length;i++){
                    bookings.add(BookingCard(snapshot.data.documents.elementAt(i).data['bookingId'],
                        snapshot.data.documents.elementAt(i).data['email'],
                        snapshot.data.documents.elementAt(i).data['eventName'],
                        snapshot.data.documents.elementAt(i).data['totalPrice'],
                        List.from(snapshot.data.documents.elementAt(i).data['personDetails']),
                        snapshot.data.documents.elementAt(i).data['bookedAt'],
                       ));
                  }
                bookings.sort((a,b){ return b.placedOn.compareTo(a.placedOn);});
                }
                return snapshot.hasData?SingleChildScrollView(
                  child: Column(
                    children: bookings,
                  ),
                ):Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatefulWidget {
  final String bookingId,eventName,userEmail;
  final int total;
  final Timestamp placedOn;
  final List<Map<String, dynamic>> persons;
  BookingCard(this.bookingId,this.userEmail,this.eventName,this.total,this.persons,this.placedOn);
  @override
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  List<PeopleCard>peeps=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i=0;i<widget.persons.length;i++){
      peeps.add(PeopleCard(widget.persons.elementAt(i)['name'],widget.persons.elementAt(i)['email'],widget.persons.elementAt(i)['age'], widget.persons.elementAt(i)['gender']));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: GroovinExpansionTile(
        defaultTrailingIconColor: Colors.white,
        initiallyExpanded: false,
        boxDecoration: BoxDecoration(
            color: deepRed,
            borderRadius: BorderRadius.only(topRight: Radius.circular(16.0),bottomLeft: Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  spreadRadius: 2.0,
                  offset: Offset(2.0, 2.0)
              )
            ]
        ),
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${widget.eventName}", style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: MediaQuery
                  .of(context)
                  .size
                  .width * 0.05),),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
            child: Card(
              elevation: 12.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text("Booking Id", style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .width * 0.045))),

                        Expanded(child: Text("${widget.bookingId}",
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.045))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 1.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text("EventName", style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .width * 0.045))),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${widget.eventName}", style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.045)),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text("Placed On:", style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .width * 0.045))),
                        Expanded(child: Text("${widget.placedOn
                            .toDate()
                            .day}/${widget.placedOn
                            .toDate()
                            .month}/${widget.placedOn
                            .toDate()
                            .year} at ${widget.placedOn
                            .toDate()
                            .hour}:${widget.placedOn
                            .toDate()
                            .minute} hrs", style: TextStyle(color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .width * 0.045))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: Column(
              children:peeps,
            ),
          ),
        ],
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("id :${widget.bookingId}",
                style: TextStyle(fontSize: MediaQuery
                    .of(context)
                    .size
                    .width * 0.048, color: Colors.white,fontWeight: FontWeight.w500),),
              Text("Grand Total: Rs ${widget.total}",
                style: TextStyle(fontSize: MediaQuery
                    .of(context)
                    .size
                    .width * 0.048, color: Colors.white,fontWeight: FontWeight.w500),),
              Text("Persons: ${widget.persons.length}",
                style: TextStyle(fontSize: MediaQuery
                    .of(context)
                    .size
                    .width * 0.048,color:Colors.white,fontWeight: FontWeight.w600),),


            ],
          ),
        ),
      ),
    );
  }
}

class PeopleCard extends StatefulWidget {
  final String name,email,gender,age;
  PeopleCard(this.name,this.email,this.age,this.gender);
  @override
  _PeopleCardState createState() => _PeopleCardState();
}

class _PeopleCardState extends State<PeopleCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          elevation: 10.0,
          child:
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.contacts,size: 20.0,color: Colors.blueAccent,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.0),),
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 85,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Text("Name:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0)),
                        ),
                      ),
                      Expanded(
                        child: Text(widget.name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0)),
                      )
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Container(
                        width: 85,
                        child: Text("Email:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0)),
                      ),
                      Expanded(
                        child: Text(widget.email,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0)),
                      )
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Container(
                        width: 85,
                        child: Text("Gender:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0)),
                      ),
                      Expanded(
                        child: Text(widget.gender,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0)),
                      )
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Container(
                        width: 85.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Text("Age:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0)),
                        ),
                      ),
                      Expanded(
                        child: Text(widget.age,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}


