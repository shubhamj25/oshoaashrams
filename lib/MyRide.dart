import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/addingNewRides.dart';
import 'package:rooms/aeoui.dart';

List<RideCard> rides=[];
List<CurrentRideCard> currentRides=[];
List<RequestCard> requests=[];
List<ChatCard> chats=[];
class MyRide extends StatefulWidget {
  final String userEmail,userName,gender,age,img;
  MyRide({this.userEmail,this.userName,this.gender,this.age,this.img});
  @override
  _MyRideState createState() => _MyRideState();
}

class _MyRideState extends State<MyRide> {
  final searchController=TextEditingController();
  final contactSearchController=TextEditingController();
  String contact="";
  String destination="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                centerTitle: true,
                backgroundColor: deepRed,
                bottom: TabBar(

                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(icon:Icon(Icons.search)),
                    Tab(icon: Icon(Icons.drive_eta)),
                    Tab(icon: Icon(Icons.group_add)),
                    Tab(icon:Icon(Icons.mail))
                  ],
                ),
                title: Text(
                  "My Rides",
                  style: GoogleFonts.balooBhaina(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
              ),
              body: TabBarView(
                children: [
                  //search
                  Scaffold(
                    body: Container(
                      height: MediaQuery.of(context).size.height*0.8,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Material(
                              child: TextFormField(
                                controller: searchController,
                                style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:18.0),
                                onChanged: (String value){
                                  setState(() {
                                    destination=value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Search Destination...",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 32.0,vertical: 14.0),
                                  suffixIcon: InkWell(
                                    child: Icon(Icons.search,color: Colors.black,),
                                    onTap: ()=>null,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection("rides").snapshots(),
                              builder: (context,snapshot){
                                rides.clear();
                                if(snapshot.hasData){
                                  for(int i=0;i<snapshot.data.documents.length;i++){
                                    if(!List.from(snapshot.data.documents.elementAt(i).data['persons']).contains(loggedInEmail)&&
                                        (snapshot.data.documents.elementAt(i).data['travellingTo'].toString().contains(destination)||snapshot.data.documents.elementAt(i).data['travellingTo'].toString().toUpperCase().contains(destination)||snapshot.data.documents.elementAt(i).data['travellingTo'].toString().toLowerCase().contains(destination))
                                    ){
                                      rides.add(RideCard(
                                          snapshot.data.documents.elementAt(i).data['image'],
                                          snapshot.data.documents.elementAt(i).data['email'],
                                          snapshot.data.documents.elementAt(i).data['name'],
                                          snapshot.data.documents.elementAt(i).data['age'],
                                          snapshot.data.documents.elementAt(i).data['travellingTo'],
                                          snapshot.data.documents.elementAt(i).data['travellingFrom'],
                                          snapshot.data.documents.elementAt(i).data['start'],
                                          snapshot.data.documents.elementAt(i).data['end'],
                                          snapshot.data.documents.elementAt(i).data['gender'],
                                          snapshot.data.documents.elementAt(i).data['modeOfTravel'],
                                      ));
                                    }
                                  }
                                }
                                return !snapshot.hasData?Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(100.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                ):
                                rides.isNotEmpty?Column(
                                  children: rides,
                                ):Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(100.0),
                                    child: Text("No Ride Available",style: GoogleFonts.balooBhaina(
                                        color: Colors.black, fontSize: 20.0),
                                    ),
                                  ),
                                )
                                ;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    floatingActionButton:
                    FloatingActionButton(
                      heroTag: 23,
                      backgroundColor: Color.fromRGBO(253, 11, 23, 1),
                      child: Icon(Icons.add,color: Colors.white,),
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => DropDown(userEmail: widget.userEmail,age: widget.age,gender: widget.gender,userName: widget.userName,img: widget.img,)));
                      },
                    ),
                  ),
                  //Current Rides
                  Scaffold(
                    body: Container(
                      height: MediaQuery.of(context).size.height*0.8,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection("rides").snapshots(),
                              builder: (context,snapshot){
                                currentRides.clear();
                                if(snapshot.hasData){
                                  for(int i=0;i<snapshot.data.documents.length;i++){
                                    if(List.from(snapshot.data.documents.elementAt(i).data['persons']).contains(loggedInEmail)){
                                      currentRides.add(CurrentRideCard(
                                          snapshot.data.documents.elementAt(i).data['image'],
                                          snapshot.data.documents.elementAt(i).data['email'],
                                          snapshot.data.documents.elementAt(i).data['name'],
                                          snapshot.data.documents.elementAt(i).data['age'],
                                          snapshot.data.documents.elementAt(i).data['travellingTo'],
                                          snapshot.data.documents.elementAt(i).data['travellingFrom'],
                                          snapshot.data.documents.elementAt(i).data['start'],
                                          snapshot.data.documents.elementAt(i).data['end'],
                                          snapshot.data.documents.elementAt(i).data['gender'],
                                          snapshot.data.documents.elementAt(i).data['modeOfTravel']
                                      ));
                                    }
                                  }
                                }
                                return !snapshot.hasData?Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(100.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                ):
                                currentRides.isNotEmpty?Column(
                                  children: currentRides,
                                ):Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(100.0),
                                    child: Text("No Rides Booked",style: GoogleFonts.balooBhaina(
                                        color: Colors.black, fontSize: 20.0),
                                    ),
                                  ),
                                )
                                ;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    floatingActionButton:
                    FloatingActionButton(
                      heroTag: 23,
                      backgroundColor: Color.fromRGBO(253, 11, 23, 1),
                      child: Icon(Icons.add,color: Colors.white,),
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => DropDown(userEmail: widget.userEmail,age: widget.age,gender: widget.gender,userName: widget.userName,img: widget.img,)));
                      },
                    ),
                  ),
                  //Requests
                  Scaffold(
                    body: Container(
                      height: MediaQuery.of(context).size.height*0.8,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection("rideReq_$loggedInEmail").snapshots(),
                              builder: (context,snapshot){
                                requests.clear();
                                if(snapshot.hasData){
                                  for(int i=0;i<snapshot.data.documents.length;i++){
                                    requests.add(RequestCard(
                                        snapshot.data.documents.elementAt(i).data['image'],
                                        snapshot.data.documents.elementAt(i).data['name'],
                                        snapshot.data.documents.elementAt(i).data['fromEmail'],
                                        snapshot.data.documents.elementAt(i).data['age'],
                                        snapshot.data.documents.elementAt(i).data['gender'],
                                        snapshot.data.documents.elementAt(i).data['rideBy'],
                                    ));
                                  }
                                }
                                return !snapshot.hasData?Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(100.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                ):
                                requests.isNotEmpty?Column(
                                  children: requests,
                                ):Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(100.0),
                                    child: Text("No Ride Requests",style: GoogleFonts.balooBhaina(
                                        color: Colors.black, fontSize: 20.0),
                                    ),
                                  ),
                                )
                                ;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Chats
                  Scaffold(
                    body:Container(
                      height: MediaQuery.of(context).size.height*0.8,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height*0.08,
                              child: Material(
                                child: TextFormField(
                                  controller: searchController,
                                  enableInteractiveSelection: true,
                                  onChanged: (String value){
                                    setState(() {
                                      contact=value;
                                    });
                                  },
                                  style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:18.0),
                                  decoration: InputDecoration(
                                    hintText: "Search Contact...",
                                    contentPadding: EdgeInsets.symmetric(horizontal: 32.0,vertical: 14.0),
                                    suffixIcon: InkWell(
                                      child: Icon(Icons.search,color: Colors.black,),
                                      onTap: ()=>null,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height*0.8,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance.collection("chats_$loggedInEmail").snapshots(),
                                builder: (context, snapshot) {
                                  return !snapshot.hasData?Center(child: CircularProgressIndicator()):
                                  ListView.builder(
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context,i){
                                      if(snapshot.data.documents.elementAt(i).documentID.contains("info")&&(snapshot.data.documents.elementAt(i).data['name'].toString().contains(contact)||snapshot.data.documents.elementAt(i).data['name'].toString().toLowerCase().contains(contact)||snapshot.data.documents.elementAt(i).data['name'].toString().toUpperCase().contains(contact))){
                                        return ChatCard(loggedInEmail,snapshot.data.documents.elementAt(i).data['email'],
                                            snapshot.data.documents.elementAt(i).data['image'],snapshot.data.documents.elementAt(i).data['name'],snapshot.data.documents.elementAt(i).data['mode']);
                                      }
                                      else{
                                        return Container();
                                      }
                                    },
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}

class RideCard extends StatefulWidget {
  final String userEmail,userName,img,travellingTo,travellingFrom,start,end,gender,age,mode;
  RideCard(this.img,this.userEmail,this.userName,this.age,this.travellingTo,this.travellingFrom,this.start,this.end,this.gender, this.mode);
  @override
  _RideCardState createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  bool requestSent=false;
  String status="Request Status";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection("rideReq_${widget.userEmail}").document("from_$loggedInEmail").get().then((doc){
     setState(() {
       if(doc.exists){
           requestSent=true;
       }
       else{
         requestSent=false;
       }
     });
     });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 5.0),
      child: Card(
        color: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all((Radius.circular(12.0))),
        ),
        elevation: 15.0,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    shape: CircleBorder(),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.32,
                      height: MediaQuery.of(context).size.width*0.32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white,width: 3.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.img,
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeInCurve: Curves.easeIn,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.46,
                  height: 100.0,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Interested",style:GoogleFonts.aBeeZee(color:requestSent?Colors.green:Color.fromRGBO(253, 11, 23, 1),fontSize: 16,fontWeight: FontWeight.w600),),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(requestSent?Icons.check_circle:Icons.drive_eta,color:requestSent?Colors.green:Color.fromRGBO(253, 11, 23, 1)),
                            ),
                          ],
                        ),color:Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all((Radius.circular(8.0))),
                        ),
                        onPressed:(){
                          setState(() {
                            setState(() {
                              if(requestSent==false){
                                requestSent=true;
                                List<String> ridePersons=[];
                                Firestore.instance.collection("users").document(loggedInEmail).get().then((doc){
                                  if(doc.exists){
                                    Firestore.instance.collection("rideReq_${widget.userEmail}").document("from_$loggedInEmail").setData({
                                      "fromEmail":doc.data['email'],
                                      "name":doc.data['name'],
                                      "age":doc.data['age'],
                                      "gender":doc.data['gender'],
                                      "image":doc.data['photoURL'],
                                      "persons":ridePersons,
                                      "rideBy":widget.userName,
                                    });
                                  }
                                });
                              }
                              else{
                                setState(() {
                                  status="Canceled";
                                });
                                requestSent=false;
                                Firestore.instance.collection("rideReq_${widget.userEmail}").document("from_$loggedInEmail").delete();
                              }
                            });
                          });
                        },
                      ),
                      RaisedButton(
                        child: Text(requestSent?"Request Sent":status,style:GoogleFonts.aBeeZee(color: !requestSent&&status!="Request Status"?deepRed:Colors.blueAccent,fontSize: 16,fontWeight: FontWeight.w600)),
                        color: Colors.white,
                        onPressed:()=>null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all((Radius.circular(8.0))),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(12.0),bottomRight: Radius.circular(12.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                     title: Text(widget.userName,style: GoogleFonts.aBeeZee(fontSize: 19.0,fontWeight: FontWeight.w600),),
                    subtitle: Text("${widget.userName} is travelling from ${widget.travellingFrom} to ${widget.travellingTo} by ${widget.mode}"
                        " on ${widget.start}.${widget.gender=="Male"?'He':'She'} is ${widget.age} years old and would be staying at ${widget.travellingTo} till ${widget.end}."
                    ,style: GoogleFonts.aBeeZee(
                     fontSize: 17.0,fontWeight: FontWeight.w500,
                    ),
                    ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

class RequestCard extends StatefulWidget {
  final String img,name,email,age,gender,loggedInName;
  RequestCard(this.img,this.name,this.email,this.age,this.gender, this.loggedInName);
  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool reqAccepted=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8.0),
      child: Card(
        color: Colors.lightBlue,
        elevation: 12.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    shape: CircleBorder(),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.25,
                      height: MediaQuery.of(context).size.width*0.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white,width: 3.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.img,
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeInCurve: Curves.easeIn,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.4,
                  height: 100.0,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(reqAccepted?"Accepted":"Accept",style:GoogleFonts.aBeeZee(color:reqAccepted?Colors.white:Colors.green,fontSize: 16,fontWeight: FontWeight.w600),),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(reqAccepted?Icons.check_circle:Icons.drive_eta,color:reqAccepted?Colors.white:Colors.green,
                            ),
                            ),
                          ],
                        ),color:reqAccepted?Colors.green:Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all((Radius.circular(8.0))),
                        ),
                        onPressed:(){
                          setState(() {
                            setState(() {
                              if(reqAccepted==false){
                                Firestore.instance.collection("rides").document(widget.loggedInName).updateData({
                                  "persons":FieldValue.arrayUnion([widget.email]),
                                });
                                reqAccepted=true;
                              }else{
                                reqAccepted=false;
                              }
                              Firestore.instance.collection("rideReq_$loggedInEmail").document("from_${widget.email}").delete();
                            });
                          });
                        },
                      ),
                      RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Reject",style:GoogleFonts.aBeeZee(color: Colors.red,fontSize: 16,fontWeight: FontWeight.w600)),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.close,color: Colors.red),
                            ),
                          ],
                        ),
                        color: Colors.white,
                        onPressed:()=>null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all((Radius.circular(8.0))),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.0),bottomLeft: Radius.circular(12.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text("Ride request from ${widget.email}",style: GoogleFonts.aBeeZee(fontSize: 18,fontWeight: FontWeight.w600),),
                  subtitle: Text("${widget.name} has requested to join your ride ...",style: GoogleFonts.aBeeZee(fontSize: 16,fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CurrentRideCard extends StatefulWidget {
  final String userEmail,userName,img,travellingTo,travellingFrom,start,end,gender,age,mode;
  CurrentRideCard(this.img,this.userEmail,this.userName,this.age,this.travellingTo,this.travellingFrom,this.start,this.end,this.gender, this.mode);
  @override
  _CurrentRideCardState createState() => _CurrentRideCardState();
}

class _CurrentRideCardState extends State<CurrentRideCard> {
  int ridePeeps;
  bool isActive=true;
  bool inTouch=false;
  bool ownRide=false;
  BorderRadius contentBorder=BorderRadius.all(Radius.circular(0));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection("rides").document(widget.userName).get().then((doc){
      setState(() {
        if(doc.data['status']=="active"){
          isActive=true;
        }
        else{
          isActive=false;
        }
      });
    });
    Firestore.instance.collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.userEmail}_info").get().then((doc){
      setState(() {
        if(doc.exists){
          inTouch=true;
        }
        else{
          inTouch=false;
        }
      });
    });
    Firestore.instance.collection("rides").document(widget.userName).get().then((value){
      setState(() {
        if(value.exists){
          if(value.data['email']==loggedInEmail||value.data['status']=="inactive"){
            ownRide=true;
            ridePeeps=List.from(value.data['persons']).length;
          }
          else{
            ownRide=false;
          }
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 5.0),
      child: Card(
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all((Radius.circular(12.0))),
          ),
          elevation: 15.0,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      shape: CircleBorder(),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        height: MediaQuery.of(context).size.width*0.35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white,width: 3.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.img,
                          fadeInDuration: Duration(milliseconds: 500),
                          fadeInCurve: Curves.easeIn,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: 100.0,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        !ownRide?RaisedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(inTouch?"In Touch":"Message",style:GoogleFonts.aBeeZee(color: Colors.blueAccent,fontSize: 16,fontWeight: FontWeight.w600)),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(inTouch?Icons.touch_app:Icons.send,color: Colors.blueAccent),
                              ),
                            ],
                          ),
                          color: Colors.white,
                          onPressed:(){
                            if(inTouch==false){
                              addChat(loggedInEmail,widget.userEmail, widget.userName, widget.img,widget.mode);
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.blueAccent,
                                    content: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                                          child: Icon(Icons.info,color: Colors.white,size: 35,),
                                        ),
                                        Expanded(child: Text("You have a new Chat !\nPlease check your chat list",style: GoogleFonts.aBeeZee(fontSize: 16.0,color: Colors.white),))
                                      ],
                                    ),
                                  )
                              );
                            }
                            else{
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.blueAccent,
                                    content: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                                          child: Icon(Icons.info,color: Colors.white,size: 35,),
                                        ),
                                        Expanded(child: Text("Already in Touch!\nPlease check your chat list",style: GoogleFonts.aBeeZee(fontSize: 16.0,color: Colors.white),))
                                      ],
                                    ),
                                  )
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all((Radius.circular(8.0))),
                          ),
                        ):Container(),
                        RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(isActive?Icons.fiber_manual_record:Icons.stop,color:isActive?Colors.green:Colors.red),
                                ),
                                Text(isActive?"ACTIVE":"ENDED",style:GoogleFonts.aBeeZee(color: isActive?Colors.green:Colors.red,fontSize: 16,fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          color: Colors.white,
                          onPressed:()=>null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all((Radius.circular(8.0))),
                          ),
                        ),
                        ownRide?RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                            child: Text("$ridePeeps People",style:GoogleFonts.aBeeZee(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w600)),
                          ),
                          color: Colors.white,
                          onPressed:()=>null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all((Radius.circular(8.0))),
                          ),
                        ):Container(),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                     borderRadius: contentBorder),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(widget.userName,style: GoogleFonts.aBeeZee(fontSize: 19.0,fontWeight: FontWeight.w600),),
                        subtitle: Text("${widget.userName} is travelling from ${widget.travellingFrom} to ${widget.travellingTo} by ${widget.mode}"
                            " on ${widget.start}.${widget.gender=="Male"?'He':'She'} is ${widget.age} years old and would be staying at ${widget.travellingTo} till ${widget.end}."
                          ,style: GoogleFonts.aBeeZee(
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  isActive?InkWell(
                    child: Container(
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("End Ride",textAlign:TextAlign.center,style:GoogleFonts.aBeeZee(color:Colors.white,fontSize: 20.0,fontWeight: FontWeight.w600)),
                      ),
                      height: 40.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: deepRed,
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(12.0),bottomRight: Radius.circular(12.0)),
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        isActive=false;
                        contentBorder=BorderRadius.only(bottomLeft:Radius.circular(12.0),bottomRight: Radius.circular(12.0));
                        Firestore.instance.collection("rides").document(widget.userName).updateData({
                          "status":"inactive",
                        });
                      });
                    },
                  ):Container()
                ],
              ),
            ],
          )
      ),
    );
  }
}


class ChatCard extends StatefulWidget {
  final String userEmail,chatToEmail,chatToName,chatToImage,modeOfTravel;
  ChatCard(this.userEmail,this.chatToEmail,this.chatToImage,this.chatToName, this.modeOfTravel);
  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final _messageController=TextEditingController();
  Icon travelMode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.modeOfTravel=="Car"){
      setState(() {
        travelMode=Icon(Icons.drive_eta);
      });
    }
    else if(widget.modeOfTravel=="Bus"){
      setState(() {
        travelMode=Icon(Icons.directions_bus);
      });
    }
    else if(widget.modeOfTravel=="Cab"){
      setState(() {
        travelMode=Icon(Icons.local_taxi);
      });
    }
    else if(widget.modeOfTravel=="Self"){
      setState(() {
        travelMode=Icon(Icons.directions_bike);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: Card(
        elevation: 10.0,
        child: ListTile(
          leading:Material(
            shape: CircleBorder(),
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color:deepRed,width: 3.0),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.chatToImage,
                fadeInDuration: Duration(milliseconds: 500),
                fadeInCurve: Curves.easeIn,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          title: Text(widget.chatToName,style: GoogleFonts.aBeeZee(fontSize: 18.0,color:Colors.cyan,fontWeight: FontWeight.w600),),
          subtitle: Text("Osho Customer",style: GoogleFonts.aBeeZee(fontSize: 16.0,fontWeight: FontWeight.w500)),
          trailing: Container(
            width: MediaQuery.of(context).size.width*0.2,
            child: Row(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream:Firestore.instance.collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").snapshots() ,
                  builder: (context, snapshot) {
                    int unseen=0;
                    if(snapshot.hasData){
                      for(int i=0;i<snapshot.data.documents.length;i++){
                        if(snapshot.data.documents.elementAt(i).data['seen']==false&&snapshot.data.documents.elementAt(i).data['accountEmail']==widget.chatToEmail.toString()){
                          unseen++;
                        }
                      }
                    }
                    return unseen!=0?Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: deepRed,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text("$unseen",style: GoogleFonts.aBeeZee(fontSize: 14,color: Colors.white),),
                      ),
                    ):travelMode;
                  }
                ),
                IconButton(icon: Icon(Icons.delete,color: deepRed,),
                onPressed: (){
                  Firestore.instance.collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").delete();
                  Firestore.instance.collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}_info").delete();
                },
                ),
              ],
            ),
          ),
          onTap: (){
            Firestore.instance.collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").getDocuments().then((QuerySnapshot snapshot){
                  for(int i=0;i<snapshot.documents.length;i++){
                    Firestore.instance.collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").document(snapshot.documents.elementAt(i).data['id']).updateData({
                      "seen":true,
                    });
                  }
            });
            Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return Scaffold(
                  appBar: AppBar(
                    title: Text(widget.chatToName,style: GoogleFonts.aBeeZee(color: Colors.white),),
                    backgroundColor: deepRed,
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: ()=>Navigator.pop(context),
                    ),
                  ),

                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").limit(100).orderBy('timestamp', descending: true).snapshots(),
                          builder: (context, snapshot) {
                            return !snapshot.hasData?Center(child: LinearProgressIndicator()):Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  image:DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AdvancedNetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/osho-b6c37.appspot.com/o/chat.jpg?alt=media&token=2890e2bd-c005-46cc-ac11-2443655ed059",
                                      useDiskCache: true,
                                    ),
                                    )
                                ),
                                height: MediaQuery.of(context).size.height*0.8,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(10.0),
                                  itemBuilder: (context, index){
                                    if(snapshot.data.documents.elementAt(index).data['accountEmail']!=loggedInEmail) {
                                      return Chat("${snapshot.data.documents.elementAt(index).data['message']}","peer",DateTime.parse(snapshot.data.documents.elementAt(index).data['timestamp']));
                                    }
                                    else{
                                      return Chat("${snapshot.data.documents.elementAt(index).data['message']}","current",DateTime.parse(snapshot.data.documents.elementAt(index).data['timestamp']));
                                    }
                                  },
                                  itemCount: snapshot.data.documents.length,
                                  reverse: true,
                                  shrinkWrap: true,
                                ),
                              ),
                            );
                          },
                        ),
                        Material(
                          elevation: 20.0,
                          child: TextFormField(
                            controller: _messageController,
                            style: GoogleFonts.aBeeZee(fontSize: MediaQuery.of(context).size.width*0.05,color:Colors.black,fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              labelStyle:GoogleFonts.aBeeZee(fontSize: MediaQuery.of(context).size.width*0.045),
                              labelText: "Type a message",
                              contentPadding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 5.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send,size:25.0,color: Colors.black,),
                                onPressed: (){
                                  Firestore.instance
                                      .collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").add({
                                    "message":_messageController.text,
                                    "accountEmail":loggedInEmail,
                                    'timestamp': DateTime.now().toIso8601String(),
                                    "seen":false,
                                  }).then((value){
                                    setState(() {
                                      Firestore.instance
                                          .collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").document(value.documentID).updateData({
                                        "id":value.documentID,
                                      });
                                      _messageController.clear();
                                    });
                                  });
                                  Firestore.instance
                                      .collection("chats_${widget.chatToEmail}").document("chat_${widget.chatToEmail}with$loggedInEmail").collection("chat").add({
                                    "message":_messageController.text,
                                    "accountEmail":loggedInEmail,
                                    'timestamp': DateTime.now().toIso8601String(),
                                  }).then((value){
                                    setState(() {
                                      Firestore.instance
                                          .collection("chats_${widget.chatToEmail}").document("chat_${widget.chatToEmail}with$loggedInEmail").collection("chat").document(value.documentID).updateData({
                                        "id":value.documentID,
                                        "seen":false,
                                      });
                                      _messageController.clear();
                                    });
                                  });
                                },
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ));
          },
        ),
      ),
    );
  }
}

void addChat(String userEmail,String chatToEmail,String chatToName,String chatToImage,String mode){
  Firestore.instance.collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${chatToEmail}_info").get().then((value){
    if(!value.exists){
      Firestore.instance.collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${chatToEmail}_info").setData({
        "name":chatToName,
        "email":chatToEmail,
        "image":chatToImage,
        "mode":mode
        });
       }
  });
  Firestore.instance.collection("users").document(userEmail).get().then((doc){
    if(doc.exists){
      Firestore.instance.collection("chats_$chatToEmail").document("chat_${chatToEmail}with${loggedInEmail}_info").get().then((value){
        if(!value.exists){
          Firestore.instance.collection("chats_$chatToEmail").document("chat_${chatToEmail}with${loggedInEmail}_info").setData({
            "name":doc.data['name'],
            "email":doc.data['email'],
            "image":doc.data['photoURL'],
            "mode":mode,
          });
        }
      });
    }
  });

}


class Chat extends StatefulWidget {
  final String message,account;
  final DateTime timestamp;
  Chat(this.message,this.account,this.timestamp);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: Container(
        alignment: widget.account=="peer"?Alignment.topLeft:Alignment.topRight,

        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width*0.65,
          ),
          child: Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: widget.account=="peer"?BorderRadius.only(topLeft:Radius.circular(12.0),topRight:Radius.circular(12.0) ,bottomRight: Radius.circular(12.0)):
                BorderRadius.only(topLeft:Radius.circular(12.0),topRight:Radius.circular(12.0) ,bottomLeft: Radius.circular(12.0)),
              ),
              color: widget.account=="peer"?Colors.grey:Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(widget.message,style: GoogleFonts.aBeeZee(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
                    Padding(
                      padding: const EdgeInsets.only(top:2.0),
                      child: Text("${widget.timestamp.day} ${month(widget.timestamp.month)}@${widget.timestamp.hour}:${widget.timestamp.minute} hrs",textAlign: TextAlign.right,style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 10.0),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String month(int x){
  if(x==1){
    return "January";
  }
  else if(x==2){
    return "February";
  }
  else if(x==3){
    return "March";
  }
  else if(x==4){
    return "April";
  }
  else if(x==5){
    return "May";
  }
  else if(x==6){
    return "June";
  }
  else if(x==7){
    return "July";
  }
  else if(x==8){
    return "August";
  }
  else if(x==9){
    return "September";
  }
  else if(x==10){
    return "October";
  }
  else if(x==12){
    return "November";
  }
  else if(x==12){
    return "December";
  }
  else{
    return "Wrong Month";
  }
}