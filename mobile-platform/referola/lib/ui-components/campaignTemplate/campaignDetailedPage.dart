import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:referola/ui-components/buttons/longButton.dart';
import 'package:referola/views/payments/checkOut.dart';

class CampaignDetailed extends StatefulWidget {
  final DocumentSnapshot campaignData;
  final String isRefferedByUserId;
  CampaignDetailed({@required this.campaignData, @required this.isRefferedByUserId});
  @override
  _CampaignDetailedState createState() => _CampaignDetailedState();
}

class _CampaignDetailedState extends State<CampaignDetailed> {
  int packageSelIndex = 0;
  int userSelectedPackageIndex;
  @override
  void initState() {
    int lessPackageIndex = 0;
    double recordedLessPrice = 99999999999;
    for(int i=0; i<widget.campaignData.data['packages'].length; i++){
      if(((widget.campaignData.data['packages'][i]['packageAmount'] - (widget.campaignData.data['packages'][i]['packageAmount'] * widget.campaignData.data['packages'][i]['packageDiscount'])/100)) < recordedLessPrice){
        lessPackageIndex = i;
        recordedLessPrice = ((widget.campaignData.data['packages'][i]['packageAmount'] - (widget.campaignData.data['packages'][i]['packageAmount'] * widget.campaignData.data['packages'][i]['packageDiscount'])/100));
      }
    }
    setState(() {
      packageSelIndex = lessPackageIndex;
      userSelectedPackageIndex = packageSelIndex;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10.0),
        child: CustomLongButton().loadButton(context, "Buy Now", (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CheckOutPage(campaignData: widget.campaignData, isRefferedByUser: widget.isRefferedByUserId, packageSelected: userSelectedPackageIndex,)));
        })
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 280.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  // title: Text("Collapsing Toolbar",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 16.0,
                  //     )),
                  background: FadeInImage(
                    fit: BoxFit.fitWidth,
                    height: MediaQuery.of(context).size.width * 0.68,
                    width: MediaQuery.of(context).size.width,
                    placeholder: AssetImage("./assets/images/placeholder.png"),
                    image: CachedNetworkImageProvider(
                      widget.campaignData.data['campainBannerImgUrl'],
                    )
                  ),),
            ),
          ];
        },
        body: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.campaignData.data['campainTitle'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      widget.campaignData.data['campainSubTitle'],
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.dollarSign),
                        Text(
                          widget.campaignData.data['packages'][userSelectedPackageIndex]['packageAmount']
                              .toString(),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(" From "),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          FontAwesomeIcons.dollarSign,
                          size: 17.0,
                          color: Colors.green,
                        ),
                        Text(
                          ((widget.campaignData.data['packages'][userSelectedPackageIndex]['packageAmount'] -
                                  (widget.campaignData.data['packages'][userSelectedPackageIndex]
                                              ['packageAmount'] *
                                          widget.campaignData.data['packages'][userSelectedPackageIndex]
                                              ['packageDiscount']) /
                                      100).round())
                              .toString(),
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 2.0, bottom: 2.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.green.withOpacity(0.75)),
                          child: Text(widget.campaignData.data['packages'][packageSelIndex]
                                      ['packageDiscount']
                                  .toString() +
                              "% OFF"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.campaignData.data['campainDescription'],
                      style: TextStyle(color: Colors.blueGrey),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(),
                    Text("Packages", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey
                    ),),
                    SizedBox(
                      height: 10.0,
                    ),

                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: widget.campaignData.data['packages'].length,
                      itemBuilder: (context, i){  
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Radio(
                                    groupValue: userSelectedPackageIndex,
                                    value: i,
                                    onChanged: (int val){
                                      setState(() {
                                        userSelectedPackageIndex = i;
                                      });
                                      print(userSelectedPackageIndex);
                                    },

                                  ),
                                  Text(widget.campaignData.data['packages'][i]['packageTitle'], style: TextStyle(
                                    fontSize: 17.0
                                  ),)
                                ],
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.dollarSign, color: Colors.grey, size: 15.0,),
                                              Text(
                                                widget.campaignData.data['packages'][i]['packageAmount']
                                                    .toString(),
                                                style: TextStyle(
                                                    decoration: TextDecoration.lineThrough,
                                                    fontSize: 18.0,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(" From "),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Icon(
                                                FontAwesomeIcons.dollarSign,
                                                size: 17.0,
                                                color: Colors.green,
                                              ),
                                              Text(
                                                ((widget.campaignData.data['packages'][i]['packageAmount'] -
                                                        (widget.campaignData.data['packages'][i]
                                                                    ['packageAmount'] *
                                                                widget.campaignData.data['packages'][i]
                                                                    ['packageDiscount']) /
                                                            100).round())
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25.0),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 15.0, right: 15.0, top: 2.0, bottom: 2.0),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    color: Colors.green.withOpacity(0.75)),
                                                child: Text(widget.campaignData.data['packages'][i]
                                                            ['packageDiscount']
                                                        .toString() +
                                                    "% OFF"),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Divider(
                                color: Colors.blueGrey,
                                height: 2.0,
                              ),
                            ],
                          )
                        );
                      }
                    )




                  ],
                ),
              )
          ],
        )
      ),
    );
  }
}