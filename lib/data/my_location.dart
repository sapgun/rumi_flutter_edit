import 'package:geolocator/geolocator.dart';
class MyLocation{
  late double latitude2;
  late double longitude2;

  Future<void> getMyCurrentLocation() async{
    try {
      Position position = await Geolocator.
      getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude2 = position.latitude;
      longitude2 = position.longitude;
      print(position);
    }catch(e){
      print("인터넷 연결 문제");
    }
  }
}