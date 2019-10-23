class NotificationModels{
  String status;
  String message;
  String response;
  NotificationData data;
List<NotificationData> notificationdata;
  String username;

  NotificationModels.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["Response Code"];

      this.message = obj["message"];
      notificationdata = (obj['data'] as List).map((i) => NotificationData.fromJson(i)).toList();
      //   data= new Userdata.map(obj["data"]);

    }


  }




}
// ignore: non_constant_identifier_names
 class NotificationData{

final  String _id;
final  String category;
final  String message;
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
  const NotificationData(this._id, this.category,this.message, this.createdAt,this.updatedAt, this.__v);

  NotificationData.fromJson(Map jsonMap)
      : _id = jsonMap['_id'],
        category = jsonMap['category'], message = jsonMap['message'],
        createdAt = jsonMap['createdAt'],
     updatedAt = jsonMap['updatedAt'],
        __v = jsonMap['__v'];


}