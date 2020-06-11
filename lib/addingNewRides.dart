import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rooms/aeoui.dart';
import 'package:rooms/widgets/custom_icons_icons.dart';

class DropDown extends StatefulWidget {
  final String userEmail,userName,gender,age,img;
  DropDown({this.userEmail,this.userName,this.gender,this.age,this.img}) : super();
  @override
  DropDownState createState() => DropDownState();
}


class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Car'),
      Company(2, 'Bus'),
      Company(3, 'Cab'),
      Company(4, 'Self'),
    ];
  }
}

class DropDownState extends State<DropDown> {
  String _selectedDate = 'From';
  String _selectedDateTwo = 'To';
  RangeValues values = RangeValues(1, 100);
  RangeLabels labels = RangeLabels('1', '100');

  var rating;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2222),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
  }

  Future<void> _selectDateTwo(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2222),
    );
    if (d != null)
      setState(() {
        _selectedDateTwo = new DateFormat.yMMMMd("en_US").format(d);
      });
  }

  //
  TextEditingController _controller = new TextEditingController();
  TextEditingController _startController = new TextEditingController();
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    Firestore.instance.collection("cities").getDocuments().then((docs){
      for (int i = 0; i < docs.documents.length; i++) {
        locations.add(docs.documents.elementAt(i).data['name'].toString());
      }
    });
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10),
                  child: company.name=="Car"?Icon(Icons.directions_car,color: Colors.blueAccent,):company.name=="Bus"?Icon(Icons.directions_bus,color: Colors.blueAccent):company.name=="Cab"?Icon(Icons.local_taxi,color: Colors.blueAccent):Icon(Icons.person_outline,color: Colors.blueAccent),
                ),
                Text(company.name,style: GoogleFonts.aBeeZee(),),
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }
  List<String> locations = [];

  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          body: new Container(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key:_formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Create",
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30.0),
                                ),
                                Text(
                                  "Ride",
                                  style: GoogleFonts.aBeeZee(
                                      color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 25.0),
                                ),
                              ],
                            ),

                            FloatingActionButton(
                              heroTag: 2424,
                              backgroundColor: Colors.redAccent,
                              child:Icon(Icons.reply,color: Colors.white,),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:18.0,vertical: 8.0),
                        child: Material(
                          elevation: 12.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: TextFormField(
                            validator: (val){
                              if(val==""||val==null){
                                return "Please enter a city name";
                              }
                              else if(!locations.contains(val.substring(0,1).toUpperCase()+val.substring(1,val.length))){
                                return "Invalid City Name";
                              }
                              else{
                                return null;
                              }
                            },
                            onChanged: (val){
                              _formKey.currentState.validate();
                            },
                            decoration: new InputDecoration(
                              labelText: "Starting City",
                              errorStyle: GoogleFonts.balooBhaina(),
                              labelStyle: GoogleFonts.balooBhaina(fontSize: 16),
                              suffixIcon: Icon(Icons.gps_fixed,color: Colors.blueAccent,),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 8.0),
                            ),
                            controller: _startController,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:18.0,vertical: 8.0),
                        child: Material(
                          elevation: 12.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: TextFormField(
                            validator: (val){
                              if(val==""||val==null){
                                return "Please enter a city name";
                              }
                              else if(!locations.contains(val.substring(0,1).toUpperCase()+val.substring(1,val.length))){
                                return "Invalid City Name";
                              }
                              else{
                                return null;
                              }
                            },
                            onChanged: (val){
                              _formKey.currentState.validate();
                            },
                            decoration: new InputDecoration(
                              labelText: "In which City are you going?",
                              border: InputBorder.none,
                              errorStyle: GoogleFonts.balooBhaina(),
                              labelStyle: GoogleFonts.balooBhaina(fontSize: 16),
                              suffixIcon: IconButton(icon: Icon(CustomIcons.search_location,color: Colors.blueAccent,),
                              onPressed: (){

                              },
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 8.0),
                            ),
                            controller: _controller,
                          ),
                        ),
                      ),
                      Text(
                        "Select a mode of transport",
                        style: GoogleFonts.balooBhaina(
                            fontWeight: FontWeight.w400, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 14.0,
                      ),
                      DropdownButtonHideUnderline(
                        child: Material(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.7,
                            child: DropdownButtonFormField(
                              value: _selectedCompany,
                              items: _dropdownMenuItems,
                              onChanged: onChangeDropdownItem,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Text(_selectedDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF000000))),
                            onTap: () {
                              _selectDate(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            tooltip: 'Tap to open date picker',
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
//                        TextField(

//                        ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            child: Text(_selectedDateTwo,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF000000))),
                            onTap: () {
                              _selectDateTwo(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            tooltip: 'Tap to open date picker',
                            onPressed: () {
                              _selectDateTwo(context);
                            },
                          ),
//                        TextField(

//                        ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Select the range(in KM) ",
                        style: GoogleFonts.balooBhaina(
                            fontWeight: FontWeight.w400, fontSize: 20.0),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RangeSlider(
                          min: 1,
                          max: 100,
                          values: values,
                          divisions: 5,
                          labels: labels,
                          onChanged: (value) {
                            print('START: ${value.start}, END: ${value.end}');
                            setState(() {
                              values = value;
                              labels = RangeLabels('${value.start.toInt().toString()}',
                                  '${value.end.toInt().toString()}');
                            });
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            if((_selectedDate!="From")&&(_selectedDateTwo!="To")){
                              if(_formKey.currentState.validate()){
                                List<String> ridePersons=[];
                                ridePersons.add(loggedInEmail);
                                Firestore.instance.collection("rides").document("${widget.userName}").setData({
                                  "travellingFrom":_startController.text.trim(),
                                  "travellingTo":_controller.text.trim(),
                                  "image":widget.img,
                                  "name":widget.userName,
                                  "email":widget.userEmail,
                                  "age":widget.age,
                                  "gender":widget.gender,
                                  "modeOfTravel":_selectedCompany.name,
                                  "range":values.end,
                                  "start":_selectedDate,
                                  "end":_selectedDateTwo,
                                  "persons":ridePersons,
                                  "status":"active"
                                }).then((val){
                                  Fluttertoast.showToast(
                                      msg: "Ride Created",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Color.fromRGBO(253, 11, 23, 1),
                                      textColor: Colors.white);
                                  Navigator.pop(context);
                                });
                                Fluttertoast.showToast(
                                    msg: "Ride Created",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Color.fromRGBO(253, 11, 23, 1),
                                    textColor: Colors.white);
                              }
                            }
                            else{
                              Flushbar(
                                shouldIconPulse: true,
                                isDismissible: true,
                                flushbarPosition: FlushbarPosition.TOP,
                                titleText: Text("Ride not Created",style: GoogleFonts.aBeeZee(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17.0),),
                                messageText: Text("Missing Starting / Ending Dates",style: GoogleFonts.aBeeZee(color: Colors.white,fontSize: 15.0)),
                                duration: Duration(seconds: 3),
                                icon: Icon(Icons.error,color: Colors.white,),
                                backgroundColor:  deepRed,
                              )..show(context);
                            }
                          },
                          color: Color.fromRGBO(253, 11, 23, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Create Ride',
                              style: GoogleFonts.balooBhaina(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
