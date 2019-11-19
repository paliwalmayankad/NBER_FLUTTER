import 'CommonModels.dart';
import 'NetworkUtil.dart';

class RequestforAmountWhitdrawalapi{
  NetworkUtil _netUtil = new NetworkUtil();

  Future<CommonModels> search(String userid,String amount,String token
      ) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'withdraw';
    return _netUtil.post(base_token_url, body: {
      "driver_id":userid,"amount":amount,

    },headers:{"Authorization":token}, ).then((dynamic res) {
      CommonModels results = new CommonModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}