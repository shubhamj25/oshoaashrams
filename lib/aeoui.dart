import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/bottomNavigationPage3.dart';
import 'package:rooms/newLoginscreen2.dart';
import 'package:rooms/subscriptionMainPage.dart';
import 'package:rooms/userProfilePafe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'AshramPage.dart';
import 'OnGoingEvents.dart';
import 'bottomnavigationpage2.dart';
import 'constant/constant.dart';
import 'hisroryAndWallet.dart';
import 'model/aeospecials.dart';
import 'model/aeowordlist.dart';
import 'model/arealocationlist.dart';
import 'model/exploreaeohotelslist.dart';
import 'model/latestaeo.dart';
import 'model/limitedperiodofferlist.dart';
import 'model/readyforsummerlist.dart';
import 'model/weekendgetawayslist.dart';
import 'model/yourwalletslist.dart';
import 'organiserPageNotifications.dart';
import 'widgets/customshape.dart';

String loggedInEmail;
String loggedInPassword;
Color deepRed=Color.fromRGBO(253, 11, 23, 1);
class HomePage extends StatefulWidget {
  final String username;
  bool rememberMe;
  HomePage({this.username,this.rememberMe});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String msg = 'Hey Friends try this OSHO app';
  String base64Image = '';

  double _width;
  double _height;
  List<AreaLocationList> areaLocationList;
  List<ReadyForSummerList> readyForSummer;
  List<LimitedPeriodOfferList> limitedPeriodOffer;
  List<ExploreOyoHotelsList> exploreOyoHotels;
  List<WeekendGetawaysList> weekendGetaways;
  List<oyoWordList> oyoWord;
  List<OyoSpecialsList> oyoSpecials;
  List<LatestOyoList> latestOyo;
  List<YourWalletList> yourWallets;

  Widget _buildLocationList(AreaLocationList item) {
    return Container(
      color: Colors.white,
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(70.0),
              child: Image.asset(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              item.name,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourWalletsList(YourWalletList item) {
    return Container(
        width: _width / 1.5,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Card(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          color: Colors.orange[100],
          child: Stack(children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Opacity(
                opacity: 0.75,
                child: ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Container(
                    height: _height / 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange[200], Colors.pinkAccent],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Column(
                children: <Widget>[
                  Opacity(
                    opacity: 0.5,
                    child: ClipPath(
                      clipper: CustomShapeClipper2(),
                      child: Container(
                        //height: _height / 3.5,
                        height: _height / 7.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[500], Colors.pinkAccent],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Text(
                          item.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            item.subTitleRupee,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.asset(
                            item.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 150,
                    ),
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          item.totalRupee,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  Widget _buildLatestAeoList(LatestOyoList item) {
    return Container(
      width: _width / 2.1,
      child: Card(
        elevation: 0,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  item.name,
                  style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 0.1,
                      height: 1.5,
                      fontWeight: FontWeight.w600),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAeoSpecialsList(OyoSpecialsList item) {
    return Container(
      width: _width / 2.20,
      child: Card(
        elevation: 2,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: Container(
                  child: Image.asset(
                    item.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      item.subTitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          letterSpacing: 0.1,
                          height: 1.5),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekendGetawaysList(WeekendGetawaysList item) {
    return Container(
      width: _width / 2.4,
      child: Card(
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5)),
          child: Image.asset(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildExploreAeoHotelsList(ExploreOyoHotelsList item) {
    return Container(
      width: _width / 2.20,
      child: Card(
        elevation: 2,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: Image.asset(
                  item.imgUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.black,
              height: _height / 30,
              width: _width / 5,
              child: Text(
                item.title,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  item.subTitle,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      letterSpacing: 0.1,
                      height: 1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitedPeriodList(LimitedPeriodOfferList item) {
    return Container(
      width: _width / 2.5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            child: Image.asset(
              item.imgUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummerList(ReadyForSummerList item) {
    return Container(
      width: _width,
      child: Card(
        elevation: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            item.imgUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

@override
  void initState() {
    super.initState();
    areaLocationList = Constants.getLocationList();
    readyForSummer = Constants.getSummerList();
    limitedPeriodOffer = Constants.getLimitedPeriodOfferList();
    exploreOyoHotels = Constants.getExploreOyoHotelsList();
    weekendGetaways = Constants.getWeekendsList();
    oyoSpecials = Constants.getOyoSpecials();
    latestOyo = Constants.getLatestOyo();
    yourWallets = Constants.getYourWallet();
  }
  // ignore: non_constant_identifier_names
  Widget image_carousel;
  final searchController=TextEditingController();
  bool searchBarTap=false;
  String searchText="^";
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: _height / 5,
            floating: true,

            actions: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 15),
                  child: IconButton(
                    icon: Icon(Icons.notifications_active),
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              OrganiserNotifications()));
                    }, //notification Page of the consumer
                  ))
            ],
            backgroundColor: Color.fromRGBO(253, 11, 23, 1),
            //#f02730
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              centerTitle: true,
              titlePadding: EdgeInsets.only(top: 25.0),
              title: Center(
                child: Image.asset(
                  'assets/images/OshoLogo.png',
                  height: 70.0,
                  width: 70.0,
                ),
              ),
            ),
            bottom: PreferredSize(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12))),
                width: _width,
                height: _height / 14,
                alignment: Alignment.topCenter,
                child: TextFormField(
                  controller: searchController,
                  cursorColor: Colors.grey,
                  onChanged: (val){
                    setState(() {
                      searchBarTap=true;
                      searchText=val;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      suffixIcon: searchBarTap?IconButton(icon:Icon(Icons.close),onPressed: (){
                        setState(() {
                          searchBarTap=false;
                          FocusScope.of(context).unfocus();
                          searchController.clear();
                        });
                      },):null,
                      prefixIcon: Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.grey,
                      ),
                      hintText: "Search for Hotel, City or Location",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                ),
              ),
              preferredSize: Size(_width, _height / 20),
            ),
          ),
        ];
      },
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: _height / 6,
                  child: ListView.builder(
                      itemCount: areaLocationList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildLocationList(areaLocationList[index]);
                      }),
                ),
                image_carousel = new Container(
                  height: 300.0,
                  child: Carousel(
                    boxFit: BoxFit.cover,
                    images: [
                      AssetImage("assets/images/c1.jpg"),
                      AssetImage("assets/images/c2.jpg"),
                      AssetImage("assets/images/c3.jpg"),
                      AssetImage("assets/images/c4.jpg"),
                      AssetImage("assets/images/c5.jpg"),
                    ],
                    autoplay: true,
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: Duration(milliseconds: 1000),
                    dotSize: 4.0,
                    indicatorBgPadding: 6.0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>AeoUI(currentState: 1,username: loggedInEmail,rememberMe: widget.rememberMe,)));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Best Aashrams ॐ ',
                            style: GoogleFonts.balooBhaina(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            )),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AeoUI(currentState: 2,username: loggedInEmail,rememberMe: widget.rememberMe,)));
                          },
                          child: Container(
                            //color: Colors.blue,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3,
                                spreadRadius: 0.2,
                                offset: Offset(0.1, 3),
                              ),
                            ]),
                            height: _height / 8,
                            width: _width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/53.PNG',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AeoUI(currentState: 2,username: loggedInEmail,rememberMe: widget.rememberMe,)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              'OSHO SPIRITUALITY  !',
                              style: GoogleFonts.balooBhaina(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AeoUI(currentState: 2,username: loggedInEmail,rememberMe: widget.rememberMe,)));
                          },
                          child: Container(
                            //color: Colors.blue,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3,
                                spreadRadius: 0.2,
                                offset: Offset(0.1, 3),
                              ),
                            ]),
                            height: _height / 4,
                            width: _width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/Capture.PNG',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            FlutterShareMe().shareToWhatsApp(
                                base64Image: base64Image, msg: msg);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              'Referred win',
                              style: GoogleFonts.balooBhaina(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            FlutterShareMe().shareToWhatsApp(
                                base64Image: base64Image, msg: msg);
                          },
                          child: Container(
                            //color: Colors.blue,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3,
                                spreadRadius: 0.2,
                                offset: Offset(0.1, 3),
                              ),
                            ]),
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/referwin.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SubscritionHomePage(userEmail: loggedInEmail,)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              'Exclusive Deals',
                              style: GoogleFonts.balooBhaina(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SubscritionHomePage(userEmail: loggedInEmail,)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3,
                                spreadRadius: 0.2,
                                offset: Offset(0.1, 3),
                              ),
                            ]),
                            height: _height / 4.5,
                            width: _width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/dailySale.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Get Ready for Summer !',
                            style: GoogleFonts.balooBhaina(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          height: 90,
                          //height: MediaQuery.of(context).size.height,
                          width: _width,
                          child: ListView.builder(
                              itemCount: readyForSummer.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildSummerList(readyForSummer[index]);
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Meditation And YOGA',
                            style: GoogleFonts.balooBhaina(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          height: _height / 4,
                          child: ListView.builder(
                              itemCount: limitedPeriodOffer.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildLimitedPeriodList(
                                    limitedPeriodOffer[index]);
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Connect With Nature',
                            style: GoogleFonts.balooBhaina(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          //color: Colors.blue,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3,
                              spreadRadius: 0.2,
                              offset: Offset(0.1, 3),
                            ),
                          ]),
                          height: _height / 3.7,
                          width: _width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              'assets/images/fun.jpeg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Explore OSHO Aashrams',
                            style: GoogleFonts.balooBhaina(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: _width,
                          height: _height / 2.3,
                          child: ListView.builder(
                              itemCount: exploreOyoHotels.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildExploreAeoHotelsList(
                                    exploreOyoHotels[index]);
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Weekend Getaways',
                            style: GoogleFonts.balooBhaina(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width,
                          height: _height / 2.8,
                          child: ListView.builder(
                              itemCount: weekendGetaways.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildWeekendGetawaysList(
                                    weekendGetaways[index]);
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Osho Specials',
                            style: GoogleFonts.balooBhaina(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: _width,
                          height: _height / 2.4,
                          child: ListView.builder(
                              itemCount: oyoSpecials.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildAeoSpecialsList(oyoSpecials[index]);
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Latest at OSHO',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: _width,
                          height: _height / 2.4,
                          child: ListView.builder(
                              itemCount: latestOyo.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildLatestAeoList(latestOyo[index]);
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Shake & Win',
                            style: GoogleFonts.balooBhaina(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          height: _height / 4.2,
                          width: _width,
                          child: Card(
                            elevation: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              child: Image.asset(
                                'assets/images/shake_win.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            //color: Colors.orange,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Play and win',
                            style: GoogleFonts.balooBhaina(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          height: _height / 4.5,
                          width: _width,
                          child: Card(
                            elevation: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              child: Image.asset(
                                'assets/images/playwin.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            //color: Colors.orange,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Your wallets',
                            style: GoogleFonts.balooBhaina(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: _width,
                          height: _height / 4.2,
                          child: ListView.builder(
                              itemCount: yourWallets.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildYourWalletsList(yourWallets[index]);
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          searchBarTap?Material(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft:Radius.circular(12),bottomRight: Radius.circular(12)),
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:40.0,vertical: 8),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection("ashrams").snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData?ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context,index){
                            return (snapshot.data.documents.elementAt(index).data['name'].toString().toUpperCase().contains(searchText)||snapshot.data.documents.elementAt(index).data['name'].toString().toLowerCase().contains(searchText)||snapshot.data.documents.elementAt(index).data['name'].toString().contains(searchText))?
                            InkWell(
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(
                                    builder: (context){
                                      return AshramPage(email:snapshot.data.documents.elementAt(index).data['email']);
                                    }
                                ));
                                setState(() {
                                  searchBarTap=false;
                                  FocusScope.of(context).unfocus();
                                  searchController.clear();
                                });
                              },
                              child: Text(snapshot.data.documents.elementAt(index).data['name'],
                                style: GoogleFonts.balooBhaina(color: Colors.grey,fontSize: 15),),
                            ):Container();
                          },
                        ):Center(child: CircularProgressIndicator());
                      }
                  ),
                ),
              ],
            ),
          ):Container(),
        ],
      ),
    );
  }
}



class AeoUI extends StatefulWidget {
  final String username;
  final int currentState;
  final bool rememberMe;
  AeoUI({this.username,this.currentState, this.rememberMe});
  @override
  _AeoUIState createState() => _AeoUIState();
}

class _AeoUIState extends State<AeoUI> {
  String drpdwmstr = "Events";
  int _currentIndex = 0;
  TextEditingController customController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.currentState!=null){
      setState(() {
        _currentIndex=widget.currentState;
      });
    }
    if(widget.username!=null){
      setState(() {
        loggedInEmail=widget.username;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> _pageOptions=[HomePage(username: widget.username,rememberMe: widget.rememberMe,),OnGoingEvents(),BookingPage(email: widget.username,),SavedPage(email: widget.username,),UserProfileUI(widget.username,widget.rememberMe)];
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                      Colors.red,
                      Colors.redAccent,
                      Colors.red.shade400
                    ])),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        elevation: 10,
                        child: Image.asset(
                          'assets/images/drawerimage.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Welcome to OSHO\n$loggedInEmail",
                        style: GoogleFonts.aBeeZee(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0),
                      ),
                    )
                  ],
                ),
              ),
              CustomListview(
                  Icons.person,
                  " Dashboard ",
                      () =>
                  {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AeoUI(username:widget.username,rememberMe:widget.rememberMe,currentState: 4,)))
                  }),
              CustomListview(
                  Icons.rate_review,
                  "Review an event",
                      (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ReviewCard();
                            });
                  }
                  ),
              CustomListview(
                  Icons.account_balance_wallet,
                  "Wallet",
                      () =>
                  {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => WalletApp(widget.username)))
                  }),
              CustomListview(
                  Icons.subscriptions,
                  "Subscriptions",
                      () =>
                  {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SubscritionHomePage(userEmail: loggedInEmail,)))
                  }),
              CustomListview(
                  Icons.offline_bolt,
                  "LogOut",
                      () async {
                    if(!widget.rememberMe){
                      signOutGoogle();
                      loggedInEmail = null;
                      loggedInPassword=null;
                      facebookLogin.logOut();
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove('loggedInEmail');
                      prefs.remove('loggedInPassword');
                    }
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            NewLoginScreenTwo()));
                  })
            ],
          ),
        ),
        backgroundColor: Colors.grey[100],
        body:_pageOptions[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 196, 26, 61),
                  ),
                  title: Text(
                    "Home",
                    style: GoogleFonts.balooBhaina(
                      color: Color.fromARGB(255, 196, 26, 61),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.event,
                    color: Color.fromARGB(255, 196, 26, 61),
                  ),
                  title: Text(
                    "Events",
                    style: GoogleFonts.balooBhaina(
                      color: Color.fromARGB(255, 196, 26, 61),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history,
                    color: Color.fromARGB(255, 196, 26, 61),
                  ),
                  title: Text(
                    "Bookings",
                    style: GoogleFonts.balooBhaina(
                      color: Color.fromARGB(255, 196, 26, 61),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    color: Color.fromARGB(255, 196, 26, 61),
                  ),
                  title: Text("Saved",
                      style: GoogleFonts.balooBhaina(
                        color: Color.fromARGB(255, 196, 26, 61),
                      ))),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 196, 26, 61),
                  ),
                  title: Text("Profile",
                      style: GoogleFonts.balooBhaina(
                        color: Color.fromARGB(255, 196, 26, 61),
                      ))),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              debugPrint("the current page is $_currentIndex");
            
            }),
      ),
    );
  }

}
class CustomListview extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  CustomListview(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.redAccent))),
        child: InkWell(
          splashColor: Colors.redAccent,
          onTap: onTap,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.red,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ReviewCard extends StatefulWidget {
  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  final reviewController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int  _selectedEvent=0;
  String event;
  List<String> events=['Select Event'];
  List<DropdownMenuItem<int>> eventList = [
    DropdownMenuItem(
      child: new Text('Select Event',style:GoogleFonts.balooBhai(
        color: Colors.blue,
      ),),
      value: 0,
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance.collection("events").getDocuments().then((docs){
      if(docs.documents.length>0){
        for(int i=0;i<docs.documents.length;i++){
          eventList.add( DropdownMenuItem(
            child: new Text('${docs.documents.elementAt(i).data['title']}',style:GoogleFonts.balooBhai(
              color: Colors.blue,
            ),),
            value: i+1,
          ),);
          events.add(docs.documents.elementAt(i).data['title']);
        }
      }
    });
  }
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
                                  Text("Review Event",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.w600),),
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
                                      padding: const EdgeInsets.all(5.0),
                                      child: Material(
                                          elevation: 5.0,
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:18.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField(
                                                iconEnabledColor: deepRed,
                                                iconDisabledColor: deepRed,
                                                hint: new Text('Select Gender'),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  errorStyle: GoogleFonts.balooBhaina(),
                                                ),
                                                items: eventList,
                                                validator: (int value){
                                                  if(value==0){
                                                    return "Please select an Event";
                                                  }
                                                  else{
                                                    return null;
                                                  }
                                                },
                                                value: _selectedEvent,
                                                onChanged: (value) {
                                                  _formKey.currentState.validate();
                                                 setState(() {
                                                   event=events.elementAt(value);
                                                 });
                                                },
                                                isExpanded: true,
                                                style: GoogleFonts.balooBhai(fontSize: MediaQuery.of(context).size.width*0.045,color:Colors.black,fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          )
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
                        Firestore.instance.collection("events").document(event).updateData({
                          "reviews":FieldValue.arrayUnion([reviewController.text]),
                        });
                        Firestore.instance.collection("events").document(event).get().then((doc){
                          Firestore.instance.collection("events").document(event).updateData({
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
