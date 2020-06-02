import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                backgroundColor: Colors.blue,
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
                      height: MediaQuery.of(context).size.height,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection("rides").snapshots(),
                        builder: (context,snapshot){
                          rides.clear();
                          if(snapshot.hasData){
                            for(int i=0;i<snapshot.data.documents.length;i++){
                              if(!List.from(snapshot.data.documents.elementAt(i).data['persons']).contains(loggedInEmail)){
                                rides.add(RideCard(
                                    snapshot.data.documents.elementAt(i).data['image'],
                                    snapshot.data.documents.elementAt(i).data['email'],
                                    snapshot.data.documents.elementAt(i).data['name'],
                                    snapshot.data.documents.elementAt(i).data['age'],
                                    snapshot.data.documents.elementAt(i).data['travellingTo'],
                                    snapshot.data.documents.elementAt(i).data['travellingFrom'],
                                    snapshot.data.documents.elementAt(i).data['start'],
                                    snapshot.data.documents.elementAt(i).data['end'],
                                    snapshot.data.documents.elementAt(i).data['gender']
                                ));
                              }
                            }
                          }
                          return !snapshot.hasData?Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          ):
                          ListView(
                            children: rides,
                          )
                          ;
                        },
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
                      height: MediaQuery.of(context).size.height,
                      child: StreamBuilder<QuerySnapshot>(
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
                                    snapshot.data.documents.elementAt(i).data['gender']
                                ));
                              }
                            }
                          }
                          return !snapshot.hasData?Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          ):
                          ListView(
                            children: currentRides,
                          )
                          ;
                        },
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
                    body: StreamBuilder<QuerySnapshot>(
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
                                snapshot.data.documents.elementAt(i).data['gender']));
                          }
                        }
                        return !snapshot.hasData?Center(child: CircularProgressIndicator())
                        :ListView(
                          shrinkWrap: true,
                          children: requests,
                        );
                      },
                    ),
                  ),
                  //Chats
                  Scaffold(
                    body:ListView(
                      children:chats,
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
  final String userEmail,userName,img,travellingTo,travellingFrom,start,end,gender,age;
  RideCard(this.img,this.userEmail,this.userName,this.age,this.travellingTo,this.travellingFrom,this.start,this.end,this.gender);
  @override
  _RideCardState createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  bool requestSent=false;
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
        color: Color.fromRGBO(253, 11, 23, 1),
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
                      RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Interested",style:TextStyle(color:requestSent?Colors.white:Color.fromRGBO(253, 11, 23, 1),fontSize: 16,fontWeight: FontWeight.w600),),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(requestSent?Icons.check_circle:Icons.drive_eta,color:requestSent?Colors.white:Color.fromRGBO(253, 11, 23, 1)),
                            ),
                          ],
                        ),color:requestSent?Colors.green:Colors.white,
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
                                    });
                                  }
                                });
                              }
                              else{
                                requestSent=false;
                                Firestore.instance.collection("rideReq_${widget.userEmail}").document("from_$loggedInEmail").delete();
                              }
                            });
                          });
                        },
                      ),
                      RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(child: Text(requestSent?"Request Sent":"Status",style:TextStyle(color: requestSent?Colors.green:Colors.blue,fontSize: 16,fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ),
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
                     title: Text(widget.userName,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
                    subtitle: Text("${widget.userName} is travelling from ${widget.travellingFrom} to ${widget.travellingTo}"
                        " on ${widget.start}.${widget.gender=="Male"?'He':'She'} is ${widget.age} years old and would be staying at ${widget.travellingTo} till ${widget.end}."
                    ,style: TextStyle(
                     fontSize: 18.0,fontWeight: FontWeight.w500,
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
  final String img,name,email,age,gender;
  RequestCard(this.img,this.name,this.email,this.age,this.gender);
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
        color: Color.fromRGBO(253, 11, 23, 1),
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
                            Text(reqAccepted?"Accepted":"Accept",style:TextStyle(color:reqAccepted?Colors.white:Colors.green,fontSize: 16,fontWeight: FontWeight.w600),),
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
                                reqAccepted=true;
                                Firestore.instance.collection("rides").document(widget.name).updateData({
                                  "persons":FieldValue.arrayUnion([widget.email]),
                                });
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
                            Text("Reject",style:TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.w600)),
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
                  title: Text("Ride request from ${widget.name}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  subtitle: Text("${widget.name} has requested to join your ride ...",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
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
  final String userEmail,userName,img,travellingTo,travellingFrom,start,end,gender,age;
  CurrentRideCard(this.img,this.userEmail,this.userName,this.age,this.travellingTo,this.travellingFrom,this.start,this.end,this.gender);
  @override
  _CurrentRideCardState createState() => _CurrentRideCardState();
}

class _CurrentRideCardState extends State<CurrentRideCard> {
  bool isActive=true;
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
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:14.0,vertical: 5.0),
      child: Card(
          color: Color.fromRGBO(253, 11, 23, 1),
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
                        RaisedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Message",style:TextStyle(color: Colors.blueAccent,fontSize: 16,fontWeight: FontWeight.w600)),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Icons.send,color: Colors.blueAccent),
                              ),
                            ],
                          ),
                          color: Colors.white,
                          onPressed:(){
                            addChat(loggedInEmail,widget.userEmail, widget.userName, widget.img);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all((Radius.circular(8.0))),
                          ),
                        ),
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
                                Text(isActive?"Active":"InActive",style:TextStyle(color: isActive?Colors.green:Colors.red,fontSize: 16,fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
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
              Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                     borderRadius: contentBorder),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(widget.userName,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),),
                        subtitle: Text("${widget.userName} is travelling from ${widget.travellingFrom} to ${widget.travellingTo}"
                            " on ${widget.start}.${widget.gender=="Male"?'He':'She'} is ${widget.age} years old and would be staying at ${widget.travellingTo} till ${widget.end}."
                          ,style: TextStyle(
                            fontSize: 18.0,fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  isActive?InkWell(
                    child: Container(
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("End Ride",textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontSize: 20.0,fontWeight: FontWeight.w600)),
                      ),
                      height: 40.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
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
  final String userEmail,chatToEmail,chatToName,chatToImage;
  ChatCard(this.userEmail,this.chatToEmail,this.chatToImage,this.chatToName);
  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final _messageController=TextEditingController();
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
          title: Text(widget.chatToName,style: TextStyle(fontSize: 18.0,color:Colors.cyan,fontWeight: FontWeight.w600),),
          subtitle: Text("Osho Customer",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.add_comment,color: Colors.black,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Chat"),
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
                              .collection("chat_${loggedInEmail}with${widget.chatToEmail}").document("messages").collection("chat").limit(20).orderBy('timestamp', descending: true).snapshots(),
                          builder: (context, snapshot) {
                            return !snapshot.hasData?Center(child: CircularProgressIndicator()):Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.8,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(10.0),
                                  itemBuilder: (context, index){
                                    if(snapshot.data.documents.elementAt(index).data['accountEmail']!=loggedInEmail) {
                                      return Chat("${snapshot.data.documents.elementAt(index).data['message']}","peer");
                                    }
                                    else{
                                      return Chat("${snapshot.data.documents.elementAt(index).data['message']}","current");
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
                          child: TextFormField(
                            controller: _messageController,
                            style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05,color:Colors.black,fontWeight: FontWeight.w700),
                            decoration: InputDecoration(
                              labelStyle:TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),
                              labelText: "Type a message",
                              contentPadding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 5.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send,size:25.0,color: Colors.black,),
                                onPressed: (){
                                  Firestore.instance
                                      .collection("chat_${loggedInEmail}with${widget.chatToEmail}").document("messages").collection("chat").add({
                                    "message":_messageController.text,
                                    "accountEmail":loggedInEmail,
                                    'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
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

void addChat(String userEmail,String chatToEmail,String chatToName,String chatToImage){
  chats.add(ChatCard(userEmail, chatToEmail, chatToImage, chatToName));
  Firestore.instance.collection("chat_${loggedInEmail}with$chatToEmail").document(chatToEmail).get().then((value){
    if(!value.exists){
      Firestore.instance.collection("chat_${loggedInEmail}with$chatToEmail").document(chatToEmail).setData({
        "name":chatToName,
        "email":chatToEmail,
        "image":chatToImage,
        });
       }
  });
}


class Chat extends StatefulWidget {
  final String message,account;
  Chat(this.message,this.account);
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
        child: Container(
          width: MediaQuery.of(context).size.width*0.6,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            color: widget.account=="peer"?Colors.grey:Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.message,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,color: Colors.white),),
            ),
          ),
        ),
      ),
    );
  }
}
