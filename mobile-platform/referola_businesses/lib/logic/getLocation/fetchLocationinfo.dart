import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';
import 'package:android_intent/android_intent.dart';


class LocData{
  double lat;
  double long;


  LocData({this.lat, this.long});
}

class GetLocation{
  Future<LocData> fetch(BuildContext context)async{
    Position position;
    bool _serviceEnabled;
    Location location = new Location();
    
    // if(await Permission.location.isDenied || await Permission.location.isRestricted || await Permission.location.isPermanentlyDenied){
    //   CustomAlertBox().load(context, "Please Turn On your Location", "You need to turn on your Location for this!");
    //   await Permission.location.request().then((PermissionStatus status)async{
    //     if(status.isGranted){
    //       Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    //       if(await geolocator.isLocationServiceEnabled()){
    //         position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //         placeMark = await geolocator.placemarkFromPosition(position);
    //       }
    //     }return LocData(lat: position.latitude, long: position.longitude, placeMark: placeMark);
    //   });
    // }

    // if(await Permission.location.isGranted){
    //   Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    //   if(await geolocator.isLocationServiceEnabled()){
    //     position = await geolocator.getCurrentPosition();
    //     placeMark = await geolocator.placemarkFromPosition(position);
    //   }
    // }

      
     

      try{
        position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final coordinates = new Coordinates(position.latitude, position.longitude);
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        print(first.addressLine);
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          CustomAlertBox().load(context, "Please Turn On your Location", "You need to turn on your Location for this!");
        }
        if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          CustomAlertBox().load(context, "Please Turn On your Location", "You need to turn on your Location for this!");
        }
      
        



   
  }
   return LocData(lat: position.latitude, long: position.longitude);
}

}