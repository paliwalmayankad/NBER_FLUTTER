import 'package:cloud_firestore/cloud_firestore.dart';

class MapGadiApi{

  String status;
  String message;
  String response;
  MapGadiApi data;
  List<GadiData> mapgadidata;
  String username;

  MapGadiApi.documentSnapShot(dynamic obj) {
  if (obj != null) {




  mapgadidata = (obj as List).map((i) => GadiData.documentSnapShot(i)).toList();


  }


  }




  }
// ignore: non_constant_identifier_names
class GadiData{
  final String updated_lat;
  // ignore: non_constant_identifier_names
  final String updated_lon;
  final String user_id;
  final String vehicle_type_id;
  // ignore: non_constant_identifier_names
  final String documentid;
  // ignore: non_constant_identifier_names


  const GadiData(this.updated_lat, this.updated_lon, this.user_id, this.vehicle_type_id, this.documentid );

  GadiData.documentSnapShot(dynamic jsonMap)
      : documentid = jsonMap.documentID,
       updated_lat = jsonMap.data['driver_lat'],
  updated_lon = jsonMap.data['driver_lng'],
  user_id = jsonMap.data['user_id'],
  vehicle_type_id = jsonMap.data['vehicle_type_id']
  ;






}





