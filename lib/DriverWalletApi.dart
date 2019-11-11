import 'package:nber_flutter/DriverWalletModels.dart';

import 'NetworkUtil.dart';

class DriverWalletApi {
  NetworkUtil _netUtil = new NetworkUtil();

  Future<DriverWalletModels> search(String userid,String token
      ) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'get-wallet-driver_id';
    return _netUtil.post(base_token_url, body: {
      "driver_id":userid,

    },headers:{"Authorization":token}, ).then((dynamic res) {
      DriverWalletModels results = new DriverWalletModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}