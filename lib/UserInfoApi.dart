import 'package:nber_flutter/Models/NotificationModels.dart';
import 'package:nber_flutter/UserInfoModel.dart';


import 'NetworkUtil.dart';

class UserInfoApi{
  NetworkUtil _netUtil = new NetworkUtil();

  Future<UserInfoModel> search(String userid,String token
      ) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'users';
    return _netUtil.post(base_token_url, body: {
      "user_id":userid,

    },headers:{"Authorization":token}, ).then((dynamic res) {
      UserInfoModel results = new UserInfoModel.map(res);
      //results.status = 200;
      return results;
    });
  }
}