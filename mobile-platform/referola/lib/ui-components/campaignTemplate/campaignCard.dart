import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:referola/ui-components/campaignTemplate/campaignDetailedPage.dart';

class CampaignCard extends StatefulWidget {
  final DocumentSnapshot campaignData;
  CampaignCard({@required this.campaignData});
  @override
  _CampaignCardState createState() => _CampaignCardState();
}

class _CampaignCardState extends State<CampaignCard> {
  DocumentSnapshot campaignCard;
  int packageSelIndex = 0;
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
      campaignCard = widget.campaignData;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CampaignDetailed(campaignData: widget.campaignData, isRefferedByUserId: null,) ));
      },
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 1.0, spreadRadius: 1.0)
        ]),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeInImage(
                  fit: BoxFit.fitWidth,
                  height: MediaQuery.of(context).size.width * 0.68,
                  width: MediaQuery.of(context).size.width,
                  placeholder: AssetImage("./assets/images/placeholder.png"),
                  image: CachedNetworkImageProvider(
                    campaignCard.data['campainBannerImgUrl'],
                  )),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      campaignCard.data['campainTitle'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      campaignCard.data['campainSubTitle'],
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
                          campaignCard.data['packages'][packageSelIndex]['packageAmount']
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
                          ((campaignCard.data['packages'][packageSelIndex]['packageAmount'] -
                                  (campaignCard.data['packages'][packageSelIndex]
                                              ['packageAmount'] *
                                          campaignCard.data['packages'][packageSelIndex]
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
                          child: Text(campaignCard.data['packages'][packageSelIndex]
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
                      campaignCard.data['campainDescription'],
                      style: TextStyle(color: Colors.blueGrey),
                    )
                  ],
                ),
              )
            ],
          ),
        )),
    );
  }
}

