class MyRideModels{

  String status;
  String message;
  String response;

  List<RideData> bookingdata;
  String username;

  MyRideModels.map(dynamic obj) {
    if (obj != null) {

     // bookingdata = (obj['data'] as List).map((i) => RideData.fromJson(i)).toList();

    }


  }




}

class RideData{

  final  String booking_status;
  final  String bookingdate;
  final  String bookingpayment;
  final  double distance;
  final  String driver_id;
  final  String driver_image;
  final  String driver_name;
  final  String from_address;
  final  String mobile ;
  final  String payment_status;
  final  String payment_mode;
  final  String to_address;
  final String feedbackstatus;








  RideData.documentSnapShot(dynamic jsonMap)
      : booking_status = jsonMap['booking_status'],
        bookingdate = jsonMap['bookingdate'],
        bookingpayment = jsonMap['bookingpayment'],
        distance = jsonMap['distance'],
        driver_id = jsonMap['driver_id'],
        driver_image = jsonMap['driver_image'],
        driver_name = jsonMap['driver_name'],
        from_address = jsonMap['from_address'],
        mobile = jsonMap['mobile'],
        payment_status = jsonMap['payment_status'],
        payment_mode = jsonMap['payment_mode'],
        to_address = jsonMap['to_address'],
        feedbackstatus=jsonMap['feedback_status'];



}