class LoginModel {
  String status;
  String message;
  String response;
  List<Userdata> data;
String token;
  String username;

  LoginModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["Response Code"];
this.token=obj["token"];
      this.message = obj["message"];
      data = (obj['data'] as List).map((i) => Userdata.fromJson(i)).toList();

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

  String city;
  String state;
  String country;
List<String> savedAddressType;
List<String> savedAddressAddress;
  String pincode;
  String lat;
  String lon;

  String mac_id;
  String token_id;
  String img;

  String emergencyContactName;
  String emergencyContactNumber;
  String emergencyContactEmail;

  String createdAt;
  String updatedAt;
  int v;

  String address;


  Userdata.fromJson(Map res){
    if(res!=null){
      try {
        this.savedAddressType = ["savedAddressType"];
        this.savedAddressAddress = ["savedAddressAddress"];
        this.name = res["name"];
        this.id = res["_id"];

        this.gender = res["gender"];
        this.email = res["email"];
        this.role = res["role"];
        this.status = res["status"];
        this.mobile = res["mobile"];
        this.city = res["city"];
        this.state = res["state"];
        this.country = res["country"];
        this.pincode = res["pincode"];
        this.lat = res["lat"];
        this.lon = res["lon"];
        this.mac_id = res["mac_id"];
        this.token_id = res["token_id"];
        this.img = res["img"];
        this.emergencyContactName = res["emergencyContactName"];
        this.emergencyContactNumber = res["emergencyContactNumber"];
        this.emergencyContactEmail = res["emergencyContactEmail"];
        this.createdAt = res["createdAt"];
        this.updatedAt = res["updatedAt"];
        this.v = res["__v"];
        this.address = res["address"];
      }catch(e)
    {
      String jj=e.toString();
    }
    }
    else
      {

    }
  }


}