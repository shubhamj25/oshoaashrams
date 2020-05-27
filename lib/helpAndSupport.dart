import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: HelpAndSUpport(title: 'Flutter Demo Home Page'),
    );
  }
}

class HelpAndSUpport extends StatefulWidget {
  HelpAndSUpport({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HelpAndSUpportState createState() => _HelpAndSUpportState();
}

class _HelpAndSUpportState extends State<HelpAndSUpport> {
  TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Help and Support",
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/1.PNG',
                    height: 300.0,
                    width: 300.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Column(
                        children: [
                          DataTable(columns: <DataColumn>[
                            DataColumn(
                                label: Text(
                              "Information",
                              style:
                                  GoogleFonts.balooBhaina(color: Colors.black),
                            )),
                            DataColumn(
                                label: Text("Details",
                                    style: GoogleFonts.balooBhaina(
                                        color: Colors.black)))
                          ], rows: <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  "Name",
                                  style: GoogleFonts.balooBhaina(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )),
                                DataCell(Text(
                                  "Smith jane",
                                  style: GoogleFonts.balooBhaina(
                                      fontWeight: FontWeight.w100,
                                      color: Colors.black),
                                ))
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  "Phone Number",
                                  style: GoogleFonts.balooBhaina(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )),
                                DataCell(Text(
                                  "987654321",
                                  style: GoogleFonts.balooBhaina(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ))
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  "Gender",
                                  style: GoogleFonts.balooBhaina(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )),
                                DataCell(Text(
                                  "Female",
                                  style: GoogleFonts.balooBhaina(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ))
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  "Email",
                                  style: GoogleFonts.balooBhaina(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )),
                                DataCell(Text(
                                  "samithjane@gmail.com",
                                  style: GoogleFonts.balooBhaina(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ))
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Describe your issue here",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextField(
                    decoration: new InputDecoration(
                      labelText: "Type here",
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
                  FlatButton(
                    color: Color.fromRGBO(253, 11, 23, 1),
                    onPressed: () {
                      Fluttertoast.showToast(
                        msg: "Review Submitted",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.balooBhaina(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromRGBO(253, 11, 23, 1),
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ],
              ),
            ),
          ],
        )

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
