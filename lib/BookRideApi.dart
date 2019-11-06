import 'package:nber_flutter/CommonModels.dart';

import 'NetworkUtil.dart';

class BookRideApi{
  NetworkUtil _netUtil = new NetworkUtil();

  Future<CommonModels> search(String username, List<String> driver_id, String from_lat, String from_lan, String from_address,String toLat,String toLan,String toaddress,String starttimestamp,String stoptimestamp,String mac_id,String remark,String ipaddress,String token_id,String type) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'book-ride';
    return _netUtil.post(base_token_url, body: { "mobile":username,
    },headers:{"Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7fSwiaWF0IjoxNTcxNzIyMjAxfQ.RBDihSg2B963JnMAus4bejs40yHZ0LTasZRf6QlQJLs"}, ).then((dynamic res) {
      CommonModels results = new CommonModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}