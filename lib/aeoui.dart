import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rooms/bottomNavigationPage3.dart';
import 'package:rooms/newLoginscreen2.dart';
import 'package:rooms/subscriptioncallingpage.dart';
import 'package:rooms/userProfilePafe.dart';
import 'OnGoingEvents.dart';
import 'bottomnavigationpage2.dart';
import 'constant/constant.dart';
import 'eventOrganiser.dart';
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

class AeoUI extends StatefulWidget {
  final String username;
  AeoUI({this.username});
  @override
  _AeoUIState createState() => _AeoUIState();
}

class _AeoUIState extends State<AeoUI> {
  String msg = 'Hey Friends try this OSHO app';
  String base64Image = '';
  TextEditingController customController = new TextEditingController();
  String drpdwmstr = "Events";
  Future<String> createUserEventReview(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Review the Event"),
            content: TextField(
              controller: customController,
            ),
            actions: [
              DropdownButton<String>(
                value: drpdwmstr,
                onChanged: (String newValue) {
                  setState(() {
                    drpdwmstr = newValue;
                  });
                },
                items: <String>[
                  'Events',
                  'Event 1',
                  "Event 2",
                  "Event 3",
                  "Event 4"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              MaterialButton(
                child: Text("Submit"),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop(customController.text.toString());
                },
                elevation: 5.0,
              )
            ],
          );
        });
  }

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

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    int _currentIndex = 0;
//    final _pageoptions=[AeoUI(),SavedPage(),BottomNaviationProfile()]
    Widget image_carousel;
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(70)),
                      elevation: 10,
                      child: Image.asset(
                        'assets/images/drawerimage.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Text(
                        "OSHO",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0),
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.red,
                Colors.redAccent,
                Colors.red.shade400
              ])),
            ),
            CustomListview(
                Icons.person,
                " Dashboard ",
                () => {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => UserProfileUI(widget.username)))
                    }),
            CustomListview(
                Icons.contact_mail,
                "Event Registration",
                () => {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => EventOrganiser()))
                    }),
            CustomListview(
                Icons.rate_review,
                "Review an event",
                () => {
                      createUserEventReview(context).then((value) {
                        SnackBar mySnackbar =
                            new SnackBar(content: Text("Review Saved !"));
                        Scaffold.of(context).showSnackBar(mySnackbar);
                      })
                    }),
            CustomListview(
                Icons.account_balance_wallet,
                "Wallet",
                () => {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => WalletApp()))
                    }),
            CustomListview(
                Icons.subscriptions,
                "Subscriptions",
                () => {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SubscriptionMyApp()))
                    }),
            CustomListview(
                Icons.offline_bolt,
                "LogOut",
                () {
                  signOutGoogle();facebookLogin.logOut();
                  Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NewLoginScreenTwo()));
                    })
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: NestedScrollView(
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
                    margin: EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: _width,
                    height: _height / 18,
                    alignment: Alignment.topCenter,
                    child: TextFormField(
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(2),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.grey,
                          ),
                          hintText: "Search for Aashram, City or Location",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 13.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none)),
                    ),
                  ),
                  preferredSize: Size(_width, _height / 20)),
            ),
          ];
        },
        body: SingleChildScrollView(
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
                      builder: (BuildContext context) => OnGoingEvents()));
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
                                  BookingPage()));
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
                                  BookingPage()));
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
                                  BookingPage()));
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
                                  SubscriptionMyApp()));
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
                                  SubscriptionMyApp()));
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
      ),
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
                  "On Going Events",
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
                  "Add Events",
                  style: GoogleFonts.balooBhaina(
                    color: Color.fromARGB(255, 196, 26, 61),
                  ),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_border,
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
            if (index == 0)
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AeoUI()));
            if (index == 1)
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => OnGoingEvents()));
            if (index == 2)
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BookingPage()));
            if (index == 3)
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SavedPage()));
            if (index == 4)
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => UserProfileUI(widget.username)));
//    Navigator.of(context).push(MaterialPageRoute(
//    builder: (BuildContext context) => SavedPage()));
          }),
    );
  }

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
}

class CustomListview extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
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
