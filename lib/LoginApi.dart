import 'LoginModel.dart';

import 'NetworkUtil.dart';

class LoginApi {

  NetworkUtil _netUtil = new NetworkUtil();

  Future<LoginModel> search(String username) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'login';
    return _netUtil.post(base_token_url, body: { "mobile":username,
    },headers:{"Appversion":"v1","Apiversion":"v1","Devicetype":"a","Authkey":"","Deviceid":"android","Platform":""}, ).then((dynamic res) {
      LoginModel results = new LoginModel.map(res);
      //results.status = 200;
      return results;
    });
  }
}