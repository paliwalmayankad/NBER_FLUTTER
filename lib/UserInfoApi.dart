import 'package:nber_flutter/Models/NotificationModels.dart';
import 'package:nber_flutter/UserInfoModel.dart';


import 'NetworkUtil.dart';

class UserInfoApi{
  NetworkUtil _netUtil = new NetworkUtil();

  Future<UserInfoModel> search(String userid,
      ) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'users';
    return _netUtil.post(base_token_url, body: {
      "user_id":userid,

    },headers:{"Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7fSwiaWF0IjoxNTcxNzIyMjAxfQ.RBDihSg2B963JnMAus4bejs40yHZ0LTasZRf6QlQJLs","Devicetype":"a","Authkey":"","Deviceid":"android","Platform":""}, ).then((dynamic res) {
      UserInfoModel results = new UserInfoModel.map(res);
      //results.status = 200;
      return results;
    });
  }
}