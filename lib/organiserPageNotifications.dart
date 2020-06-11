import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rooms/aeoui.dart';

class OrganiserNotifications extends StatefulWidget {
  @override
  _OrganiserNotificationsState createState() => _OrganiserNotificationsState();
}

class _OrganiserNotificationsState extends State<OrganiserNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Notifications"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("notifications").document(loggedInEmail).collection("notifications_$loggedInEmail").orderBy('timestamp',descending: true).snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData?Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(child: Container(width:27,height: 27,child: CircularProgressIndicator(strokeWidth: 2,backgroundColor: Colors.white,))),
          ):ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
             return  !snapshot.data.documents.elementAt(index).data['seen']?Padding(
               padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Card(
                  elevation: 8.0,
                  child: ListTile(
                    onTap: () {},
                    trailing: IconButton(icon: Icon(Icons.delete,color: Colors.blueAccent,),onPressed: (){
                      Firestore.instance.collection("notifications").document(loggedInEmail).collection("notifications_$loggedInEmail").document(snapshot.data.documents.elementAt(index).data['id'].toString()).updateData({
                        "seen":true,
                      });
                    },),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:4.0,vertical: 16.0),
                      child: Text(snapshot.data.documents.elementAt(index).data['message']),
                    ),
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/OshoLogo.png'),
                    ),
                  ),
                ),
              ):Container();
            },
          );
        }
      ),
    );
  }
}
