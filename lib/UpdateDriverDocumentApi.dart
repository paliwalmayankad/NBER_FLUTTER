import 'CommonModels.dart';
import 'NetworkUtil.dart';

class UploadDriverDocumentApi{


  NetworkUtil _netUtil = new NetworkUtil();

  Future<CommonModels> search(String mobile,
      String   token,
      String str_dlfrontcopy,
      String str_dlbackcopy,
      String str_pancardcopy,
      String str_rtocertificatecopyfront,
      String str_rtodertificateback,
      String str_insurancefirst,
      String str_insurancesecond,
      String str_insurancethird,
      String str_aadharfront,
      String str_aadharback,
      String str_policiverificationcopy,
      String str_vehiclephotofrontcopy,
      String str_vehiclephotoback,
      String str_rccopyfront,
      String str_rccopyback,String vehiclenumber,String selectedvehicletypeid) {
    // ignore: non_constant_identifier_names
    String base_token_url = NetworkUtil.base_url + 'driver-register';
    return _netUtil.post(base_token_url, body: {
      "mobile":mobile,
      "insuranceFirst":str_insurancefirst,

      "insuranceSecond":str_insurancesecond,
      "insuranceThird":str_insurancethird,
      "vehicleFront":str_vehiclephotofrontcopy,
      "vehicleBack":str_vehiclephotoback,
      "rcFront":str_rccopyfront,
      "rcBack":str_rccopyback,
      "licenseFront":str_dlfrontcopy,
      "licenseBack":str_dlbackcopy,
      "aadharNo":"",
      "aadharFront":str_aadharfront,
      "aadharBack":str_aadharback,
      "vehicleNumber":vehiclenumber,
      "policeVerificationStatus":"success",
      "policeVerificationFile":str_policiverificationcopy,
      "vehicleType_id":selectedvehicletypeid,
    },headers:{"Authorization":token}, ).then((dynamic res) {
      CommonModels results = new CommonModels.map(res);
      //results.status = 200;
      return results;
    });
  }
}