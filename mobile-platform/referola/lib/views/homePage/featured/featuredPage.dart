import 'package:flutter/material.dart';
import 'package:referola/logic/auth/accountFun.dart';
import 'package:referola/logic/homeLogic/featuredLogic.dart';
import 'package:referola/ui-components/campaignTemplate/campaignCard.dart';

final FeaturedLoadLogic featuredLoadLogic = FeaturedLoadLogic();

class FeaturedPage extends StatefulWidget {
  @override
  _FeaturedPageState createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  ScrollController _scrollController = ScrollController();
  bool getmoreflag = false;

  bool isLoading = false;
  bool isLoadingMore = false;

  
  void getMoreData() async {
    setState(() {
      isLoadingMore = true;
    });
    await featuredLoadLogic.loadMoreData(context);
    setState(() {
      isLoadingMore = false;
    });
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    await featuredLoadLogic.loadData(context);
    setState(() {
      isLoading = false;
    });
  }



  @override
  void initState() {
    getData();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.70;
      if (maxScroll - currentScroll <= delta) {
        //Load data more data
        if (!getmoreflag) {
          setState(() {
            getmoreflag = true;
          });
          getMoreData();
        }
      }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text("Featured", style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(locData.address[0].name + ", "+locData.address[0].subLocality+", "+locData.address[0].locality+", "+locData.address[0].subAdministrativeArea+", "+locData.address[0].administrativeArea+", "+locData.address[0].country+", "+locData.address[0].postalCode)
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          isLoading ? Container(
            height: MediaQuery.of(context).size.height*0.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : Container(
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: featuredLoadLogic.data.length+1,
              itemBuilder: (context, i){
                if(i == featuredLoadLogic.data.length){
                  if(isLoadingMore){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SizedBox();
                }
                return CampaignCard(
                  campaignData: featuredLoadLogic.data[i],
                );
              },  
            ),
          )
        ],
      )
    );
  }
}