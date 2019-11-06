import 'package:nber_flutter/VehicleTypeModel.dart';

import 'Models/VehicletypeModels.dart';
import 'NetworkUtil.dart';

class VehicleTypeApi {
  NetworkUtil _netUtil = new NetworkUtil();

  Future<VehicletypeModels> search(String userid,String Token)
  {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'get-vehicle';
    return _netUtil.get(base_token_url,headers:{"Authorization":Token}, ).then((dynamic res) {
      VehicletypeModels results = new VehicletypeModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}