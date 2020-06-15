import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/widgets/custom_icons_icons.dart';
import 'aeoui.dart';

List<UserCard> allUsers=[];
List<Follower> currentFollowers=[];
List<FollowRequestCard> requests=[];
List<ChatCard> chats=[];
class Social extends StatefulWidget {
  final String userEmail,userName,gender,age,img;
  Social({this.userEmail,this.userName,this.gender,this.age,this.img});
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  final searchController=TextEditingController();
  final contactSearchController=TextEditingController();
  String contact="";
  String friendName="";
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
            child: SafeArea(
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
                      Tab(icon: Icon(Icons.group)),
                      Tab(icon: Icon(Icons.group_add)),
                      Tab(icon:Icon(Icons.mail))
                    ],
                  ),
                  title: Text(
                    "My Friends",
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
                                      friendName=value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search Friends...",
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
                                stream: Firestore.instance.collection("users").snapshots(),
                                builder: (context,snapshot){
                                  allUsers.clear();
                                  if(snapshot.hasData){
                                    for(int i=0;i<snapshot.data.documents.length;i++){
                                      if(snapshot.data.documents.elementAt(i).data['name'].toString().contains(friendName)||snapshot.data.documents.elementAt(i).data['name'].toString().toUpperCase().contains(friendName)||snapshot.data.documents.elementAt(i).data['name'].toString().toLowerCase().contains(friendName)
                                      ){
                                        allUsers.add(UserCard(
                                            snapshot.data.documents.elementAt(i).data['photoURL'],
                                            snapshot.data.documents.elementAt(i).data['email'],
                                            snapshot.data.documents.elementAt(i).data['name']
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
                                  allUsers.isNotEmpty?Padding(
                                    padding: const EdgeInsets.symmetric(vertical:8.0),
                                    child: Column(
                                      children: allUsers,
                                    ),
                                  ):Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(100.0),
                                      child: Text("No Friends Available",style: GoogleFonts.balooBhaina(
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
                    //Current allUsers
                    Scaffold(
                      body: Container(
                        height: MediaQuery.of(context).size.height*0.8,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance.collection("followers").document(widget.userEmail).collection("followers").snapshots(),
                                builder: (context,snapshot){
                                  currentFollowers.clear();
                                  if(snapshot.hasData){
                                    for(int i=0;i<snapshot.data.documents.length;i++){
                                      currentFollowers.add(Follower(
                                        snapshot.data.documents.elementAt(i).data['image'],
                                        snapshot.data.documents.elementAt(i).data['email'],
                                        snapshot.data.documents.elementAt(i).data['name'],
                                      ));

                                    }
                                  }
                                  return !snapshot.hasData?Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(100.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ):
                                  currentFollowers.isNotEmpty?Padding(
                                    padding: const EdgeInsets.symmetric(vertical:8.0),
                                    child: Column(
                                      children: currentFollowers,
                                    ),
                                  ):Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical:100.0,horizontal: 32),
                                      child: Text("No Current Followers",style: GoogleFonts.balooBhaina(
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
                    //Requests
                    Scaffold(
                      body: Container(
                        height: MediaQuery.of(context).size.height*0.8,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance.collection("followReq").document(loggedInEmail).collection("followReq_$loggedInEmail").snapshots(),
                                builder: (context,snapshot){
                                  requests.clear();
                                  if(snapshot.hasData){
                                    for(int i=0;i<snapshot.data.documents.length;i++){
                                      requests.add(FollowRequestCard(
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
                                  requests.isNotEmpty?Padding(
                                    padding: const EdgeInsets.symmetric(vertical:8.0),
                                    child: Column(
                                      children: requests,
                                    ),
                                  ):Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:32.0,vertical: 100),
                                      child: Text("No Follow Requests",style: GoogleFonts.balooBhaina(
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
                                    stream: Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").snapshots(),
                                    builder: (context, snapshot) {
                                      return !snapshot.hasData?Center(child: CircularProgressIndicator()):
                                      ListView.builder(
                                        itemCount: snapshot.data.documents.length,
                                        itemBuilder: (context,i){
                                          if(snapshot.data.documents.elementAt(i).documentID.contains("info")&&(snapshot.data.documents.elementAt(i).data['name'].toString().contains(contact)||snapshot.data.documents.elementAt(i).data['name'].toString().toLowerCase().contains(contact)||snapshot.data.documents.elementAt(i).data['name'].toString().toUpperCase().contains(contact))){
                                            return ChatCard(loggedInEmail,snapshot.data.documents.elementAt(i).data['email'],
                                                snapshot.data.documents.elementAt(i).data['image'],snapshot.data.documents.elementAt(i).data['name']);
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
              ),
            )
        )
    );
  }
}

class UserCard extends StatefulWidget {
  final String userEmail,userName,img;
  UserCard(this.img,this.userEmail,this.userName);
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool requestSent=false;
  bool friends=false;
  String status="Request Status";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection("followReq").document(widget.userEmail).collection("followReq_${widget.userEmail}").document("from_$loggedInEmail").get().then((doc){
      setState(() {
        if(doc.exists){
          requestSent=true;
        }
        else{
          requestSent=false;
        }
      });
    });
    Firestore.instance.collection("followers").document(loggedInEmail).collection("followers").document(widget.userEmail).get().then((doc){
      setState(() {
        if(doc.exists){
          friends=true;
        }
      });
    });
    Firestore.instance.collection("followers").document(widget.userEmail).collection("followers").document(loggedInEmail).get().then((doc){
      setState(() {
        if(doc.exists){
          friends=true;
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:14.0),
      child: Card(
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all((Radius.circular(12.0))),
          ),
          elevation: 15.0,
          child:Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Material(
                  shape: CircleBorder(),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.14,
                    height: MediaQuery.of(context).size.width*0.14,
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
                      errorWidget: (context, url, error) => Icon(Icons.account_circle,size: 50,color: Colors.blueAccent,),
                    ),
                  ),
                ),
                trailing:!friends?IconButton(
                  icon: Icon(requestSent?Icons.person_add:Icons.favorite,color:requestSent?Colors.green:Color.fromRGBO(253, 11, 23, 1)),
                  onPressed:(){
                    setState(() {
                      setState(() {
                        if(requestSent==false){
                          requestSent=true;
                          List<String> ridePersons=[];
                          Firestore.instance.collection("users").document(loggedInEmail).get().then((doc){
                            if(doc.exists){
                              Firestore.instance.collection("followReq").document(widget.userEmail).collection("followReq_${widget.userEmail}").document("from_$loggedInEmail").setData({
                                "fromEmail":doc.data['email'],
                                "name":doc.data['name'],
                                "age":doc.data['age'],
                                "gender":doc.data['gender'],
                                "image":doc.data['photoURL'],
                                "persons":ridePersons,
                                "rideBy":widget.userName,
                              }).then((value){
                                Firestore.instance.collection("notifications").document(loggedInEmail).collection("notifications_$loggedInEmail").add({
                                  "message":"Follow Request has been sent to ${widget.userEmail}",
                                  "timestamp":DateTime.now().toIso8601String(),
                                  "seen":false
                                }).then((value){
                                  Firestore.instance.collection("notifications").document(loggedInEmail).collection("notifications_$loggedInEmail").document(value.documentID).updateData({
                                    "id":value.documentID,
                                  });
                                });
                                Firestore.instance.collection("notifications").document(widget.userEmail).collection("notifications_${widget.userEmail}").add({
                                  "message":"You have a new Follow request from $loggedInEmail",
                                  "timestamp":DateTime.now().toIso8601String(),
                                  "seen":false
                                }).then((value){
                                  Firestore.instance.collection("notifications").document(widget.userEmail).collection("notifications_${widget.userEmail}").document(value.documentID).updateData({
                                    "id":value.documentID,
                                  });
                                });

                              });
                            }
                          });
                        }
                        else{
                          setState(() {
                            status="Canceled";
                          });
                          requestSent=false;
                          Firestore.instance.collection("rideReq").document(widget.userEmail).collection("rideReq_${widget.userEmail}").document("from_$loggedInEmail").delete();
                          Firestore.instance.collection("notifications").document(loggedInEmail).collection("notifications_$loggedInEmail").add({
                            "message":"Follow Request to ${widget.userEmail} Cancelled",
                            "timestamp":DateTime.now().toIso8601String(),
                            "seen":false
                          }).then((value){
                            Firestore.instance.collection("notifications").document(loggedInEmail).collection("notifications_$loggedInEmail").document(value.documentID).updateData({
                              "id":value.documentID,
                            });
                          });

                        }
                      });
                    });
                  },
                ):Icon(CustomIcons.user_friends,color: Colors.blueAccent,) ,
                title: Text("${widget.userName}",style: GoogleFonts.aBeeZee(fontSize: 17,fontWeight: FontWeight.w600),),
                subtitle: Text("${widget.userEmail}",style: GoogleFonts.aBeeZee(fontSize: 16,fontWeight: FontWeight.w500)),
              ),
            ),
          )
      ),
    );
  }
}

class FollowRequestCard extends StatefulWidget {
  final String img,name,email,age,gender,loggedInName;
  FollowRequestCard(this.img,this.name,this.email,this.age,this.gender, this.loggedInName);
  @override
  _FollowRequestCardState createState() => _FollowRequestCardState();
}

class _FollowRequestCardState extends State<FollowRequestCard> {
  bool reqAccepted=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 4.0),
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
                        errorWidget: (context, url, error) => Icon(Icons.account_circle,size: 50,color: Colors.blueAccent,),
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
                                Firestore.instance.collection("followers").document(loggedInEmail).collection("followers").document(widget.email).setData({
                                  "image":widget.img,
                                  "email":widget.email,
                                  "name":widget.name,
                                },merge: true);
                                Firestore.instance.collection("users").document(loggedInEmail).get().then((doc){
                                  Firestore.instance.collection("followers").document(widget.email).collection("followers").document(loggedInEmail).setData({
                                    "image":doc.data['photoURL'],
                                    "email":loggedInEmail,
                                    "name":doc.data['name'],
                                  },merge: true);
                                });
                                Firestore.instance.collection("notifications").document(widget.email).collection("notifications_${widget.email}").add({
                                  "message":"Your friend request to $loggedInEmail has been accepted",
                                  "timestamp":DateTime.now().toIso8601String(),
                                  "seen":false
                                }).then((value){
                                  Firestore.instance.collection("notifications").document(widget.email).collection("notifications_${widget.email}").document(value.documentID).updateData({
                                    "id":value.documentID,
                                  });
                                });
                                reqAccepted=true;
                              }else{
                                reqAccepted=false;
                              }
                              Firestore.instance.collection("followReq").document(loggedInEmail).collection("followReq_$loggedInEmail").document("from_${widget.email}").delete();
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
                        onPressed:(){
                          Firestore.instance.collection("followReq").document(loggedInEmail).collection("followReq_$loggedInEmail").document("from_${widget.email}").delete();
                          Firestore.instance.collection("notifications").document(widget.email).collection("notifications_${widget.email}").add({
                            "message":"Your follow request to $loggedInEmail has been rejected",
                            "timestamp":DateTime.now().toIso8601String(),
                            "seen":false
                          }).then((value){
                            Firestore.instance.collection("notifications").document(widget.email).collection("notifications_${widget.email}").document(value.documentID).updateData({
                              "id":value.documentID,
                            });
                          });
                        },
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
                  title: Text("Follow request from ${widget.email}",style: GoogleFonts.aBeeZee(fontSize: 18,fontWeight: FontWeight.w600),),
                  subtitle: Text("${widget.name} has requested to follow you",style: GoogleFonts.aBeeZee(fontSize: 16,fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Follower extends StatefulWidget {
  final String userEmail,userName,img;
  Follower(this.img,this.userEmail,this.userName);
  @override
  _FollowerState createState() => _FollowerState();
}

class _FollowerState extends State<Follower> {
  int followerPeeps;
  bool isActive=true;
  bool inTouch=false;
  bool ownRide=false;
  BorderRadius contentBorder=BorderRadius.all(Radius.circular(0));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.userEmail}_info").get().then((doc){
      setState(() {
        if(doc.exists){
          inTouch=true;
        }
        else{
          inTouch=false;
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:14.0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all((Radius.circular(12.0))),
          ),
          elevation: 15.0,
          child:Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                trailing: IconButton(
                  icon:  Icon(inTouch?Icons.touch_app:Icons.send,color: Colors.blueAccent),
                  onPressed:(){
                    if(inTouch==false){
                      addSocialChat(loggedInEmail,widget.userEmail, widget.userName, widget.img);
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
                ),
                leading:  Material(
                  shape: CircleBorder(),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.15,
                    height: MediaQuery.of(context).size.width*0.15,
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
                        errorWidget: (context, url, error) =>Icon(Icons.account_circle,size: 50,color: Colors.blueAccent,)
                    ),
                  ),
                ),
                title: Text("${widget.userName}",style: GoogleFonts.aBeeZee(fontSize: 18,fontWeight: FontWeight.w600),),
                subtitle: Text("${widget.userEmail}",style: GoogleFonts.aBeeZee(fontSize: 16,fontWeight: FontWeight.w500)),
              ),
            ),
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
  String message;
  bool organizer=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection("users").document(widget.chatToEmail).get().then((doc){
      if(doc.exists){
        if(doc.data['ashram']!=null){
          setState(() {
            organizer=true;
          });
        }
        else{
          setState(() {
            organizer=false;
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 10.0,
        child: ListTile(
          leading:Material(
            shape: CircleBorder(),
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color:Colors.white,width: 3.0),
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
                  errorWidget: (context, url, error) => Icon(Icons.account_circle,size: 50,color: Colors.blueAccent,)
              ),
            ),
          ),
          title: Text(widget.chatToName,style: GoogleFonts.aBeeZee(fontSize: 17.0,color:Colors.cyan,fontWeight: FontWeight.w600),),
          subtitle: Text(organizer?"Osho Organizer":"Osho Customer",style: GoogleFonts.aBeeZee(fontSize: 15.0,fontWeight: FontWeight.w500)),
          trailing: Container(
            width: MediaQuery.of(context).size.width*0.21,
            child: Row(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                    stream:Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").snapshots() ,
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
                          padding: const EdgeInsets.all(5.0),
                          child: Text("$unseen",style: GoogleFonts.aBeeZee(fontSize: 14,color: Colors.white),),
                        ),
                      ):Icon(Icons.notifications);
                    }
                ),
                IconButton(icon: Icon(Icons.delete,color: deepRed,),
                  onPressed: (){
                    Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").delete();
                    Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}_info").delete();
                    Firestore.instance.collection("chats").document(widget.chatToEmail).collection("chats_${widget.chatToEmail}").document("chat_${widget.chatToEmail}with$loggedInEmail").delete();
                    Firestore.instance.collection("chats").document(widget.chatToEmail).collection("chats_${widget.chatToEmail}").document("chat_${widget.chatToEmail}with${loggedInEmail}_info").delete();
                  },
                ),
              ],
            ),
          ),
          onTap: (){
            Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").getDocuments().then((QuerySnapshot snapshot){
              for(int i=0;i<snapshot.documents.length;i++){
                Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").document(snapshot.documents.elementAt(i).data['id']).updateData({
                  "seen":true,
                });
              }
            }).then((value){
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
                                  .collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").limit(100).orderBy('timestamp', descending: true).snapshots(),
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
                              color: Colors.white,
                              child: TextFormField(
                                controller: _messageController,
                                style: GoogleFonts.aBeeZee(fontSize: MediaQuery.of(context).size.width*0.05,color:Colors.black,fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  labelStyle:GoogleFonts.balooBhaina(fontSize: 16),
                                  labelText: "Type a message",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 5.0),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.send,size:25.0,color: Colors.black,),
                                    onPressed: (){
                                      setState(() {
                                        message=_messageController.text;
                                      });
                                      _messageController.clear();
                                      Firestore.instance
                                          .collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").add({
                                        "message":message,
                                        "accountEmail":loggedInEmail,
                                        'timestamp': DateTime.now().toIso8601String(),
                                        "seen":true,
                                      }).then((value){
                                        setState(() {
                                          Firestore.instance
                                              .collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.chatToEmail}").collection("chat").document(value.documentID).updateData({
                                            "id":value.documentID,
                                          });
                                        });
                                      });
                                      Firestore.instance
                                          .collection("chats").document(widget.chatToEmail).collection("chats_${widget.chatToEmail}").document("chat_${widget.chatToEmail}with$loggedInEmail").collection("chat").add({
                                        "message":message,
                                        "accountEmail":loggedInEmail,
                                        'timestamp': DateTime.now().toIso8601String(),
                                        "seen":false,
                                      }).then((value){
                                        Firestore.instance
                                            .collection("chats").document(widget.chatToEmail).collection("chats_${widget.chatToEmail}").document("chat_${widget.chatToEmail}with$loggedInEmail").collection("chat").document(value.documentID).updateData({
                                          "id":value.documentID,
                                        }).then((value){
                                          Firestore.instance.collection("notifications").document(widget.chatToEmail).collection("notifications_${widget.chatToEmail}").add({
                                            "message":"Message from \n${widget.userEmail}\n\"$message\"",
                                            "timestamp":DateTime.now().toIso8601String(),
                                            "seen":false
                                          }).then((value){
                                            Firestore.instance.collection("notifications").document(widget.chatToEmail).collection("notifications_${widget.chatToEmail}").document(value.documentID).updateData({
                                              "id":value.documentID,
                                            });
                                          });
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
            });
          },
        ),
      ),
    );
  }
}

void addSocialChat(String userEmail,String chatToEmail,String chatToName,String chatToImage){
  Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${chatToEmail}_info").get().then((value){
    if(!value.exists){
      Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${chatToEmail}_info").setData({
        "name":chatToName,
        "email":chatToEmail,
        "image":chatToImage,
      });
    }
  });
  Firestore.instance.collection("users").document(userEmail).get().then((doc){
    if(doc.exists){
      Firestore.instance.collection("chats").document(chatToEmail).collection("chats_$chatToEmail").document("chat_${chatToEmail}with${loggedInEmail}_info").get().then((value){
        if(!value.exists){
          Firestore.instance.collection("chats").document(chatToEmail).collection("chats_$chatToEmail").document("chat_${chatToEmail}with${loggedInEmail}_info").setData({
            "name":doc.data['name'],
            "email":doc.data['email'],
            "image":doc.data['photoURL'],
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
    return "Jan";
  }
  else if(x==2){
    return "Feb";
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
    return "Aug";
  }
  else if(x==9){
    return "Sept";
  }
  else if(x==10){
    return "Oct";
  }
  else if(x==12){
    return "Nov";
  }
  else if(x==12){
    return "Dec";
  }
  else{
    return "Wrong Month";
  }
}