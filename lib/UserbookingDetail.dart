import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nber_flutter/MyColors.dart';
import 'package:nber_flutter/MyRideModels.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GenralMessageDialogBox.dart';
import 'appTheme.dart';
import 'designCourse/designCourseAppTheme.dart';

class UserbookingDetail extends StatefulWidget {
 final RideData ridedata;
 UserbookingDetail(this.ridedata);
@override
_UserbookingDetailState createState() => _UserbookingDetailState();
}

class _UserbookingDetailState extends State<UserbookingDetail> {

  bool mainview=false;

  ProgressDialog progressdialog;
  SharedPreferences sharedPreferences;
String vehicletype,vehicledetail;
double feedback=0;
String role;
  @override
  void initState() {
    // TODO: implement initState


    progressdialog=new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressdialog.style(
      //  message: 'Loading...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    callapidataforbookingdetail();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            mainview==true?Expanded(
            child:Container( color: MyColors.white,
               child: SingleChildScrollView(scrollDirection: Axis.vertical,
                 child: Column(children: <Widget>[
                     ////// BANNER IMAGE FOR RIDE
                   Image.asset("images/yellow_logo.png",height: 160,width:double.infinity,fit: BoxFit.cover,)
/// DRIVER DETAIL NAME RATING OR BOOKING CANCEL
                   ,
                   Container(padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                     Container(
                       height: 80,
                       width: 80,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         boxShadow: <BoxShadow>[
                           BoxShadow(
                               color: AppTheme.grey.withOpacity(0.6),
                               offset: Offset(2.0, 4.0),
                               blurRadius: 8),
                         ],
                       ),
                       child: ClipRRect(
                         borderRadius:
                         BorderRadius.all(Radius.circular(60.0)),
                         child: widget.ridedata.driver_image!=null?Image.network(widget.ridedata.driver_image,fit: BoxFit.fill,):Image.asset('images/yellow_logo.png'),
                       ),
                     ),

                     SizedBox(width: 15,)
                     ,
                     Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start,children: <Widget>[
                       Text(widget.ridedata.driver_name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.left,)
                 ,

                 widget.ridedata.booking_status=="complete"&&(widget.ridedata.feedbackstatus!='ignore_by_user'&&widget.ridedata.feedbackstatus!='pending')? Row(children: <Widget>[
                   Text('You Rated ',style: TextStyle(color: Colors.black,fontSize: 10),)

                   ,RatingBar(
                 initialRating: feedback,
                 direction: Axis.horizontal,
                 allowHalfRating: true,
                 itemSize: 15,
                 itemCount: 5,
                 itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                 itemBuilder: (context, _) => Icon(
                   Icons.star,
                   color: Colors.amber,
                 ),
                 onRatingUpdate: (rating) {
                   print(rating);
                 },
               )],):SizedBox()


                     ],),
                     SizedBox(width: 10,),

                     /// FOR CANCEL BOOKING
                     widget.ridedata.booking_status=="cancel_by_driver"||widget.ridedata.booking_status=="cancel_by_user"?  Container(
                       height: 80,
                       width: 80,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,

                       ),
                       child: ClipRRect(
                         borderRadius:
                         BorderRadius.all(Radius.circular(60.0)),
                         child: Image.asset('images/cancel.png',fit: BoxFit.fill,),
                       ),
                     ):SizedBox(),



                   ],),


),
                   //// LIGHT LINE
                   Container(height: 1,color: Colors.black12,),

                   //// CONTAINER FOR VEHICLE DETAIL
                   Container(padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                     child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                     Container(
                       height: 50,
                       width: 50,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,

                       ),
                       child: ClipRRect(
                         borderRadius:
                         BorderRadius.all(Radius.circular(60.0)),
                         child: vehicletype=="car"?Image.asset('images/car_logo.png',fit: BoxFit.fill,):

                         vehicletype=="auto"?Image.asset('images/auto_icon.png',fit: BoxFit.fill,):
                         vehicletype=="bike"?Image.asset('images/bike_icon.png',fit: BoxFit.fill,):
                         vehicletype=="e-auto"?Image.asset('images/erickshaw_hor.png',fit: BoxFit.fill,):
                         vehicletype=="scooty"?Image.asset('images/scooty.png',fit: BoxFit.fill,):

                         Image.asset('images/yellow_logo.png'),
                       ),
                     ),

                     SizedBox(width: 15,)
                     ,
                     Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start,children: <Widget>[
                       Text(vehicletype+"•"+vehicledetail,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 16),textAlign: TextAlign.left,)
                       ,




                     ],),




                   ],),


                   ),

/// LIGHT LINE
                   Container(height: 1,color: Colors.black12,),

                   //// CONTAINER FOR VEHICLE DETAIL
                   Container(padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                     child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                       Container(
                         height: 50,
                         width: 50,
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,

                         ),
                         child: ClipRRect(
                           borderRadius:
                           BorderRadius.all(Radius.circular(60.0)),
                           child: Image.asset('images/price meter_logo.png'),
                         ),
                       ),

                       SizedBox(width: 15,)
                       ,
                       Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start,children: <Widget>[
                         Text(" ₹ "+widget.ridedata.bookingpayment,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.left,)
                         ,




                       ],),




                     ],),


                   ),
                   /// LIGHT LINE
                   Container(height: 1,color: Colors.black12,),
                   //// ADDRESS DETAILS
                   Container(padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                     child: Column(
                       mainAxisAlignment:
                       MainAxisAlignment
                           .spaceBetween,
                       crossAxisAlignment:
                       CrossAxisAlignment.center,
                       children: <Widget>[
                         Row(children: <Widget>[
                           Image
                               .asset(
                             'images/start ride.png',
                             width: 20,
                             height: 20,), SizedBox(width: 5,),
                           Expanded(
                             child:
                             Text(
                                 widget.ridedata.from_address,
                                 textAlign: TextAlign.left,maxLines: 4,
                                 style: TextStyle(
                                   fontWeight: FontWeight.w200,
                                   fontSize: 12,
                                   letterSpacing: 0.27,
                                   color: DesignCourseAppTheme
                                       .grey,
                                 )),
                           ),],),
                         SizedBox(height: 15,),

                         Row(children: <Widget>[
                           Image
                               .asset(
                             'images/end ride.png',
                             width: 20,
                             height: 20,),
                           SizedBox(width: 5,),
                           Expanded(
                             child:Text(
                                 widget.ridedata.to_address,
                                 textAlign: TextAlign.left,maxLines: 4,
                                 style: TextStyle(
                                   fontWeight: FontWeight.w200,
                                   fontSize: 12,
                                   letterSpacing: 0.27,
                                   color: DesignCourseAppTheme
                                       .grey,
                                 )),
                           ),],),
                         /*Text(
                                        " Vehicle No: ${category.from_address}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme
                                              .grey,
                                        ),
                                      ),
                                      Text(
                                        " Driver Name: ${category.driver_name}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme
                                              .grey,
                                        ),
                                      ),*/

                       ],
                     ),


                   ),
                   /// LIGHT LINE
                   Container(height: 1,color: Colors.black12,),

                   //// BILL DETAIL
                   SizedBox(height: 15,),
      role!="driver"?Column(children: <Widget>[
                   ///FOR TRIP
                   widget.ridedata.booking_status=="complete"?
                   Container(padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                     child:
                     Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start,children: <Widget>[
                         Text('Bill Detail',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.left,)
                         ,
                       SizedBox(height: 5,)
                       ,
                       Row(children: <Widget>[
                       Expanded(child:Text('Your Trip',style: TextStyle(color: Colors.black26),),),
                         Expanded(child:Align(alignment: Alignment.centerRight, child:Text('₹ '+widget.ridedata.bookingpayment,style: TextStyle(color: Colors.black26),textAlign: TextAlign.right,)
                         ))

                       ],),




                       ],),









                   ):SizedBox(),
                   /// LIGHT LINE
                   widget.ridedata.booking_status=="complete"?Container(height: 1,color: Colors.black12,):SizedBox(),
                   /// FOR ROUND OFF
                   widget.ridedata.booking_status=="complete"?Container(padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                   child:

                     Row(children: <Widget>[
                       Expanded(child:Text('Rounded off',style: TextStyle(color: Colors.black26),),),
                       Expanded(child:Align(alignment: Alignment.centerRight, child:Text('₹ 0',style: TextStyle(color: Colors.black26),textAlign: TextAlign.right,)
                       ))

                     ],),














                 ):SizedBox(),
                   /// LIGHT LINE
                   widget.ridedata.booking_status=="complete"?Container(height: 1,color: Colors.black12,):SizedBox(),
 //// TOTAL BILL
                   widget.ridedata.booking_status=="complete"?
                   Container(padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                     child:
                     Row(children: <Widget>[
                       Expanded(child:Text('Total Bill',style: TextStyle(color: Colors.black),),),
                       Expanded(child:Align(alignment: Alignment.centerRight, child:Text('₹ '+widget.ridedata.bookingpayment,style: TextStyle(color: Colors.black26),textAlign: TextAlign.right,)
                       ))

                     ],),









                   ):SizedBox(),
                   /// LIGHT LINE
                   widget.ridedata.booking_status=="complete"?Container(height: 1,color: Colors.black12,):SizedBox(),
////TOTAL PAYBLE
                   widget.ridedata.booking_status=="complete"?Container(padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                     child: Row(children: <Widget>[
                       Expanded(child:Text('Toatal Payble',style: TextStyle(color: Colors.black),),),
                       Expanded(child:Align(alignment: Alignment.centerRight, child:Text('₹ '+widget.ridedata.bookingpayment,style: TextStyle(color: Colors.black26),textAlign: TextAlign.right,)
                       ))

                     ],),


                   ):SizedBox(),
                   /// LIGHT LINE
                   widget.ridedata.booking_status=="complete"?Container(height: 1,color: Colors.black12,):SizedBox(),
                   widget.ridedata.booking_status=="complete"?Container(padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                     child:
                     Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start,children: <Widget>[
                       Text('Payment',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.left,)
                       ,
                       SizedBox(height: 5,)
                       ,
                       Row(children: <Widget>[
                         Expanded(child:Text('Your Trip',style: TextStyle(color: Colors.black26),),),
                         Expanded(child:Align(alignment: Alignment.centerRight, child:Text('₹ '+widget.ridedata.bookingpayment,style: TextStyle(color: Colors.black26),textAlign: TextAlign.right,)
                         ))

                       ],),




                     ],),









                   ):SizedBox(),
                   /// LIGHT LINE
                   widget.ridedata.booking_status=="complete"?
                   Container(height: 1,color: Colors.black12,):SizedBox(),
],):SizedBox(),

/// PUT HERE






                 ],),),


                ))

                :SizedBox(),

/// PUT HERE
          ],
        ), ///
      ),
    );
  }









  Widget getAppBarUI() {
    return new Card(color: MyColors.white, child: Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 18, right: 18,bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container( alignment: Alignment.center,
                    child: Text(
                      widget.ridedata.bookingdate,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.27,
                        color: DesignCourseAppTheme.darkerText,
                      ),
                    )),
              ],
            ),
          ),

        ],
      ),
    ));
  }

  Future<void> callapiforbookings() async {




  }

  void callapidataforbookingdetail() async {

    try {
      sharedPreferences = await SharedPreferences.getInstance();
      //progressdialog.show();

      role=sharedPreferences.getString("ROLE");
      String userid = widget.ridedata.driver_id;

       Firestore.instance.collection("driver").document(userid).get().then((userdata){
        try
        {

          progressdialog.hide();
          vehicletype=userdata.data['vehicle_type'];
          vehicledetail= userdata.data['vehicle_detail'];
          String feedbackstatus=widget.ridedata.feedbackstatus;
          if(feedbackstatus!='pending'&&feedbackstatus!="ignore_by_user"){
            Firestore.instance.collection("feedback").document(feedbackstatus).get().then((feedbackdata){
              feedback=double.parse(feedbackdata.data['rating']);
              //progressdialog.dismiss();
              setState(() {
                mainview=true;
              });
            });




            }
          else{
            progressdialog.hide();
            setState(() {
              mainview=true;
            });
          }








        }
        catch(e)
        {
          progressdialog.hide();

          print(e);
        }
      });





    }
    catch(e){
      progressdialog.hide();

      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message: "Sorry there seems to be a network server Error , please try again later.",
          ));
    }
  }


}


