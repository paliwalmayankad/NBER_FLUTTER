class RegisterModel{
  String status;
  String message;
  String response;
  Userdata data;

  String username;

  RegisterModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["Response Code"];

      this.message = obj["message"];
this.data=Userdata.map(obj["data"]);

    }


  }




}
// ignore: non_constant_identifier_names
class Userdata{
  // ignore: non_constant_identifier_names
  String id;

  String name;
  String gender;
  String email;

  String role;
  String status;
  String mobile;

  String address;
  String city;
  String state;

  String country;
  String pincode;
  String lat;

  String lon;
  String mac_id;
  String token_id;

  String img;
  String emergencyContactName;
  String emergencyContactNumber;

  String emergencyContactEmail;
  String bookingStatus;

  Userdata.map(dynamic res){
    if(res!=null){
      this.id=res["_id"];
      this.name=res["name"];
      this.gender=res["gender"];
      this.email=res["email"];
      this.role=res["role"];
      this.status=res["status"];
      this.mobile=res["mobile"];
      this.address=res["address"];
      this.city=res["city"];
      this.state=res["state"];
      this.country=res["country"];
      this.name=res["name"];
      this.pincode=res["pincode"];
     /* this.lat=res["lat"];
      this.lon=res["lon"];*/
      this.mac_id=res["mac_id"];
      this.token_id=res["token_id"];
      this.img=res["img"];
    }
    else{

    }
  }


}