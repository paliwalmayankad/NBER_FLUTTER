class MyRideModels{

  String status;
  String message;
  String response;

  List<RideData> bookingdata;
  String username;

  MyRideModels.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["response Code"];

      this.message = obj["message"];
      bookingdata = (obj['data'] as List).map((i) => RideData.fromJson(i)).toList();

    }


  }




}

class RideData{

  final  String _id;
  final  String user_id;
  final  String driver_id;
  final  String vehicleNumber;
  final  String fromLat;
  final  String fromLon;
  final  String fromAddress;
  final  String toLat;
  final  String toLon ;
  final  String toAddress;
  final  String startTimestamp;
  final  String stopTimestamp;
  final  String mac_id;
  final  String remark;
  final  String ipAddress;
  final  String token_id;
  final  String driverLat;
  final  String driverLon;
  final  String createdAt;
  final  String updatedAt;
  final  int __v;



  const RideData(this._id, this.user_id,this.driver_id, this.vehicleNumber,this.fromLat,final  this.fromLon, this.fromAddress, this.toLat,
  this.toLon, this.toAddress, this.startTimestamp,
  this.stopTimestamp,
  this.mac_id,
  this.remark,
  this.ipAddress,
  this.token_id,
  this.driverLat,
  this.driverLon,
  this.createdAt,
  this.updatedAt,
  this. __v);

  RideData.fromJson(Map jsonMap)
      : _id = jsonMap['_id'],
        user_id = jsonMap['user_id'],
        driver_id = jsonMap['driver_id'],
        vehicleNumber = jsonMap['vehicleNumber'],
        fromLat = jsonMap['fromLat'],
        fromLon = jsonMap['fromLon'],
        fromAddress = jsonMap['fromAddress'],
        toLat = jsonMap['toLat'],
        toLon = jsonMap['toLon'],
        toAddress = jsonMap['toAddress'],
        startTimestamp = jsonMap['startTimestamp'],
        stopTimestamp = jsonMap['stopTimestamp'],
        mac_id = jsonMap['mac_id'],
        remark = jsonMap['remark'],
        ipAddress = jsonMap['ipAddress'],
        token_id = jsonMap['token_id'],
        driverLat = jsonMap['driverLat'],
        driverLon = jsonMap['driverLon'],
        createdAt = jsonMap['createdAt'],
        updatedAt = jsonMap['updatedAt'],
        __v = jsonMap['__v'];



}