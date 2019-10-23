import 'package:nber_flutter/Models/NotificationModels.dart';

import '../NetworkUtil.dart';

class NotificationApi{
  NetworkUtil _netUtil = new NetworkUtil();

  Future<NotificationModels> search(String userid,
      ) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'get-notification';
    return _netUtil.post(base_token_url, body: {
      "user_id":userid,

    },headers:{"Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7fSwiaWF0IjoxNTcxNzIyMjAxfQ.RBDihSg2B963JnMAus4bejs40yHZ0LTasZRf6QlQJLs","Devicetype":"a","Authkey":"","Deviceid":"android","Platform":""}, ).then((dynamic res) {
      NotificationModels results = new NotificationModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}