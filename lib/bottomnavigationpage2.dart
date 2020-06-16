import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                        style: GoogleFonts.aBeeZee(
                            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30.0),
                      ),
                      Text(
                        "History",
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

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(2.5),
                   child: Row(
                     children: <Widget>[
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal:8.0),
                         child: Icon(Icons.hourglass_full,color:Colors.blue),
                       ),
                       Text("Waiting for Approval",style: GoogleFonts.aBeeZee(fontSize: 18),),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(2.5),
                   child: Row(
                     children: <Widget>[
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal:8.0),
                         child: Icon(Icons.check_circle,color:Colors.green),
                       ),
                       Text("Accepted",style: GoogleFonts.aBeeZee(fontSize: 18),),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(2.5),
                   child: Row(
                     children: <Widget>[
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal:8.0),
                         child: Icon(Icons.cancel,color:deepRed),
                       ),
                       Text("Rejected",style: GoogleFonts.aBeeZee(fontSize: 18),),
                     ],
                   ),
                 )
               ],
             ),
           ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("bookings").orderBy('bookedAt',descending: true).snapshots(),
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
                        snapshot.data.documents.elementAt(i).data['status'],
                       ));
                  }
                bookings.sort((a,b){ return b.placedOn.compareTo(a.placedOn);});
                }
                return snapshot.hasData?SingleChildScrollView(
                  child: Column(
                    children: bookings,
                  ),
                ):Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(child: Container(width: 27,height: 27,child: CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 2,))),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatefulWidget {
  final String bookingId,eventName,userEmail,status;
  final int total;
  final Timestamp placedOn;
  final List<Map<String, dynamic>> persons;
  BookingCard(this.bookingId,this.userEmail,this.eventName,this.total,this.persons,this.placedOn, this.status);
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
            color: widget.status=="Accepted"?Colors.green:widget.status=="Rejected"?deepRed:Colors.blueAccent,
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

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width*0.911,
              height: 40,
              decoration: BoxDecoration(
                color: widget.status=="Accepted"?Colors.green:widget.status=="Rejected"?deepRed:Colors.blueAccent,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.status=="Accepted"?Padding(
                      padding: const EdgeInsets.symmetric(horizontal:5.0),
                      child: Icon(Icons.check_circle,color: Colors.white,),
                    ):widget.status=="Rejected"?Padding(
                      padding: const EdgeInsets.symmetric(horizontal:5.0),
                      child: Icon(Icons.cancel,color: Colors.white,),
                    ):Padding(
                      padding: const EdgeInsets.symmetric(horizontal:5.0),
                      child: Icon(Icons.hourglass_full,color: Colors.white,),
                    ),
                    Text(widget.status=="Accepted"?"Accepted":widget.status=="Rejected"?"Rejected":"Waiting for Approval"
                    ,style:GoogleFonts.balooBhaina(fontSize: 18,color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          )

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


