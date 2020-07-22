import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:referola_businesses/logic/auth/accountFun.dart';
import 'package:referola_businesses/views/auth-ui/completeBusinessProfile.dart';
import 'package:referola_businesses/views/myBusinesses/businessDashboard/dashboard.dart';
import 'package:referola_businesses/views/myBusinesses/userAtBusinessLoc.dart';

class MyBusinesses extends StatefulWidget {
  @override
  _MyBusinessesState createState() => _MyBusinessesState();
}

class _MyBusinessesState extends State<MyBusinesses> {
  final BusinessesFun businessesFun = BusinessesFun();
  
  ScrollController _scrollController = ScrollController();
  bool getmoreflag = false;

  bool isLoading = false;
  bool isLoadingMore = false;

  onLoadActivity()async{
    setState(() {
      isLoading = true;
    });
    await businessesFun.loadBusinesses(context);
    setState(() {
      isLoading = false;
    });
  } 

  loadMoreData()async{
    setState(() {
      isLoadingMore = true;
    });
    await businessesFun.loadMoreBusinesses(context);
    setState(() {
      isLoadingMore = false;
      getmoreflag = false;
    });
  }

  addBusinessFun()async{
    bool shopLocRes = false;
    await Navigator.push(context, MaterialPageRoute(builder: (context)=> UserAtBusinessLocation(atLoc: (val){
      setState(() {
        shopLocRes = val;
      });
    },)));

    if(shopLocRes){
      bool res = false;
      await Navigator.push(context, MaterialPageRoute(builder: (context)=> AddBusinessProfile(added: (bool value) { 
        setState(() {
          res = value;
        });
      },)));

      if(res){
        onLoadActivity();
      }
    }

    
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
              addBusinessFun();
            },
          )
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ListView(
        controller: _scrollController,
        children: <Widget>[
          businessesFun.businesses.length == 0 ? InkWell(
            onTap: (){
              addBusinessFun();
            },
            child: Container(
              height: 200.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.plus, color: Colors.grey,),
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
            itemCount: businessesFun.businesses.length + 1,
            itemBuilder: (context, i){
              if(i == businessesFun.businesses.length){
                if(isLoadingMore){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox();
              }
              return ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> BusinessDashboard(businessData: businessesFun.businesses[i],) ));
                },
                leading: Icon(FontAwesomeIcons.storeAlt),
                title: Text(businessesFun.businesses[i].data['businessTitle']),
                subtitle: Text(businessesFun.businesses[i].data['businessShortDescription']),
              );
            }
          )
        ],
      ),
    );
  }
}