class MapGadiApi{

  String status;
  String message;
  String response;
  MapGadiApi data;
  List<GadiData> mapgadidata;
  String username;

  MapGadiApi.map(dynamic obj) {
  if (obj != null) {
  this.status = obj["response code"];



  mapgadidata = (obj['message'] as List).map((i) => GadiData.fromJson(i)).toList();


  }


  }




  }
// ignore: non_constant_identifier_names
  class GadiData{
  // ignore: non_constant_identifier_names
 final String updated_lat;
  // ignore: non_constant_identifier_names
 final String updated_lon;
 final String user_id;
 final String vehicle_type_id;

  const GadiData(this.updated_lat, this.updated_lon,this.user_id, this.vehicle_type_id);

  GadiData.fromJson(Map jsonMap)
      : updated_lat = jsonMap['updatedLat'],
        updated_lon = jsonMap['updatedLon'],
        user_id = jsonMap['user_id'],
        vehicle_type_id = jsonMap['vehicleType_id']
       ;


  }




