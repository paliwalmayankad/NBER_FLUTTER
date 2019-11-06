class UserInfoModel{

  String status;
  String message;
  String response;
  Userdata data;
  Userdatas datas;

  String username;

  UserInfoModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["Response Code"];

      this.message = obj["message"];
        data= new Userdata.map(obj["data"]);
      datas= new Userdatas.map(obj["data"]);

    }


  }




}
// ignore: non_constant_identifier_names
class Userdata{
  String _id;
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
  String emergencyContactName;
  String emergencyContactNumber;
  String emergencyContactEmail;
  String createdAt;
  String updatedAt;
  String __v;


  Userdata.map(dynamic res){
    if(res!=null){
      this._id=res["_id"];
      this.name=res["name"];
      this.gender=res["gender"];
      this.email=res["email"];
      this.role=res["role"];
      this.status=res["status"];
      this.mobile=res["mobile"];
      this.address=res["address"];
      this.name=res["name"];
      this.city=res["city"];
      this.state=res["state"];
      this.country=res["country"];
      this.pincode=res["pincode"];
      this.lat=res["lat"];
      this.lon=res["lon"];
      this.mac_id=res["mac_id"];
      this.token_id=res["token_id"];
      if(res["emergencyContactName"]!=null){
        this.emergencyContactName=res["emergencyContactName"];
      }
      else{
        this.emergencyContactName="";
      }

      if(res["emergencyContactNumber"]!=null){
        this.emergencyContactNumber=res["emergencyContactNumber"];
      }
      else{
        this.emergencyContactNumber="";
      }
      if(res["emergencyContactEmail"]!=null){
        this.emergencyContactEmail=res["emergencyContactEmail"];
      }
      else{
        this.emergencyContactEmail="";
      }



      this.createdAt=res["createdAt"];
      this.updatedAt=res["updatedAt"];

    }

  }


}
class Userdatas{
  String _id;
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
  String emergencyContactName;
  String emergencyContactNumber;
  String emergencyContactEmail;
  String createdAt;
  String updatedAt;
  String __v;


  Userdatas.map(dynamic res){
    if(res!=null){
      this._id=res["_id"];
      this.name=res["name"];
      this.gender=res["gender"];
      this.email=res["email"];
      this.role=res["role"];
      this.status=res["status"];
      this.mobile=res["mobile"];
      this.address=res["address"];
      this.name=res["name"];
      this.city=res["city"];
      this.state=res["state"];
      this.country=res["country"];
      this.pincode=res["pincode"];
      this.lat=res["lat"];
      this.lon=res["lon"];
      this.mac_id=res["mac_id"];
      this.token_id=res["token_id"];
      if(res["emergencyContactName"]!=null){
        this.emergencyContactName=res["emergencyContactName"];
      }
      else{
        this.emergencyContactName="";
      }

      if(res["emergencyContactNumber"]!=null){
        this.emergencyContactNumber=res["emergencyContactNumber"];
      }
      else{
        this.emergencyContactNumber="";
      }
      if(res["emergencyContactEmail"]!=null){
        this.emergencyContactEmail=res["emergencyContactEmail"];
      }
      else{
        this.emergencyContactEmail="";
      }



      this.createdAt=res["createdAt"];
      this.updatedAt=res["updatedAt"];

    }

  }


}