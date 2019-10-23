import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nber_flutter/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'CustomDialog.dart';
import 'MyColors.dart';
import 'fitnessApp/UIview/runningView.dart';
import 'fitnessApp/fintnessAppTheme.dart';
import 'model/homelist.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
class TransPortFile_Second extends StatefulWidget {
  TransPortFile_Second({Key key}) : super(key: key);

  @override
  _TransPortFile_SecondState createState() => _TransPortFile_SecondState();
}

class _TransPortFile_SecondState extends State<TransPortFile_Second> with TickerProviderStateMixin {
  List<HomeList> homeList = HomeList.homeList;
  AnimationController animationController;
  bool multiple = true;
  bool search_bar=true;
  bool booking_search=false;
  bool driver_infowithotp=false;
  Animation<double> topBarAnimation;
  ControllerCallback cab;
  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);


    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });



    //_setCurrentLocation();
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      appBar(),
                      Expanded(

                          child: FutureBuilder(
                            future: getData(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox();
                              } else {
                                return GoogleMap(
                                  mapType: MapType.normal,myLocationEnabled: true,
                                  initialCameraPosition: _kGooglePlex,
                                  onMapCreated: (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  }, gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                  new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                                ].toSet(),
                                  

                                );
                              }
                            },
                          )







                      ),
                      new Container(
                          child: SlidingUpPanel(
                              panel: Center(

                                  child: Column(children: <Widget>[

                                    search_bar ? new Container(
                                        child: Column(children: <Widget>[
                                          new Container( margin: const EdgeInsets.only(top:10), child:



                                          Container(
                                            child: Container(margin: const EdgeInsets.only(left: 10,right:10) ,alignment: Alignment.topCenter,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.grey.withOpacity(0.6),
                                                      offset: Offset(4, 4),
                                                      blurRadius: 8.0),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: new Container(
                                                      child: Container(  padding: const EdgeInsets.all(10),
                                                          decoration: new BoxDecoration(color: MyColors.white,
                                                              border:  Border.all(color: Colors.transparent,width: 1.0) ,borderRadius: BorderRadius.circular(10)),



                                                          child:new  Row(children: <Widget>[
                                                            Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),


                                                            Expanded(flex: 10,
                                                              child: TextFormField( textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 16), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:10,top:0,right:10,bottom:0),hintText: "Enter Mobile"
                                                              )),
                                                            ),
                                                            Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),

                                                          ]))
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ),

                                          new Container( margin: const EdgeInsets.only(top:3), child:



                                          Container(
                                            child: Container(margin: const EdgeInsets.only(left: 10,right:10) ,alignment: Alignment.topCenter,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.grey.withOpacity(0.6),
                                                      offset: Offset(4, 4),
                                                      blurRadius: 8.0),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: new Container(
                                                      child: Container(  padding: const EdgeInsets.all(10),
                                                          decoration: new BoxDecoration(color: MyColors.white,
                                                              border:  Border.all(color: Colors.transparent,width: 1.0) ,borderRadius: BorderRadius.circular(10)),



                                                          child:new  Row(children: <Widget>[
                                                            Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),


                                                            Expanded(flex: 10,
                                                              child: TextFormField( textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 16), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:10,top:0,right:10,bottom:0),hintText: "Enter Mobile"
                                                              )),
                                                            ),
                                                            Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),

                                                          ]))
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ),

                                          new Container(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10, right: 10, top: 10, bottom: 0),
                                                    child: Container(
                                                      child:InkWell(
                                                        onTap: (){
                                                          /////
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) => CustomDialog(
                                                              img_type:"bike", total_payable:"100",your_trip:"88",total_fare:"10",
                                                              insurance_premium:"2",from_address: "Jagatpurarailway station",to_address: "International Airport",

                                                            ),

                                                          );
                                                          setState(() => search_bar = !search_bar);
                                                          setState(() => booking_search = !booking_search);

                                                          ////






                                                        },

                                                        child:  Stack(
                                                          overflow: Overflow.visible,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 16, bottom: 16),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: FintnessAppTheme.white,
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius.circular(8.0),
                                                                      bottomLeft: Radius.circular(8.0),
                                                                      bottomRight: Radius.circular(8.0),
                                                                      topRight: Radius.circular(8.0)),
                                                                  boxShadow: <BoxShadow>[
                                                                    BoxShadow(
                                                                        color: FintnessAppTheme.grey.withOpacity(0.4),
                                                                        offset: Offset(1.1, 1.1),
                                                                        blurRadius: 10.0),
                                                                  ],
                                                                ),
                                                                child: Stack(
                                                                  alignment: Alignment.topLeft,
                                                                  children: <Widget>[
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                      BorderRadius.all(Radius.circular(8.0)),
                                                                      child: SizedBox(
                                                                        height: 74,
                                                                        child: AspectRatio(
                                                                          aspectRatio: 1.714,
                                                                          child: Image.asset(
                                                                              "assets/fitness_app/back.png"),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Row(
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                left: 100,
                                                                                right: 16,
                                                                                top: 16,
                                                                              ),
                                                                              child: Text(
                                                                                "You're doing great!",
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(
                                                                                  fontFamily:
                                                                                  FintnessAppTheme.fontName,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 14,
                                                                                  letterSpacing: 0.0,
                                                                                  color:
                                                                                  FintnessAppTheme.nearlyDarkBlue,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                            left: 100,
                                                                            bottom: 12,
                                                                            top: 4,
                                                                            right: 16,
                                                                          ),
                                                                          child: Text(
                                                                            "Keep it up\nand stick to your plan!",
                                                                            textAlign: TextAlign.left,
                                                                            style: TextStyle(
                                                                              fontFamily: FintnessAppTheme.fontName,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 10,
                                                                              letterSpacing: 0.0,
                                                                              color: FintnessAppTheme.grey
                                                                                  .withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: -16,
                                                              left: 0,
                                                              child: SizedBox(
                                                                width: 110,
                                                                height: 110,
                                                                child: Image.asset("assets/fitness_app/runner.png"),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )) ],
                                            ),


                                          )













                                        ],))


                                        :SizedBox(),


                                    ////// LAYOUT FOR SEARCH VISIBLE

                                    booking_search?  new Container( margin: const EdgeInsets.only(top:3), child:



                                    Container(
                                        child:Column(children: <Widget>[
                                          new Container(
                                            margin: const EdgeInsets.only(left:10,top: 5),

                                            child: Align( alignment: Alignment.topCenter, child:Text("Please wait we are searching your near by driver",style: TextStyle(color: Colors.black87,fontSize: 9 ),),

                                            ),),

                                          new Container(   margin: const EdgeInsets.only(left: 10,right: 10,top:15),alignment: Alignment.center,padding: const EdgeInsets.all(10),




                                              child:new  Row(children: <Widget>[
                                                Expanded(flex: 1,
                                                    child: new Container(

                                                        child:   SpinKitDoubleBounce(
                                                          color: Colors.black,
                                                          size: 30.0,
                                                        )


                                                    )



                                                ),

                                                Expanded(flex: 2, child:
                                                Text('Please Wait            or',textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold) ),
                                                ),


                                                Expanded(flex: 1,

                                                    child: new Container(


                                                      margin: const EdgeInsets.only(left: 1,right:1,top:1) ,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                              color: Colors.grey.withOpacity(0.6),
                                                              offset: Offset(4, 4),
                                                              blurRadius: 8.0),
                                                        ],
                                                      ),

                                                      child: Material(
                                                        color: Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            //////

                                                            setState(() => booking_search = !booking_search);
                                                            setState(() => driver_infowithotp = !driver_infowithotp);


                                                            /////


                                                          },
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: <Widget>[

                                                                Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),

                                              ]))





                                        ],)
                                    ),
                                    ):SizedBox(),
                                    /// SHOW DRIVER DETAIL
                                    driver_infowithotp? new Container(
                                      margin: const EdgeInsets.only(top:3,left:5,right:5),
                                      child: new Column(children: <Widget>[
                                        Align( alignment:Alignment.topLeft,
                                            child:new Row(children: <Widget>
                                            [
                                              Expanded(flex:1,
                                                  child: new Column(children:<Widget>[

                                                    Align( alignment: Alignment.centerLeft, child:Text("RJ14JL5963", textAlign: TextAlign.left,style: TextStyle(color: Colors.black87,fontSize: 14 ),),
                                                    ),
                                                    new Container(alignment:Alignment.topLeft,margin: const EdgeInsets.only(top: 10), child:Text("Grey Splendar Plus",style: TextStyle(color: Colors.black87,fontSize: 10 ),),
                                                    ),

                                                    new Container(margin: const EdgeInsets.only(top: 2), child:Align( alignment: Alignment.topLeft,
                                                        child: new Row(children:<Widget>[
                                                          Align( alignment: Alignment.topLeft, child:Text("Rajendra Kumar Mourya",style: TextStyle(color: Colors.black87,fontSize: 10 ),)

                                                          ),
                                                          Image.asset('images/yellow_logo.png',height: 10,width:10,)
                                                          ,new Container(margin: const EdgeInsets.only(left:5),child:Text("4.8",style: TextStyle(color: Colors.black87,fontSize: 10 ),))
                                                        ] )
                                                    ),



                                                    )  ])
                                              ),
                                              /// FOR IMAGES
                                              Expanded(flex:1,
                                                  child: new Row(children:<Widget>[



                                                    new Container(margin: const EdgeInsets.only(top: 2), child:Align( alignment: Alignment.centerRight,
                                                        child: new Row(children:<Widget>[
                                                          Align( alignment:Alignment.topRight,
                                                              child:new Container(child:new Row(children: <Widget>[
                                                                Image.asset('images/yellow_logo.png',height: 50,width:50,),
                                                                Image.asset('images/yellow_logo.png',height: 50,width:50,)
                                                              ])))

                                                        ] )
                                                    ),



                                                    )  ]))

                                            ])

                                        ),
                                        /// BOTTM DIFFENRET BUTTON
                                        new Container(margin: const EdgeInsets.only(top:25),
                                            child:new SingleChildScrollView(scrollDirection: Axis.horizontal, child: new Row(children: <Widget>[


                                                  Container(margin: const EdgeInsets.only(left: 5,right:5) ,alignment: Alignment.center,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: Colors.grey.withOpacity(0.6),
                                                            offset: Offset(4, 4),
                                                            blurRadius: 8.0),
                                                      ],
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.share,
                                                                color: Colors.white,
                                                                size: 22,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: Text(
                                                                  'Contact',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    ),
                                                  ),

                                                  Container(margin: const EdgeInsets.only(left: 5,right:5) ,alignment: Alignment.center,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: Colors.grey.withOpacity(0.6),
                                                            offset: Offset(4, 4),
                                                            blurRadius: 8.0),
                                                      ],
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.share,
                                                                color: Colors.white,
                                                                size: 22,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: Text(
                                                                  'Cancel Ride',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                  ),

                                                  Container(margin: const EdgeInsets.only(left: 5,right:5) ,alignment: Alignment.center,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: Colors.grey.withOpacity(0.6),
                                                            offset: Offset(4, 4),
                                                            blurRadius: 8.0),
                                                      ],
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.share,
                                                                color: Colors.white,
                                                                size: 22,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: Text(
                                                                  'Support',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    ),
                                                  ),

                                                  Container(margin: const EdgeInsets.only(left: 5,right:5) ,alignment: Alignment.center,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            color: Colors.grey.withOpacity(0.6),
                                                            offset: Offset(4, 4),
                                                            blurRadius: 8.0),
                                                      ],
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.share,
                                                                color: Colors.white,
                                                                size: 22,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: Text(
                                                                  'Share Detail',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                ])

                                        ) ),
                                        new Container( margin: const EdgeInsets.only(top:10), child:



                                        Container(
                                          child: Container(margin: const EdgeInsets.only(left: 10,right:10) ,alignment: Alignment.topCenter,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.6),
                                                    offset: Offset(4, 4),
                                                    blurRadius: 8.0),
                                              ],
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {},
                                                child: new Container(
                                                    child: Container(  padding: const EdgeInsets.all(10),
                                                        decoration: new BoxDecoration(color: MyColors.white,
                                                            border:  Border.all(color: Colors.transparent,width: 1.0) ,borderRadius: BorderRadius.circular(10)),



                                                        child:new  Row(children: <Widget>[
                                                          Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),


                                                          Expanded(flex: 10,
                                                            child: TextFormField( textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 16), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                                                              borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:10,top:0,right:10,bottom:0),hintText: "Enter Mobile"
                                                            )),
                                                          ),
                                                          Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),

                                                        ]))
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ),

                                        new Container( margin: const EdgeInsets.only(top:3), child:



                                        Container(
                                          child: Container(margin: const EdgeInsets.only(left: 10,right:10) ,alignment: Alignment.topCenter,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.6),
                                                    offset: Offset(4, 4),
                                                    blurRadius: 8.0),
                                              ],
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {},
                                                child: new Container(
                                                    child: Container(  padding: const EdgeInsets.all(10),
                                                        decoration: new BoxDecoration(color: MyColors.white,
                                                            border:  Border.all(color: Colors.transparent,width: 1.0) ,borderRadius: BorderRadius.circular(10)),



                                                        child:new  Row(children: <Widget>[
                                                          Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),


                                                          Expanded(flex: 10,
                                                            child: TextFormField( textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 16), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                                                              borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:10,top:0,right:10,bottom:0),hintText: "Enter Mobile"
                                                            )),
                                                          ),
                                                          Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),

                                                        ]))
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ),])







                                    ):SizedBox(),




                      ///


                    ])







            ),
          ))

          ],
          ),
          );
          }
          },
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "NBER",
                  style: new TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, right: 8),
            child: Container(

            ),
          ),
        ],
      ),
    );
  }
}

class HomeListView extends StatelessWidget {
  final HomeList listData;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation animation;

  const HomeListView(
      {Key key,
        this.listData,
        this.callBack,
        this.animationController,
        this.animation})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Image.asset(
                      listData.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        onTap: () {
                          callBack();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

}