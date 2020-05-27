import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rooms/userProfilePafe.dart';

void main() => runApp(MaterialApp(
      home: Usercalling(),
    ));

class Usercalling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfileUI(),
    );
  }
}
