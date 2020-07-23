import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyCampaigns extends StatefulWidget {
  final DocumentSnapshot businessData;
  MyCampaigns({@required this.businessData});
  @override
  _MyCampaignsState createState() => _MyCampaignsState();
}

class _MyCampaignsState extends State<MyCampaigns> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("My Campaign's", style: TextStyle(
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.bold,
                fontSize: 30.0
              ),),
              SizedBox(
                height: 20.0,
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, i){
                  return Container();
                }
              )
            ],
          ),
        )
      ],
    );
  }
}