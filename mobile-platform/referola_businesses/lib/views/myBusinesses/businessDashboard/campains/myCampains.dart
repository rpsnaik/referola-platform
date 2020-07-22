import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:referola_businesses/logic/auth/accountFun.dart';
import 'package:referola_businesses/views/myBusinesses/businessDashboard/campains/addCampains.dart';
import '../../../../logic/auth/accountFun.dart';


class MyCampains extends StatefulWidget {
  @override
  _MyCampainsState createState() => _MyCampainsState();
}

class _MyCampainsState extends State<MyCampains> {
  final CampainFun campainFun = CampainFun();
  
  ScrollController _scrollController = ScrollController();
  bool getmoreflag = false;

  bool isLoading = false;
  bool isLoadingMore = false;

  onLoadActivity()async{
    setState(() {
      isLoading = true;
    });
    await campainFun.loadCampains(context);
    setState(() {
      isLoading = false;
    });
  } 

  loadMoreData()async{
    setState(() {
      isLoadingMore = true;
    });
    await campainFun.loadMoreCampains(context);
    setState(() {
      isLoadingMore = false;
      getmoreflag = false;
    });
  }

  addCampainFun()async{
    
    await Navigator.push(context, MaterialPageRoute(builder: (context) => AddCampains()));

    // if(shopLocRes){
    //   bool res = false;
    //   await Navigator.push(context, MaterialPageRoute(builder: (context)=> AddBusinessProfile(added: (bool value) { 
    //     setState(() {
    //       res = value;
    //     });
    //   },)));

    //   if(res){
    //     onLoadActivity();
    //   }
    // }

    
  }

  @override
  void initState() {
    onLoadActivity();
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
          loadMoreData();
        }
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Businesses", style: TextStyle(
          fontFamily: "Nunito Sans Bold"
        ),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              addCampainFun();
            },
          )
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ListView(
        controller: _scrollController,
        children: <Widget>[
          campainFun.campains.length == 0 ? InkWell(
            onTap: (){
              addCampainFun();
            },
            child: Container(
              height: 200.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Add New Businesses", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                    ),)
                  ],
                ),
              ),
            ),
          ): ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: campainFun.campains.length + 1,
            itemBuilder: (context, i){
              if(i == campainFun.campains.length){
                if(isLoadingMore){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox();
              }
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.storeAlt),
                  title: Text(campainFun.campains[i].data['campainTitle']),
                  subtitle: Text(campainFun.campains[i].data['campainSubTitle']),
                ),
              );
            }
          )
        ],
      ),
    );
  }
}