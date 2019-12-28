import 'CommonModels.dart';
import 'NetworkUtil.dart';

class FeedbackApi{
  NetworkUtil _netUtil = new NetworkUtil();

  Future<CommonModels> search(String booking_id,String user_id,String level,String feedback,var rating,String status,String Token  ) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'feedback';
    return _netUtil.post(base_token_url, body: { "booking_id":booking_id,
      "user_id":user_id,
      "level":level,
      "feedback":feedback,
      "rating":rating,
      "status":status,
    },headers:{"Authorization":Token}, ).then((dynamic res) {
      CommonModels results = new CommonModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}