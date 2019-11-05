import 'package:nber_flutter/VehicleTypeModel.dart';

import 'Models/VehicletypeModels.dart';
import 'NetworkUtil.dart';

class VehicleTypeApi {
  NetworkUtil _netUtil = new NetworkUtil();

  Future<VehicletypeModels> search(String userid,)
  {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'get-vehicle';
    return _netUtil.get(base_token_url,headers:{"Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7fSwiaWF0IjoxNTcxNzIyMjAxfQ.RBDihSg2B963JnMAus4bejs40yHZ0LTasZRf6QlQJLs","Devicetype":"a","Authkey":"","Deviceid":"android","Platform":""}, ).then((dynamic res) {
      VehicletypeModels results = new VehicletypeModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}