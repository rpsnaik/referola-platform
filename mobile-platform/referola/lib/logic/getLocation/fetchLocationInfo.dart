import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';


class LocData{
  double lat;
  double long;
  List<Placemark> address;

  LocData({this.lat, this.long, this.address});
}

class GetLocation{
  Future<LocData> fetch(BuildContext context)async{
    Location location = Location();
    LocationData _locationData;
    LocationLogic locationLogic = LocationLogic();
    List currAddress;

    if(await locationLogic.verifyPermission()){
      _locationData = await location.getLocation();
    }
    
    currAddress = await Geolocator().placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);  
    print(currAddress);
    return LocData(
      lat: _locationData.latitude,
      long: _locationData.longitude,
      address: currAddress
    );
  }
}

class LocationLogic{
  Location location = new Location();

  Future<bool> verifyPermission()async{
    
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied ) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return _serviceEnabled;
  }

}