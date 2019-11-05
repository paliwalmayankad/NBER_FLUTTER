class VehicletypeModels{
  String status;
  String message;
  String response;
  VehicleTypeDatases data;
  List<VehicleTypeDatases> vehicledata;
  String username;

  VehicletypeModels.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["Response Code"];

      this.message = obj["message"];
      vehicledata = (obj['data'] as List).map((i) => VehicleTypeDatases.fromJson(i)).toList();
      //   data= new Userdata.map(obj["data"]);

    }


  }




}
// ignore: non_constant_identifier_names
class VehicleTypeDatases{

  final  String id;
  final  String type;
  final  String capacity;
  final  double baseFare;
  final  double extra;
  final  String category;
  final  double userCancellationCharge;
  final  double driverCancellationCharge;
  final  double waitingCharge;
  final  double tollCharge;
  final  double surcharge;
  final  double tax;
  final  String createdAt;
  final  String updatedAt;
  final  int __v;


  /*NotificationData.map(dynamic res){
    if(res!=null){
      this.access_token=res["access_token"];
      this.user_id=res["user_id"];
      this.name=res["name"];
    }
    else{

    }
  }*/
  const VehicleTypeDatases(this.id,
      this.type,
      this.capacity,
      this.baseFare,
      this.extra,
      this.category,
      this.userCancellationCharge,
      this.driverCancellationCharge,
      this.waitingCharge,
      this.tollCharge,
      this.surcharge,
      this.tax,
      this.createdAt,
      this.updatedAt,
      this.__v);

  VehicleTypeDatases.fromJson(Map jsonMap)
      : id = jsonMap['_id'],
        type = jsonMap['type'],
        capacity = jsonMap['capacity'],
        baseFare = jsonMap['baseFare'],
        extra = jsonMap['extra'],
        category = jsonMap['category'],
        userCancellationCharge = jsonMap['userCancellationCharge'],
        driverCancellationCharge = jsonMap['driverCancellationCharge'],
        waitingCharge = jsonMap['waitingCharge'],
        tollCharge = jsonMap['tollCharge'],
        surcharge = jsonMap['surcharge'],
        tax = jsonMap['tax'],
        createdAt = jsonMap['createdAt'],
        updatedAt = jsonMap['updatedAt'],
        __v = jsonMap['__v'];



}