import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/socialApp.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'aeoui.dart';


class ReviewCard extends StatefulWidget {
  final String ashramEmail;
  ReviewCard(this.ashramEmail);
  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  final reviewController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double reviewedRating=3.5;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context,setState){
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          content:Container(
            height: MediaQuery.of(context).size.height*0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(Icons.person_add,size: 25,color: Colors.blueAccent,),
                                  ),
                                  Text("Review Ashram",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.w600),),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.close,color: Colors.red,),
                                onPressed: ()=>Navigator.pop(context),
                              )
                            ],
                          ),
                          Container(
                            height: 400.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.045,color:Colors.black,fontWeight: FontWeight.w700),
                                          validator: (String value){
                                            if(value==null||value==""){
                                              return "Please Enter Something";
                                            }
                                            else{
                                              return null;
                                            }
                                          },
                                          onChanged: (String v){
                                            _formKey.currentState.validate();
                                          },
                                          maxLines: 5,
                                          keyboardType: TextInputType.text,
                                          controller: reviewController,
                                          decoration: InputDecoration(
                                            labelText: "Review",
                                            errorStyle: GoogleFonts.balooBhaina(),
                                            labelStyle:TextStyle(fontSize: MediaQuery.of(context).size.width*0.045),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 5.0),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(Icons.rate_review,color: Colors.black,),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SmoothStarRating(
                                          allowHalfRating: true,
                                          onRated: (v) {
                                            setState(() {
                                              reviewedRating=v;
                                            });
                                          },
                                          filledIconData: Icons.star,
                                          halfFilledIconData: Icons.star_half,
                                          defaultIconData: Icons.star_border,
                                          starCount: 5,
                                          rating: reviewedRating,
                                          size: 40,
                                          isReadOnly:false,
                                          color: Colors.yellow,
                                          borderColor: Colors.yellow,
                                          spacing:0.0
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),


                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Text("Submit",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
                    ),
                    color:  Color.fromRGBO(253, 11, 23, 1),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        Firestore.instance.collection("ashrams").document(widget.ashramEmail).updateData({
                          "reviews":FieldValue.arrayUnion([reviewController.text]),
                        });
                        Firestore.instance.collection("ashrams").document(widget.ashramEmail).get().then((doc){
                          Firestore.instance.collection("ashrams").document(widget.ashramEmail).updateData({
                            "rating":(doc.data['rating']+reviewedRating)/2,
                          });
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}


class AshramPage extends StatefulWidget {
  final String email;
  AshramPage({this.email});
  @override
  _AshramPageState createState() => _AshramPageState();
}

class _AshramPageState extends State<AshramPage> {
  List<Icon> starRating=[];
  bool favourite=false;
  bool verifying=false;
  bool inTouch=false;
  bool ownAshram=true;
  final GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection("chats").document(loggedInEmail).collection("chats_$loggedInEmail").document("chat_${loggedInEmail}with${widget.email}_info").get().then((doc){
      setState(() {
        if(doc.exists){
          inTouch=true;
        }
        else{
          inTouch=false;
        }
      });
    });
    Firestore.instance.collection("ashrams").document(widget.email).get().then((doc){
      setState(() {
        if(doc.exists){
          if(doc.data['email']==loggedInEmail){
            setState(() {
              ownAshram=true;
            });
          }else{
            setState(() {
              ownAshram=false;
            });
          }
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: StreamBuilder(
            stream: Firestore.instance.collection("ashrams").document(widget.email).snapshots(),
            builder: (context, snapshot) {
              starRating.clear();
              if(snapshot.hasData){
                /* Firestore.instance.collection("savedEvents").document(loggedInEmail).collection("saved").document(snapshot.data['title'].toString()).get().then((doc){
                  setState(() {
                    if(doc.exists){
                      favourite=true;
                    }
                    else{
                      favourite=false;
                    }
                  });
                });*/
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
                    imageUrl: snapshot.data['image'],
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
                    placeholder: (context, url) => Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),

                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 180),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                snapshot.data['name'],
                                style: GoogleFonts.balooBhaina(
                                    color: Colors.white,
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            if(!ownAshram)
                              Container(
                                width: 45,
                                height: 45,
                                child: FloatingActionButton(
                                  backgroundColor:deepRed,
                                  child: Icon(Icons.rate_review,color: Colors.white,),
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ReviewCard(snapshot.data['email'].toString());
                                        });
                                  },
                                ),
                              ),
                          ],
                        ),

                        StreamBuilder(
                            stream: Firestore.instance.collection("users").document(snapshot.data['email']).snapshots(),
                            builder: (context, userSnapshot) {
                              return userSnapshot.hasData?Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  color: Colors.black38,
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
                                          imageUrl: userSnapshot.data['photoURL'],
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
                                    title: Text(ownAshram?"You":userSnapshot.data['name'],style: GoogleFonts.aBeeZee(fontSize: 18,color: Colors.white),),
                                    subtitle: Text("Owner",style: GoogleFonts.aBeeZee(fontSize: 16,color: Colors.grey)),
                                    trailing: !ownAshram?FloatingActionButton(
                                      child: Icon(inTouch?Icons.touch_app:Icons.send),
                                      heroTag: 29393,
                                      onPressed: (){
                                        if(inTouch==false){
                                          addSocialChat(loggedInEmail,userSnapshot.data['email'], userSnapshot.data['name'], userSnapshot.data['photoURL']);
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
                                    ):Icon(Icons.account_circle,color: Colors.blueAccent,size: 50,),
                                  ),
                                ),
                              ):Container();
                            }
                        ),

                        Row(
                          children: <Widget>[
                            const SizedBox(width: 16.0),
                            Padding(
                              padding: const EdgeInsets.only(bottom:8.0),
                              child: Container(
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
                            ),
                            Spacer(),
                            /* Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                  backgroundColor: !favourite?Colors.grey:Colors.white,
                                  child: Icon(Icons.favorite,color: !favourite?Colors.white:Colors.red,),
                                  heroTag: 3,
                                  onPressed: ()=>null
                              ),
                            )*/
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(32.0),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              /*Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0)),
                                    color: Color.fromRGBO(253, 11, 23, 1),
                                    textColor: Colors.white,
                                    child: Text(
                                      !favourite?"Add to Saved":"Remove Saved",
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
                                      }):
                                      Firestore.instance.collection("savedEvents").document(loggedInEmail).collection("saved").document(snapshot.data['title']).delete();
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
                              ),*/
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
                              const SizedBox(height: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Text("Facilities and Accommodation",style: GoogleFonts.aBeeZee(color:Colors.black,fontWeight:FontWeight.bold,fontSize: 18)),
                                  StreamBuilder<QuerySnapshot>(
                                      stream:Firestore.instance.collection("AshramFacilities").document("${snapshot.data['email']}").collection("points").snapshots(),
                                      builder: (context, snapshot) {
                                        return snapshot.hasData?
                                        snapshot.data.documents.isNotEmpty?ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.documents.length,
                                          itemBuilder: (context,i){
                                            return PointCard(snapshot.data.documents.elementAt(i).data['point'],
                                                snapshot.data.documents.elementAt(i).data['id']);
                                          },
                                        ):Text("No Points Added",style: GoogleFonts.balooBhai(fontSize: 14),)

                                            :Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Center(child: Container(width:24,height: 24,child: CircularProgressIndicator(strokeWidth: 2,backgroundColor: Colors.white,))),
                                        );
                                      }
                                  ),

                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: <Widget>[

                                  Text("Terms and Conditions",style: GoogleFonts.aBeeZee(color:Colors.black,fontWeight:FontWeight.bold,fontSize: 18)),
                                  StreamBuilder<QuerySnapshot>(
                                      stream:Firestore.instance.collection("AshramT&C").document("${snapshot.data['email']}").collection("T&C").snapshots(),
                                      builder: (context, snapshot) {
                                        return snapshot.hasData?
                                        snapshot.data.documents.isNotEmpty?ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.documents.length,
                                          itemBuilder: (context,i){
                                            return ConditionCard(snapshot.data.documents.elementAt(i).data['t&c'],
                                                snapshot.data.documents.elementAt(i).data['id']);
                                          },
                                        ):Text("No Terms or Conditions Added",style: GoogleFonts.balooBhai(fontSize: 14),)

                                            :Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Center(child: Container(width:24,height: 24,child: CircularProgressIndicator(strokeWidth: 2,backgroundColor: Colors.white,))),
                                        );
                                      }
                                  ),

                                ],
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


class ConditionCard extends StatefulWidget {
  final String point,id;
  ConditionCard(this.point, this.id);
  @override
  _ConditionCardState createState() => _ConditionCardState();
}

class _ConditionCardState extends State<ConditionCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading:Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(Icons.info,),
        ),
        title:Text(widget.point,style: GoogleFonts.aBeeZee(color:Colors.black54,fontSize: 16),)
    );
  }
}



class PointCard extends StatefulWidget {
  final String point,id;
  PointCard(this.point, this.id);
  @override
  _PointCardState createState() => _PointCardState();
}

class _PointCardState extends State<PointCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading:Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(Icons.stars,),
        ),
        title:Text(widget.point,style: GoogleFonts.aBeeZee(color:Colors.black54,fontSize: 16),)
    );
  }
}