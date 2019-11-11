class DriverWalletModels{
  String ResponseCode;
  String Message;
  double earned;
  double withdraw;
  double balance;
  List<ListDatViews> dataList;

  DriverWalletModels.map(dynamic obj){
    if(obj!=null) {
      this.ResponseCode=obj["Response Code"];
      this.Message=obj["message"];
      this.earned=obj["earned"];
      this.withdraw=obj["withdraw"];
      this.balance=obj["balance"];
      dataList = (obj['list'] as List).map((i) => ListDatViews.fromJson(i)).toList();



    }
  }

}
class ListDatViews{
final String type;
 final double payment;

 const ListDatViews(this.type,
     this.payment,
    );

ListDatViews.fromJson(Map jsonMap)
     : type = jsonMap['type'],
      payment = jsonMap['payment']
      ;
}