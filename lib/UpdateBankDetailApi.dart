import 'package:nber_flutter/CommonModels.dart';

import 'NetworkUtil.dart';

class updateBankDetailApi{

  NetworkUtil _netUtil = new NetworkUtil();

  Future<CommonModels> search(String userid,String accountnumber,String bankholdername,String ifsccode,String bankname,String token
      ) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'bank-details';
    return _netUtil.post(base_token_url, body: {
      "driver_id":userid,"bankAccountNumber":accountnumber,"bankHolderName":bankholdername,"ifscCode":ifsccode,"bankName":bankname

    },headers:{"Authorization":token}, ).then((dynamic res) {
      CommonModels results = new CommonModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}