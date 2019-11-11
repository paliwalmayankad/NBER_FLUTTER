import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart' hide Location;
import 'package:nber_flutter/CommonModels.dart';
import 'package:nber_flutter/MapGadiApi.dart';
import 'package:nber_flutter/VehicleTypeApi.dart';
import 'package:nber_flutter/VehicleTypeModel.dart';
import 'package:nber_flutter/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'BookRideApi.dart';
import 'Consts.dart';
import 'CustomDialog.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'Models/VehicletypeModels.dart';
import 'MyColors.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart' ;
import 'VehicleTypeView.dart';
import 'fitnessApp/UIview/runningView.dart';
import 'fitnessApp/fintnessAppTheme.dart';
import 'model/homelist.dart';
import 'dart:math' show Random, asin, cos, sqrt;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
class TransPortFile_Second extends StatefulWidget {
  // TransPortFile_Second({Key key}) : super(key: key);
  final AnimationController animationController;

  const TransPortFile_Second({Key key, this.animationController}) : super(key: key);


  @override
  _TransPortFile_SecondState createState() => _TransPortFile_SecondState();
}

 class _TransPortFile_SecondState extends State<TransPortFile_Second> with TickerProviderStateMixin {
  List<HomeList> homeList = HomeList.homeList;
  AnimationController animationControllers;
  bool multiple = true;
  bool search_bar = true;
  bool booking_search = false;
  bool driver_infowithotp = false;
  ProgressDialog progressDialog;
  BitmapDescriptor myIcon;
  BitmapDescriptor mapvehicle_icon;
  SocketIOManager manager;
  bool ridestart=false;
  bool booking_request_driver_dialog=false;
  Timer driver_timer,sec_timer;
  var textController_ridestatus = new TextEditingController();
  MapGadiApi mapgadiresults;
  double selectedvehicleperkmprice;
  List<String> toPrint = ["trying to connect"];
  Map<String, SocketIO> sockets = {};
  Map<String, bool> _isProbablyConnected = {};
  var currentlat, currentlong;
  MarkerId markerId;
  String ride_statue_button="Start Ride";
  bool vehicletypeselected=false;
  VehicletypeModels results;
  var starting_address;
  var ending_address;
  VehicleTypeApi _vehicleTypeApi;
  LatLng startpointlatlong, endpointlatlong;
  final Set<Marker> _markers = {};
  final Set<Polyline>_polyline={};
  Animation<double> topBarAnimation;
  ControllerCallback cab;
  bool startpointsearching = true;

  bool endpointsearching = false;
  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool isuserisbooker=false;
  bool isuserisdriver=false;
 static SharedPreferences sharedprefrences;
  var kGoogleApiKey = "AIzaSyCFZrLl-0KWB2aYMCOCFw2YbjJUeh2j5aU";
  GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: 'AIzaSyCFZrLl-0KWB2aYMCOCFw2YbjJUeh2j5aU');
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController_sec;
  TextEditingController _starteditcontroller, _endpointcontroller;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 0,
      zoom: 19.151926040649414);

  @override
  void initState()  {
    _starteditcontroller = new TextEditingController();
    _endpointcontroller = new TextEditingController();
    _vehicleTypeApi=new VehicleTypeApi();

    progressDialog=new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
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
    checkforsharedprefs();





    animationControllers = AnimationController(
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

    /////
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(20, 20)), 'images/car_icon.png')
        .then((onValue) {
      mapvehicle_icon = onValue;
    });


    manager = SocketIOManager();
    _implementsocketio("searchvehicle");

    markerId = MarkerId('1111');


    //_setCurrentLocation();

    super.initState();
    //showbottomsheetdialogfordriverlayout();
  }



  @override
  void dispose() {
    animationControllers.dispose();
    driver_timer.cancel();
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
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .padding
                  .top),
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
                            return currentlat == null || currentlong == null
                                ? Container()
                                : Scaffold(body: Center(child: Stack(
                                children: <Widget>[
                                  new Container(child: GoogleMap(
                                    mapType: MapType.normal,
                                    polylines: _polyline,
                                    myLocationEnabled: true,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          currentlat ?? 0, currentlong ?? 0),
                                      zoom: 15.0,
                                    ),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      mapController_sec = controller;
                                      // _changecameraposition(controller);

                                      // _controller.complete(controller);

                                    },
                                    markers: _markers

                                    ,
                                    onCameraMove: ((_position) =>
                                        _updateMarker(_position)),


                                    gestureRecognizers: <
                                        Factory<OneSequenceGestureRecognizer>>[
                                      new Factory<
                                          OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                                    ].toSet(),


                                  ),),
                                  new Container(alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: Image.asset(
                                        'images/start ride.png', height: 35,
                                        width: 35,)),
                                ])));
                          }
                        },
                      )


                  ),
                  isuserisbooker ? new Container(
                      child: SlidingUpPanel(
                          panel:BottomAppBar (

                            child:SingleChildScrollView(child: Column(children: <Widget>[

                              search_bar ? new Container(
                                  child: Column(children: <Widget>[
                                    new Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child:


                                      Container(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          alignment: Alignment.topCenter,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  offset: Offset(4, 4),
                                                  blurRadius: 8.0),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {},
                                              child: new Container(
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .all(10),
                                                      decoration: new BoxDecoration(
                                                          color: MyColors.white,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0),
                                                          borderRadius: BorderRadius
                                                              .circular(10)),


                                                      child: new Row(
                                                          children: <Widget>[
                                                            Expanded(flex: 1,
                                                              child: Image
                                                                  .asset(
                                                                'images/start ride.png',
                                                                width: 20,
                                                                height: 20,),),


                                                            Expanded(flex: 10,
                                                                child: InkWell(
                                                                  /*onTap: () async {
                                                            Prediction p = await PlacesAutocomplete.show(
                                                                context: context, apiKey: kGoogleApiKey);
                                                            displayPrediction(p);
                                                          }*/
                                                                  child: TextFormField(
                                                                      onTap: () async {
                                                                        startpointsearching =
                                                                        true;
                                                                        endpointsearching =
                                                                        false;
                                                                        FocusScope
                                                                            .of(
                                                                            context)
                                                                            .requestFocus(
                                                                            new FocusNode());
                                                                        Prediction p = await PlacesAutocomplete
                                                                            .show(
                                                                            context: context,
                                                                            apiKey: kGoogleApiKey);
                                                                        displayPrediction(
                                                                            p);
                                                                      },
                                                                      enableInteractiveSelection: false,
                                                                      // will disable paste operation
                                                                      focusNode: new AlwaysDisabledFocusNode(),
                                                                      controller: _starteditcontroller,
                                                                      textAlign: TextAlign
                                                                          .start,
                                                                      keyboardType: null,
                                                                      obscureText: false,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: 16),
                                                                      decoration: new InputDecoration(
                                                                          fillColor: Colors
                                                                              .white,
                                                                          filled: true,
                                                                          border: new OutlineInputBorder(
                                                                              borderRadius: new BorderRadius
                                                                                  .circular(
                                                                                  20.00),
                                                                              borderSide: new BorderSide(
                                                                                  color: Colors
                                                                                      .white)),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                  color: Colors
                                                                                      .white),
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  20.00)),
                                                                          enabledBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .white),
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                20.0),),
                                                                          contentPadding: EdgeInsets
                                                                              .only(
                                                                              left: 10,
                                                                              top: 0,
                                                                              right: 10,
                                                                              bottom: 0),
                                                                          hintText: "Start Point"
                                                                      )),
                                                                )),
                                                            Expanded(flex: 1,
                                                              child: Image
                                                                  .asset(
                                                                'images/heart-unclicked.png',
                                                                width: 20,
                                                                height: 20,),),

                                                          ]))
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    new Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      child:


                                      Container(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          alignment: Alignment.topCenter,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  offset: Offset(4, 4),
                                                  blurRadius: 8.0),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {},
                                              child: new Container(
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .all(10),
                                                      decoration: new BoxDecoration(
                                                          color: MyColors.white,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0),
                                                          borderRadius: BorderRadius
                                                              .circular(10)),


                                                      child: new Row(
                                                          children: <Widget>[
                                                            Expanded(flex: 1,
                                                              child: Image
                                                                  .asset(
                                                                'images/end ride.png',
                                                                width: 20,
                                                                height: 20,),),


                                                            Expanded(flex: 10,
                                                              child: TextFormField(
                                                                  onTap: () async {
                                                                    startpointsearching =
                                                                    false;
                                                                    endpointsearching =
                                                                    true;
                                                                    FocusScope
                                                                        .of(
                                                                        context)
                                                                        .requestFocus(
                                                                        new FocusNode());
                                                                    Prediction p = await PlacesAutocomplete
                                                                        .show(
                                                                        context: context,
                                                                        apiKey: kGoogleApiKey);
                                                                    displayPrediction(
                                                                        p);
                                                                  },
                                                                  enableInteractiveSelection: false,
                                                                  // will disable paste operation
                                                                  focusNode: new AlwaysDisabledFocusNode(),
                                                                  controller: _endpointcontroller,
                                                                  textAlign: TextAlign
                                                                      .start,
                                                                  keyboardType: null,
                                                                  obscureText: false,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16),
                                                                  decoration: new InputDecoration(
                                                                      fillColor: Colors
                                                                          .white,
                                                                      filled: true,
                                                                      border: new OutlineInputBorder(
                                                                          borderRadius: new BorderRadius
                                                                              .circular(
                                                                              20.00),
                                                                          borderSide: new BorderSide(
                                                                              color: Colors
                                                                                  .white)),
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors
                                                                                  .white),
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              20.00)),
                                                                      enabledBorder: UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: Colors
                                                                                .white),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            20.0),),
                                                                      contentPadding: EdgeInsets
                                                                          .only(
                                                                          left: 10,
                                                                          top: 0,
                                                                          right: 10,
                                                                          bottom: 0),
                                                                      hintText: "Enter Destination"
                                                                  )),
                                                            ),
                                                            Expanded(flex: 1,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  _checklocationdistance();
                                                                },
                                                                child: Image
                                                                    .asset(
                                                                  'images/yellow_logo.png',
                                                                  width: 20,
                                                                  height: 20,),),

                                                            )
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
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 0),
                                              child: Container(
                                                  child: InkWell(
                                                    onTap: () {
                                                      /////
                                                      /* showDialog(
                                                        context: context,
                                                        builder: (
                                                            BuildContext context) =>
                                                            CustomDialog(
                                                              img_type: "bike",
                                                              total_payable: "100",
                                                              your_trip: "88",
                                                              total_fare: "10",
                                                              insurance_premium: "2",
                                                              from_address: "Jagatpurarailway station",
                                                              to_address: "International Airport",

                                                            ),

                                                      );
                                                      setState(() =>
                                                      search_bar = !search_bar);
                                                      setState(() =>
                                                      booking_search =
                                                      !booking_search);*/

                                                      ////


                                                    },

                                                    child: Stack(
                                                        overflow: Overflow.visible,
                                                        children: <Widget>[
                                                          Column(mainAxisSize :MainAxisSize.min,children:<Widget>[





                                                            getMainListViewUI(),


                                                          ],
                                                          ),
                                                        ]),
                                                  ))
                                          )],
                                      ),


                                    )


                                  ],))


                                  : SizedBox(),


                              ////// LAYOUT FOR SEARCH VISIBLE

                              booking_search ? new Container(
                                margin: const EdgeInsets.only(top: 3), child:


                              Container(
                                  child: Column(children: <Widget>[
                                    new Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, top: 5),

                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          "Please wait we are searching your near by driver",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 9),),

                                      ),),

                                    new Container(margin: const EdgeInsets.only(
                                        left: 10, right: 10, top: 15),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10),


                                        child: new Row(children: <Widget>[
                                          Expanded(flex: 1,
                                              child: new Container(

                                                  child: SpinKitDoubleBounce(
                                                    color: Colors.black,
                                                    size: 30.0,
                                                  )


                                              )


                                          ),

                                          Expanded(flex: 2, child:
                                          Text('Please Wait            or',
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          ),


                                          Expanded(flex: 1,

                                              child: new Container(


                                                margin: const EdgeInsets.only(
                                                    left: 1, right: 1, top: 1),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(4.0)),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.6),
                                                        offset: Offset(4, 4),
                                                        blurRadius: 8.0),
                                                  ],
                                                ),

                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      //////

                                                      setState(() =>
                                                      booking_search =
                                                      !booking_search);
                                                      setState(() =>
                                                      driver_infowithotp =
                                                      !driver_infowithotp);


                                                      /////


                                                    },
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[

                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .all(4.0),
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: Colors
                                                                    .white,
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
                              ) : SizedBox(),

                              /// SHOW DRIVER DETAIL
                              driver_infowithotp ? new Container(
                                  margin: const EdgeInsets.only(
                                      top: 3, left: 5, right: 5),
                                  child: new Column(children: <Widget>[
                                    Align(alignment: Alignment.topLeft,
                                        child: new Row(children: <Widget>
                                        [
                                          Expanded(flex: 1,
                                              child: new Column(
                                                  children: <Widget>[

                                                    Align(alignment: Alignment
                                                        .centerLeft,
                                                      child: Text("RJ14JL5963",
                                                        textAlign: TextAlign
                                                            .left,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black87,
                                                            fontSize: 14),),
                                                    ),
                                                    new Container(
                                                      alignment: Alignment
                                                          .topLeft,
                                                      margin: const EdgeInsets
                                                          .only(top: 10),
                                                      child: Text(
                                                        "Grey Splendar Plus",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black87,
                                                            fontSize: 10),),
                                                    ),

                                                    new Container(
                                                      margin: const EdgeInsets
                                                          .only(top: 2),
                                                      child: Align(
                                                          alignment: Alignment
                                                              .topLeft,
                                                          child: new Row(
                                                              children: <
                                                                  Widget>[
                                                                Align(
                                                                    alignment: Alignment
                                                                        .topLeft,
                                                                    child: Text(
                                                                      "Rajendra Kumar Mourya",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black87,
                                                                          fontSize: 10),)

                                                                ),
                                                                Image.asset(
                                                                  'images/star.png',
                                                                  height: 15,
                                                                  width: 15,)
                                                                ,
                                                                new Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left: 5),
                                                                    child: Text(
                                                                      "4.8",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black87,
                                                                          fontSize: 10),))
                                                              ])
                                                      ),


                                                    )
                                                  ])
                                          ),

                                          /// FOR IMAGES
                                          Expanded(flex: 1,
                                              child: new Row(children: <Widget>[


                                                new Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 2),
                                                  child: Align(
                                                      alignment: Alignment
                                                          .centerRight,
                                                      child: new Row(
                                                          children: <Widget>[
                                                            Align(
                                                                alignment: Alignment
                                                                    .topRight,
                                                                child: new Container(
                                                                    child: new Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Image
                                                                              .asset(
                                                                            'images/yellow_logo.png',
                                                                            height: 50,
                                                                            width: 50,),
                                                                          Image
                                                                              .asset(
                                                                            'images/yellow_logo.png',
                                                                            height: 50,
                                                                            width: 50,)
                                                                        ])))

                                                          ])
                                                  ),


                                                )
                                              ]))

                                        ])

                                    ),

                                    /// BOTTM DIFFENRET BUTTON
                                    new Container(
                                        margin: const EdgeInsets.only(top: 25),
                                        child: new SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: new Row(children: <Widget>[


                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                alignment: Alignment.center,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(4.0)),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.6),
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
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                            'images/black_contact.png',height:22,width: 22,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .all(4.0),
                                                            child: Text(
                                                              'Contact',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                              ),

                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                alignment: Alignment.center,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(4.0)),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.6),
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
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[

                                                          Image.asset(
                                                            'images/close.png',height:15,width: 15,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .all(4.0),
                                                            child: Text(
                                                              'Cancel Ride',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              ),

                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                alignment: Alignment.center,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(4.0)),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.6),
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
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                            'images/black_support.png',height:22,width: 22,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .all(4.0),
                                                            child: Text(
                                                              'Support',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                              ),

                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                alignment: Alignment.center,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(4.0)),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.6),
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
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                            'images/black_sharedetail.png',height:22,width: 22,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .all(4.0),
                                                            child: Text(
                                                              'Share Detail',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: Colors
                                                                    .black,
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

                                        )),
                                    new Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child:


                                      Container(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          alignment: Alignment.topCenter,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  offset: Offset(4, 4),
                                                  blurRadius: 8.0),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {},
                                              child: new Container(
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .all(10),
                                                      decoration: new BoxDecoration(
                                                          color: MyColors.white,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0),
                                                          borderRadius: BorderRadius
                                                              .circular(10)),


                                                      child: new Row(
                                                          children: <Widget>[
                                                            Expanded(flex: 1,
                                                              child: Image
                                                                  .asset(
                                                                'images/start ride.png',
                                                                width: 20,
                                                                height: 20,),),


                                                            Expanded(flex: 10,
                                                              child: TextFormField(
                                                                  textAlign: TextAlign
                                                                      .start,
                                                                  keyboardType: TextInputType
                                                                      .phone,
                                                                  obscureText: false,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16),
                                                                  decoration: new InputDecoration(
                                                                      fillColor: Colors
                                                                          .white,
                                                                      filled: true,
                                                                      border: new OutlineInputBorder(
                                                                          borderRadius: new BorderRadius
                                                                              .circular(
                                                                              20.00),
                                                                          borderSide: new BorderSide(
                                                                              color: Colors
                                                                                  .white)),
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors
                                                                                  .white),
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              20.00)),
                                                                      enabledBorder: UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: Colors
                                                                                .white),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            20.0),),
                                                                      contentPadding: EdgeInsets
                                                                          .only(
                                                                          left: 10,
                                                                          top: 0,
                                                                          right: 10,
                                                                          bottom: 0),
                                                                      hintText: "Start Point"
                                                                  )),
                                                            ),
                                                            Expanded(flex: 1,
                                                              child: Image
                                                                  .asset(
                                                                'images/heart selected.png',
                                                                width: 20,
                                                                height: 20,),),

                                                          ]))
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    new Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      child:


                                      Container(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          alignment: Alignment.topCenter,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  offset: Offset(4, 4),
                                                  blurRadius: 8.0),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {},
                                              child: new Container(
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .all(10),
                                                      decoration: new BoxDecoration(
                                                          color: MyColors.white,
                                                          border: Border.all(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0),
                                                          borderRadius: BorderRadius
                                                              .circular(10)),


                                                      child: new Row(
                                                          children: <Widget>[
                                                            Expanded(flex: 1,
                                                              child: Image
                                                                  .asset(
                                                                'images/end ride.png',
                                                                width: 20,
                                                                height: 20,),),


                                                            Expanded(flex: 10,
                                                              child: TextFormField(
                                                                  textAlign: TextAlign
                                                                      .start,
                                                                  keyboardType: TextInputType
                                                                      .phone,
                                                                  obscureText: false,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: 16),
                                                                  decoration: new InputDecoration(
                                                                      fillColor: Colors
                                                                          .white,
                                                                      filled: true,
                                                                      border: new OutlineInputBorder(
                                                                          borderRadius: new BorderRadius
                                                                              .circular(
                                                                              20.00),
                                                                          borderSide: new BorderSide(
                                                                              color: Colors
                                                                                  .white)),
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors
                                                                                  .white),
                                                                          borderRadius: BorderRadius
                                                                              .circular(
                                                                              20.00)),
                                                                      enabledBorder: UnderlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: Colors
                                                                                .white),
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            20.0),),
                                                                      contentPadding: EdgeInsets
                                                                          .only(
                                                                          left: 10,
                                                                          top: 0,
                                                                          right: 10,
                                                                          bottom: 0),
                                                                      hintText: "Destination"
                                                                  )),
                                                            ),


                                                          ]))
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ])


                              ) : SizedBox(),


                              ///


                            ])


                            ),
                          ))

                  ):SizedBox()],
              ),
            );
          }
        },
      ),
    );
  }
  Widget getMainListViewUI() {
    try {
      return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return Container(
                child: ListView.builder(shrinkWrap: true,
                  controller: scrollController,

                  //  itemCount: results.vehicledata.length,
                  itemCount: results.vehicledata.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    // widget.animationController.forward();
                    // return listViews[index];
                    return Container(
                      height: 100,
                      width: 1000,
                      margin: const EdgeInsets.only(left:10,right:10),

                      child: Center(child: Scaffold(body: Center(child: new Row(

                        children: <Widget>[
                          InkWell(  onTap: () {
                            selectedvehicleperkmprice=  results.vehicledata[index].baseFare;
                            setvehicleonmapandselectvehicel(index,"searchvehicle");
                          },  child:
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 0, bottom: 0),
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                                              aspectRatio: 1.7,
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
                                                    left: 95,
                                                    right: 16,
                                                    top: 16,
                                                  ),
                                                  child: Text(
                                                    results.vehicledata[index].type,
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
                                                left: 95,
                                                bottom: 12,
                                                top: 4,
                                                right: 16,
                                              ),
                                              child: Text(
                                                "Capacity: "+ results.vehicledata[index].capacity+"\n"+"Price: "+results.vehicledata[index].baseFare.toString()+" /km",
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
                                  top: -0,
                                  left: 20,
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset("images/bell.png"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          )],
                      ),
                      ),
                      )),
                    );
                  },
                ));
          }
        },
      );
    }catch(e)
    {
      String jj=e.toString();
    }
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

  Future _getmycurrentlocation() async {
    final location = Location();
    var currentLocation = await location.getLocation();
    setState(() {
      currentlat = currentLocation.latitude;
      currentlong = currentLocation.longitude;
      progressDialog.hide();
      startpointlatlong = new LatLng(currentlat, currentlong);
      _setvalueinstartpoint();



      /*_markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId('1111'),
        position: LatLng(currentlat, currentlong),
        draggable: true,
        infoWindow: InfoWindow(
          // title is the address

          // snippet are the coordinates of the position

        ),

        icon: BitmapDescriptor.defaultMarker,
      ));*/
      ///// SET ADDRESSS



    });
  }
  Future<void> _implementsocketio(String identifier) async {
    setState(() => _isProbablyConnected[identifier] = true);
    try {
      SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
          'http://nberindia.com:4007/',

          //Enable or disable platform channel logging
          enableLogging: false,
          transports: [Transports.WEB_SOCKET /*, Transports.POLLING*/
          ] //Enable required transport
      ));
      socket.onConnect((data) {
        pprint("connected...");
        pprint(data);
      });
      socket.onConnectError(pprint);
      socket.onConnectTimeout(pprint);
      socket.onError(pprint);
      socket.onDisconnect(pprint);
      /*socket.on("type:string", (data) => pprint("type:string | $data"));
    socket.on("type:bool", (data) => pprint("type:bool | $data"));
    socket.on("type:number", (data) => pprint("type:number | $data"));
    socket.on("type:object", (data) => pprint("type:object | $data"));
    socket.on("type:list", (data) => pprint("type:list | $data"));
    socket.on("message", (data) => pprint(data));*/
      socket.connect();
      sockets[identifier] = socket;
    }catch(e)
    {
      String s =e.toString();
    }
  }
  sendMessage(identifier) {
    if (sockets[identifier] != null) {
      pprint("sending message from '$identifier'...");
      String message='{"lat":"24.1234","lon":"75.321654","role":"user","user_id":""}';
      sockets[identifier].emit("input", [message]);
      pprint("Message emitted from '$identifier'...");
    }
  }
  sendMessageWithACK(identifier){
    pprint("Sending ACK message from '$identifier'...");
    String message='{lat:"24.1234",lon:"75.321654",role:"driver",user_id:"5dbc2a6ac455912d39014621"}';
    var resBody = {};
    resBody["lat"] = "24.1234";
    resBody["lon"] = "71.321654";
    resBody["role"] = "driver";
    resBody["user_id"] = "5dbc2a6ac455912d39014621";
    var user = {};
    user["user"] = resBody;
    String str = json.encode(resBody);
    print(str);

    List msg = ["Hello world!", 1, true, {"p":1}, [3,'r']];
    sockets[identifier].emitWithAck("input", [{
      "lat":"24.1234","lon":"79.321654","role":"driver","user_id":"5dbc2a6ac455912d39014621"
    },]).then( (data) {
      // this callback runs when this specific message is acknowledged by the server
      pprint("ACK recieved from '$identifier' for $msg: $data");
    });
  }
  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }
  pprint(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }
      print(data);
      toPrint.add(data);
    });
  }

  Future _setvalueinstartpoint() async {
    try {
      final coordinates = new Coordinates(currentlat, currentlong);
      //_starteditcontroller.text = 'fsdfsdfsd';

      starting_address =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var add = starting_address.first;
      _starteditcontroller.text = add.addressLine;
    }
    catch (e) {
      String jj = e.toString();
    }
  }


  void _updateMarker(CameraPosition _position) async {
    try {
      /* print(
          'inside updatePosition ${_position.target.latitude} ${_position.target.longitude}');
      Marker marker = _markers.firstWhere(
              (p) => p.markerId == MarkerId('1111'),
          orElse: () => null);

      _markers.remove(marker);
      _markers.add(
        Marker(
          markerId: MarkerId('1111'),
          position: LatLng(_position.target.latitude, _position.target.longitude),
          draggable: true,
          icon: BitmapDescriptor.defaultMarker,
          onDragEnd: (LatLng position) async{
            final coordinates = new Coordinates(
                position.latitude, position.longitude);
            starting_address =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
            var add = starting_address.first;
            if (startpointsearching == true) {
              _starteditcontroller.text = add.addressLine;
            }
            else
            {
              _endpointcontroller.text = add.addressLine;
            }

          },
        ),
      );
      setState(()
      {
        Marker marker= _markers.firstWhere(
                (p) => p.markerId == MarkerId('1111'));


        Toast.show(_position.toString(), context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM);

      });*/





      final coordinates = new Coordinates(
          _position.target.latitude, _position.target.longitude);
      //   _starteditcontroller.text = 'fsdfsdfsd';

      starting_address =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var add = starting_address.first;
      if (startpointsearching == true) {
        _starteditcontroller.text = add.addressLine;
      }
      else {
        _endpointcontroller.text = add.addressLine;
      }
    }
    catch (e) {
      String jj = e.toString();
    }
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      if (startpointsearching == true) {
        _starteditcontroller.text = address.first.addressLine;
        startpointlatlong = new LatLng(lat, lng);
      }
      else {
        _endpointcontroller.text = address.first.addressLine;
        endpointlatlong = new LatLng(lat, lng);
      }

      mapController_sec.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: new LatLng(lat, lng),

            zoom: 16.0,
          ),
        ),
      );

      print(lat);
      print(lng);
    }
  }

  _checklocationdistance() async {
    String startpoint = _starteditcontroller.text.toString();
    String endpoint = _endpointcontroller.text.toString();

    if (startpoint == null || startpoint.length < 0 || startpoint.isEmpty) {
      Toast.show('Select Start point', context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);
    }
    else if (endpoint == null || endpoint.length < 0 || endpoint.isEmpty) {
      Toast.show('Enter Destination', context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);
    }
    else {
      if(vehicletypeselected==true) {
        final query = endpoint;
        var addresses = await Geocoder.local.findAddressesFromQuery(query);
        endpointlatlong = new LatLng( addresses.first.coordinates.latitude,addresses.first.coordinates.longitude);






        double distance = calculateDistance(
            startpointlatlong.latitude, startpointlatlong.longitude,
            endpointlatlong.latitude, endpointlatlong.longitude);
        if (distance < 60.00) {
          ////// CREATE POLYLINES
          try {
            GoogleMapPolyline googleMapPolyline =
            new GoogleMapPolyline(apiKey: kGoogleApiKey);

            googleMapPolyline.getCoordinatesWithLocation(
                origin: startpointlatlong,
                destination: endpointlatlong,
                mode: RouteMode.driving);
          } catch (e) {
            String jj = e.toString();
          }
          ////// CALL API FOR CONFIRM BOOKING
          _CALLAPIFORCONFIRMBOOKING(startpoint,endpoint,distance);
          // mapController_sec.polylines
        }
        else {
          Toast.show('Out Of Limit', context, duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM);
        }
      }else
      {
        Toast.show('Please select any vehivle to start ride', context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM);
      }
    }
  }
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> callapiforvehiclelist()
  async{
    progressDialog.show();
    // String name= mobilenumbercontroller.text.toString();
    try {
      results = await _vehicleTypeApi.search(
          sharedprefrences.getString("USERID"),"Bearer "+sharedprefrences.getString("TOKEN"));

      String status = results.status;


      if (status == "200") {
        var count = results.vehicledata.length;
        /* Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new DashBoardFile()),
        );*/
        listViews.clear();
        for (int i = 0; i < count; i++) {
          listViews.add(
            VehicleTypeView(

              vehicletypedata: results.vehicledata[i],
            ),
          );
        }
      }
      else {
        /*Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new DashBoardFile()),
        );*/
        // Toast.show(results.message, context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
      }

    }catch(e)
    {
      progressDialog.hide();
      String jj=e.toString();
      Toast.show(jj, context,duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
    }
  }

  void setvehicleonmapandselectvehicel(int index, String searchvehicle) {
    pprint("Sending ACK message from '$searchvehicle'...");


    List msg = ["Hello world!", 1, true, {"p":1}, [3,'r']];
    String finalresult="lat:"+currentlat.toString()+",lon:"+currentlong.toString()+",vehicleType_id:"+results.vehicledata[index].id.toString()+",";
    sockets[searchvehicle].emit("nearby", [{
      "lat":currentlat.toString(),"lon":currentlong.toString(),"vehicleType_id":results.vehicledata[index].id.toString()
    },]);
    sockets[searchvehicle].on("driverList", (data){   //sample event
      //print("driver");
      print(data);

      print(data);
      try {

        String jkj=data.toString();
        final JsonDecoder _decoder = new JsonDecoder();

        //Toast.show(list.length.toString(), context,duration: Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
        mapgadiresults = new MapGadiApi.map(data);

        _markers.clear();
        if(mapgadiresults.mapgadidata.length==0)
        {
          Toast.show("Sorry, There is no any vehicle available", context,gravity:Toast.BOTTOM,duration:Toast.LENGTH_SHORT);
          vehicletypeselected=false;
        }
        else {
          vehicletypeselected=true;
          for (int i = 0; i < mapgadiresults.mapgadidata.length; i++) {
            Marker marker = _markers.firstWhere(
                    (p) =>
                p.markerId == MarkerId(mapgadiresults.mapgadidata[i].user_id),
                orElse: () => null);
            double up_lat = double.parse(mapgadiresults.mapgadidata[i].updated_lat) ;
            double up_lon = double.parse(mapgadiresults.mapgadidata[i].updated_lon );
            _markers.remove(marker);
            _markers.add(
              Marker(
                markerId: MarkerId(mapgadiresults.mapgadidata[i].user_id),
                position: LatLng(up_lat, up_lon),
                draggable: true,
                icon: mapvehicle_icon,
                onDragEnd: (LatLng position) async {
                  final coordinates = new Coordinates(
                      position.latitude, position.longitude);
                },
              ),
            );
          }
          toPrint.add(data);
        }
      }
      catch(e){
        String jj=e.toString();
        print(jj);
      }
    });





  }

  Future<void> _CALLAPIFORCONFIRMBOOKING(String startpoint,String endpoint,double distance)  async
  {
    try {
      String user_id,
          driver_id,
          from_lat = startpointlatlong.latitude.toString(),
          from_lan = startpointlatlong.longitude.toString(),
          from_address = startpoint,
          toLat = endpointlatlong.latitude.toString(),
          toLan = endpointlatlong.longitude.toString(),
          toaddress = endpoint,
          starttimestamp,
          stoptimestamp,
          mac_id,
          remark,
          ipaddress,
          token_id,
          type;
      final f = new NumberFormat("###.00");
      String totalpaymentasperkm=f.format(selectedvehicleperkmprice*distance);

      List<String> driver_id_array = [];
      for (int i = 0; i < mapgadiresults.mapgadidata.length; i++)
      {
        driver_id_array.add(mapgadiresults.mapgadidata[i].user_id.toString());
      }
      /*BookRideApi bookrideapi= new BookRideApi();
     ;
    CommonModels result= await bookrideapi.search(user_id,driver_id_array,from_lat,from_lan,from_address,toLat,toLan,toaddress,starttimestamp,stoptimestamp,mac_id, remark,ipaddress,token_id,type);
*/
      ///// GENERATE SOCKET FOR BOOKING AND RESPONSE

      SocketIOManager manager = new SocketIOManager();
      String identifiers = "BookingRequest";
      SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
          'http://nberindia.com:4007/',

          //Enable or disable platform channel logging
          enableLogging: false,
          transports: [Transports.WEB_SOCKET /*, Transports.POLLING*/
          ] //Enable required transport
      ));
      socket.onConnect((data) {
        pprint("connected...");
        pprint(data);
        ///// SEND REQUEST TO SERVER FOR BOOKING REQUEST


        showDialog(
            context: context,
            builder: (BuildContext context) =>
            new Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Consts.padding),
                ),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    //...bottom card part,
                    //...top circlular image part,

                    Container(
                      padding: EdgeInsets.only(
                        top: Consts.avatarRadius + Consts.padding,
                        bottom: Consts.padding,
                        left: Consts.padding,
                        right: Consts.padding,
                      ),
                      margin: EdgeInsets.only(top: Consts.avatarRadius),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(Consts.padding),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // To make the card compact
                        children: <Widget>[
                          Text(
                            "Total Fare:- "+totalpaymentasperkm.toString(),
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          /// FROM ADDREASSS

                          Text(
                            "Pickup:-"+from_address,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),







                          /////// BUTTON
                          SizedBox(height: 24.0),
                          //// TO ADDRESS
                          Text(
                            "Drop:-"+toaddress,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),







                          /////// BUTTON
                          SizedBox(height: 24.0),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() =>
                                search_bar = !search_bar);
                                setState(() =>
                                booking_search =
                                !booking_search);


                                int min = 100000; //min and max values act as your 6 digit range
                                int max = 999999;
                                var randomizer = new Random();
                                var rNum = min + randomizer.nextInt(max - min);

                                sec_timer=Timer.periodic(Duration(seconds: 5), (Timer t) =>

                                    _ONBOOKINGREQUESTRESPONSE(sockets,identifiers,data));

                                sockets[identifiers].emit("bookreq", [{
                                  "user_id": sharedprefrences.getString("USERID"),
                                  "driver_id": '5db04c7a56b6ae0ae461b9e8',
                                  "fromLat": from_lat,
                                  "mobile":sharedprefrences.getString("MOBILE"),
                                  "fromLon": from_lan,
                                  "fromAddress": from_address,
                                  "otp":rNum.toString(),
                                  "payment":totalpaymentasperkm,
                                  "toLat": toLat,
                                  "toLon": toLan,
                                  "toAddress": toaddress,
                                  "startTimestamp": starttimestamp,
                                   "distance":distance,
                                  "stopTimestamp": stoptimestamp,
                                  "mac_id": mac_id,
                                  "remark": remark,
                                  "ipAddress": ipaddress,

                                  "token_id": token_id,
                                  "type": type,

                                },
                                ]);

                                ///// RECEIVE BOOKING REQUEST







                                // To close the dialog
                              },
                              child: Text("Confirm Booking "),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: Consts.padding,
                      right: Consts.padding,
                      child: CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: Consts.avatarRadius,
                      ),
                    ),
                  ],

                )


            ));

      });
      socket.onConnectError(pprint);
      socket.onConnectTimeout(pprint);
      socket.onError(pprint);
      socket.onDisconnect(pprint);

      socket.connect();
      sockets[identifiers] = socket;
    }
    catch(e)
    {
      String jj=e.toString();
    }








  }

  Future<Null> checkforsharedprefs() async  {
    sharedprefrences = await SharedPreferences.getInstance();
    if(sharedprefrences.getString("ROLE")=="driver")
    {
      isuserisbooker=false;
      isuserisdriver=true;

      driver_startsockerforsendrequestforbooking();
      // showbottomsheetdialogfordriverlayout();
      final location =new Location();
      location.onLocationChanged().listen((LocationData currentLocation) {
        print(currentLocation.latitude);
        print(currentLocation.longitude);
        currentlat = currentLocation.latitude;
        currentlong = currentLocation.longitude;

        startpointlatlong = new LatLng(currentlat, currentlong);
        mapController_sec.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: new LatLng(currentlat, currentlong),

              zoom: 16.0,
            ),
          ),
        );

        //_updatedriverlatlongbysocket(currentlat,currentlong);

      });

    }
    else
    {
      isuserisbooker=true;
      isuserisdriver=false;
      checkpoendingpaymentongoingbookingorfeedbackdetail();
    }
    callapiforvehiclelist();
    _getmycurrentlocation();
  }

  Future<void> _updatedriverlatlongbysocket(currentlat, currentlong) async {
    String identifier="default";
    setState(() => _isProbablyConnected[identifier] = true);
    SocketIOManager manager  = SocketIOManager();
    try {
      SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
          'http://nberindia.com:4007/',

          //Enable or disable platform channel logging
          enableLogging: false,
          transports: [Transports.WEB_SOCKET /*, Transports.POLLING*/
          ] //Enable required transport
      ));
      socket.onConnect((data) {
        pprint("connected...");
        pprint(data);

        sockets[identifier].emit("input", [{
          "lat":currentlat,"lon":currentlong,"role":sharedprefrences.getString("ROLE"),"user_id":sharedprefrences.getString("USERID")
        },]);
        sockets[identifier].on("driver" , (data){   //sample event
          print("driver");
          print(data);
        });



      });
      socket.onConnectError(pprint);
      socket.onConnectTimeout(pprint);
      socket.onError(pprint);
      socket.onDisconnect(pprint);
      /*socket.on("type:string", (data) => pprint("type:string | $data"));
    socket.on("type:bool", (data) => pprint("type:bool | $data"));
    socket.on("type:number", (data) => pprint("type:number | $data"));
    socket.on("type:object", (data) => pprint("type:object | $data"));
    socket.on("type:list", (data) => pprint("type:list | $data"));
    socket.on("message", (data) => pprint(data));*/
      socket.connect();
      sockets[identifier] = socket;
    }catch(e)
    {
      String s =e.toString();
    }

  }

  void  _ONBOOKINGREQUESTRESPONSE(Map<String, SocketIO> sockets,String identifier,data) {
    Toast.show('timer working',context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);

    sockets[identifier].on("SENDRESPOSETOUSERFORBOOKINGREQUEST", (data) { //sample event
      print("driver");
      print("bookingreqresponse"+data);
      Toast.show('SENDRESPOSETOUSERFORBOOKINGREQUEST',context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);
      // sec_timer.cancel();
      /*manager.clearInstance(sockets[identifier]);
                                  setState(() => _isProbablyConnected[identifier] = false);

                                */

    });
    //Toast.show('Booking Accepted by driver', context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);
  }

  Future<void> driver_startsockerforsendrequestforbooking() async {
    ////// CAL REQUEST SOCKET IN EVERY SECONDFOR BOOKING REQUEST

    String identifier="bookingrequestfordriver";
    setState(() => _isProbablyConnected[identifier] = true);
    SocketIOManager manager  = SocketIOManager();
    try {
      SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
          'http://nberindia.com:4007/',

          //Enable or disable platform channel logging
          enableLogging: false,
          transports: [Transports.WEB_SOCKET /*, Transports.POLLING*/
          ] //Enable required transport
      ));
      socket.onConnect((data) {
        pprint("connected...");
        pprint(data);

        driver_timer=Timer.periodic(Duration(seconds: 5), (Timer t) => startsocket_fordriver(sockets,identifier,manager,_isProbablyConnected),);
        /*sockets[identifier].emit("input", [{
                 "lat":currentlat,"lon":currentlong,"role":sharedprefrences.getString("ROLE"),"user_id":sharedprefrences.getString("USERID")
               },]);
               sockets[identifier].on("driver" , (data){   //sample event
                 print("driver");
                 print(data);
               });*/



      });
      socket.onConnectError(pprint);
      socket.onConnectTimeout(pprint);
      socket.onError(pprint);


      socket.connect();
      sockets[identifier] = socket;
    }catch(e)
    {
      String s =e.toString();
    }





  }

  startsocket_fordriver(Map<String, SocketIO>  socket , String identifier, SocketIOManager manager, Map<String, bool> isProbablyConnected) {
    Toast.show('driver in every second call toast',context,duration:Toast.LENGTH_SHORT,gravity: Toast.CENTER);

    socket[identifier].emit("driverbookingrequest", [{
      "driver_id":sharedprefrences.getString("USERID"),"booking_id":null
    },]);
    socket[identifier].on("driverbookingresponse" , (data)
    {
       Toast.show('driver booking response',context,duration:Toast.LENGTH_SHORT,gravity: Toast.CENTER);
      print("driverbookingresponse"+data);
       manager.clearInstance(socket[identifier]);
      setState(() => isProbablyConnected[identifier] = false);

      //  Toast.show(user_id,context,duration: Toast.LENGTH_SHORT,gravity:Toast.CENTER);

      driver_timer.cancel();

      //sample event
      if(booking_request_driver_dialog==false) {
        booking_request_driver_dialog=true;
        _createdriverbookingrequestdialogandresponse(sockets, identifier, data);
      }});

  }

  void _createdriverbookingrequestdialogandresponse(Map<String, SocketIO> sockets , String identifier, data) {


    ///// TESTING DIALOG BOX START HERE
    showDialog(barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
        new Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Consts.padding),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                //...bottom card part,
                //...top circlular image part,

                Container(
                  padding: EdgeInsets.only(
                    top: Consts.avatarRadius + Consts.padding,
                    bottom: Consts.padding,
                    left: Consts.padding,
                    right: Consts.padding,
                  ),
                  margin: EdgeInsets.only(top: Consts.avatarRadius),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(Consts.padding),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // To make the card compact
                    children: <Widget>[
                      Text(
                        "Hello you have new booking , Please accept it as soon otherwise it will forward to other driver",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      /// FROM ADDREASSS
                      Text(
                        "Pickup:-"+data["fromAddress"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      //// TO ADDRESS
                      Text(
                        "Drop:-"+data["toAddress"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      /// TOTAL PAYBLE


                      //// INSURANCE PREMIUM







                      /////// BUTTON
                      SizedBox(height: 24.0),
                      Row(children:<Widget>[
                        Expanded(

                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              booking_request_driver_dialog=false;
                              callapimethodfordriverresponsebooking(false,data);
                              // To close the dialog
                            },
                            child: Text("Cancel",style: TextStyle(
                                fontSize: 16.0,color: Colors.red
                            ),),
                          ),
                        ),
                        Expanded(

                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              callapimethodfordriverresponsebooking(true,data);
                              // To close the dialog
                            },
                            child: Text("Accept",style: TextStyle(
                                fontSize: 16.0,fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ])

                    ],
                  ),
                ),
                Positioned(
                  left: Consts.padding,
                  right: Consts.padding,
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: Consts.avatarRadius,
                  ),
                ),
              ],

            )


        ));
    ///// TESTING DIALOG BOX END HERE





  }

  void callapimethodfordriverresponsebooking(bool acceptedornot, datas) async
  {
    String identifier = "driverbookingresponse";
    setState(() => _isProbablyConnected[identifier] = true);
    SocketIOManager manager = SocketIOManager();
    try {
      SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
          'http://nberindia.com:4007/',

          //Enable or disable platform channel logging
          enableLogging: false,
          transports: [Transports.WEB_SOCKET /*, Transports.POLLING*/
          ] //Enable required transport
      ));
      socket.onConnect((data) {

        if (acceptedornot == true) {
          sockets[identifier].emit("driverresponse", [{
            "value": 'true'
          },
          ]);

          manager.clearInstance(sockets[identifier]);
          setState(() => _isProbablyConnected[identifier] = false);
          //showbottomsheetdialogfordriverlayout(data);
          showbottomsheetdialogfordriverlayout(datas);
        }
        else {
          sockets[identifier].emit("driverresponse", [{
            "value": 'false'
          },
          ]);
          manager.clearInstance(sockets[identifier]);
          setState(() => _isProbablyConnected[identifier] = false);
        }
      });
      socket.onConnectError(pprint);
      socket.onConnectTimeout(pprint);
      socket.onError(pprint);


      socket.connect();
      sockets[identifier] = socket;
    } catch (e) {
      String s = e.toString();
    }
  }

  void showbottomsheetdialogfordriverlayout(datas) {
    String user_id=datas["user_id"];
    String otp=datas["otp"];
    double fromlat=datas["fromLat"];
    double fromlan=datas["fromLon"];
    double tolat=datas["toLat"];
    double tolan=datas["toLon"];
    String user_mobileno=datas["mobile"];
    sharedprefrences.setString("booking_id",datas["booking_id"]);
    showBottomSheet(

        context: context,
        builder: (BuildContext bc){
          return Container(margin: const EdgeInsets.only(bottom: 10),
            child: new Wrap(
              children: <Widget>[
                new Row(children:<Widget>[
                  Expanded( flex:1, child: Container(margin: const EdgeInsets.only(left: 5,right:5,top:5) ,alignment: Alignment.center,
                    height: 40,
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
                          if(ridestart==false) {
                            _openotpverificationdialogbox(otp);
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "$ride_statue_button",
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
                  )),
                  Expanded( flex:1, child:Container(margin: const EdgeInsets.only(left: 5,right:5,top:5) ,alignment: Alignment.center,
                    height: 40,
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
                          if(ridestart==false){
                            UrlLauncher.launch("google.navigation:q=${fromlat},${fromlan}");
                          }
                          else{
                            UrlLauncher.launch("google.navigation:q=${tolat},${tolan}");
                          }

                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Start Map',
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
                  ))]),
                new Row(children:<Widget>[
                  Expanded( flex:1, child: Container(margin: const EdgeInsets.only(left: 5,right:5,top:5) ,alignment: Alignment.center,
                    height: 40,
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
                          UrlLauncher.launch('tel:'+user_mobileno);

                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  ' Call TO User',
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
                  )),
                  Expanded( flex:1, child: Container(margin: const EdgeInsets.only(left: 5,right:5,top:5) ,alignment: Alignment.center,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red,
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
                  ))]),
              ],
            ),
          );
        }
    );


  }

  void _openotpverificationdialogbox(String otp) {
    var otpcontroller= new TextEditingController();
    showDialog(barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
        new Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Consts.padding),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                //...bottom card part,
                //...top circlular image part,

                Container(
                  padding: EdgeInsets.only(
                    top: Consts.padding,
                    bottom: Consts.padding,
                    left: Consts.padding,
                    right: Consts.padding,
                  ),
                  margin: EdgeInsets.only(top: Consts.avatarRadius),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(Consts.padding),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // To make the card compact
                    children: <Widget>[
                      Text(
                        "Verify OTP to Start Ride",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      /// FROM ADDREASSS
                      TextFormField(controller: otpcontroller,inputFormatters: [LengthLimitingTextInputFormatter(6),],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.phone,
                          obscureText: false,
                          style: TextStyle(color: Colors.black,fontSize: 16,),
                          decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(15.00),borderSide: new BorderSide(color: Colors.black)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15.0),),contentPadding: EdgeInsets.only(left:10,top:5,right:10,bottom:5),hintText: "Enter 6 Digit OTP"
                          )),






                      /////// BUTTON
                      SizedBox(height: 24.0),
                      Row(children:<Widget>[
                        Expanded(

                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();

                              // To close the dialog
                            },
                            child: Text("Cancel",style: TextStyle(
                                fontSize: 16.0,color: Colors.red
                            ),),
                          ),
                        ),
                        Expanded(

                          child: FlatButton(
                            onPressed: () {

                              String enterotp= otpcontroller.text.toString();
                              if(enterotp.length<6){
                                Toast.show("Enter Valid OTP", context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);
                              }
                              else{
                                if(otp==enterotp){
                                  ridestart=true;
                                  setState(() {
                                    ride_statue_button = 'Complete Ride';
                                  });
                                  Toast.show("OTP Verify Successfullty", context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);
                                }
                              }

                              Navigator.of(context).pop();


                              // To close the dialog
                            },
                            child: Text("Submit",style: TextStyle(
                                fontSize: 16.0,fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ])

                    ],
                  ),
                ),

              ],

            )


        ));

  }

  void checkpoendingpaymentongoingbookingorfeedbackdetail() {

  }
}
Future<bool> getData() async {
  await Future.delayed(const Duration(milliseconds: 1000));
  return true;
}
Future<bool> getDatas() async {
  await Future.delayed(const Duration(milliseconds: 1000));
  return true;
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
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