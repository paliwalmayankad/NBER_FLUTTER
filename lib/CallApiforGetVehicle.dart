import 'package:nber_flutter/VehicleTypeModel.dart';

import 'NetworkUtil.dart';

class CallApiforGetVehicle{
  NetworkUtil _netUtil = new NetworkUtil();

  Future<VehicleTypeModel> search(String token,
      ) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'get-vehicle';
    return _netUtil.get(base_token_url, headers:{"Authorization":token,}, ).then((dynamic res) {
      VehicleTypeModel results = new VehicleTypeModel.map(res);
      //results.status = 200;
      return results;
    });
  }

}