import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DropDown extends StatefulWidget {
  DropDown() : super();

  final String title = "DropDown Demo";

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
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
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

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          backgroundColor: Colors.red,
          title: new Text("Create your ride"),
        ),
        body: new Container(
          child: Center(
            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    decoration: new InputDecoration(
                      labelText: "In which City are you going?",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    controller: _controller,
                    onSubmitted: (text) => print(_controller.text),
                  ),
                ),
                Text(
                  "Select a mode of transport",
                  style: GoogleFonts.balooBhaina(
                      fontWeight: FontWeight.w400, fontSize: 20.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                DropdownButton(
                  value: _selectedCompany,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Selected: ${_selectedCompany.name}',
                  style: GoogleFonts.balooBhaina(
                      fontWeight: FontWeight.w400, fontSize: 20.0),
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
                SizedBox(
                  height: 30.0,
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
                  height: 30.0,
                ),
                Text(
                  "Select the range(in KM) ",
                  style: GoogleFonts.balooBhaina(
                      fontWeight: FontWeight.w400, fontSize: 20.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RangeSlider(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "Ride Created",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Color.fromRGBO(253, 11, 23, 1),
                          textColor: Colors.white);
                    },
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Color.fromRGBO(253, 11, 23, 1),
                    child: Text(
                      'Send Request',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
