import 'CommonModels.dart';
import 'NetworkUtil.dart';

class UploadDriverDocumentApi{


  NetworkUtil _netUtil = new NetworkUtil();

  Future<CommonModels> search(String firstname,
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
      String  useremergencyemail) {
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
      "token_id":"dfjksldfhsldfjsklfjklsdfj",
    },headers:{"Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7fSwiaWF0IjoxNTcxNzIyMjAxfQ.RBDihSg2B963JnMAus4bejs40yHZ0LTasZRf6QlQJLs"}, ).then((dynamic res) {
      CommonModels results = new CommonModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}