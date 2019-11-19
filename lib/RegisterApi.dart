
import 'NetworkUtil.dart';

import 'RegisterModel.dart';

class RegisterApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<RegisterModel> search(String firstname,
      String   lastname,
      String   useremail,
      String  usermobile,
      String  useraddress,
      String  usercity,
      String  userstate,
      String  usercountry,
      String  userpincode,
      String  useremergencycontactname,
      String  useremergencymobile,
      String  useremergencyemail,String image) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'register';
    return _netUtil.post(base_token_url, body: {
      "name":firstname+" "+lastname,
      "gender":"male",

      "email":useremail,
      "mobile":usermobile,
      "address":useraddress,
      "city":usercity,
      "state":userstate,
      "country":usercountry,
      "pincode":userpincode,
      "lat":"24.654",
      "lon":"74.65465",
      "mac_id":"4565",
      "token_id":"dfjksldfhsldfjsklfjklsdfj","img":image,
    },headers:{"Appversion":"v1","Apiversion":"v1","Devicetype":"a","Authkey":"","Deviceid":"android","Platform":""}, ).then((dynamic res) {
      RegisterModel results = new RegisterModel.map(res);
      //results.status = 200;
      return results;
    });
  }
}