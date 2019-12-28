import 'package:cloud_firestore/cloud_firestore.dart';

class DriverWalletModels{
  String ResponseCode;
  String Message;
  String earned;
  String withdraw;
  String balance;
  List<dynamic> dataList;

  DriverWalletModels.map(dynamic obj){
    if(obj!=null) {
try {
  this.earned = obj["total_earning"];
  this.withdraw = obj["total_withdrawal"];
  this.balance = obj["balance"];
  this.dataList = (obj['mytranscation'] as List).toList();
}catch(e){
  print(e);
}

    }
  }

}
class ListDatViews{
final String type;
 final double payment;

 const ListDatViews(this.type,
     this.payment,
    );

ListDatViews.querysnapshot(dynamic jsonMap)
     : type = jsonMap['type'],
      payment = jsonMap['payment']
      ;
}