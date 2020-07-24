import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:referola_businesses/views/myBusinesses/myCampaigns/addCampaign.dart';

class MyCampaigns extends StatefulWidget {
  final DocumentSnapshot businessData;
  MyCampaigns({@required this.businessData});
  @override
  _MyCampaignsState createState() => _MyCampaignsState();
}

class _MyCampaignsState extends State<MyCampaigns> {
  Firestore firestore = Firestore.instance;
  List<DocumentSnapshot> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();

  final StreamController<List<DocumentSnapshot>> _controller = StreamController<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get _streamController => _controller.stream;

  @override
  void initState() {
    super.initState();
    getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
      }
    });
  }

  getProducts() async {
    if (!hasMore) {
      print('No More Campaings');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('campaigns')
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await firestore
          .collection('campaigns')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();
      print(1);
    }
    if (querySnapshot.documents.length < documentLimit) {
      hasMore = false;
    }

    if(querySnapshot.documents.length > 0){
      lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];
    }

    

    products.addAll(querySnapshot.documents);
    _controller.sink.add(products);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon((Icons.add)),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddCampaign(businessData: widget.businessData,)));
        },
      ),
      body: ListView(
        primary: true,
        shrinkWrap: false,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("My Campaigns", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0
                ),)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder<List<DocumentSnapshot>>(
                    stream: _streamController,
                    builder: (sContext, snapshot) {
                      if (snapshot.hasData && snapshot.data.length > 0) {
                        return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.all(5),
                              title: Text(snapshot.data[index].data['campainTitle']),
                              subtitle: Text(snapshot.data[index].data['campainDescription']),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text('No Campaigns'),
                        );
                      }
                    },
                  ),
                
              isLoading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      color: Colors.yellowAccent,
                      child: Text(
                        'Loading',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container()
            ]),
          )
        ],
      )
    );
  }
}