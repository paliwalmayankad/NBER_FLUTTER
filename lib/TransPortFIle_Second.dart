import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:toast/toast.dart';
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
import 'CoordinateUtil.dart';
import 'CustomDialog.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'GenralMessageDialogBox.dart';
import 'Models/VehicletypeModels.dart';
import 'MyColors.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart' ;
import 'Steps.dart';
import 'Utils/Constants.dart';
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
  int selectedRadio=1;
  int _groupValue = -1;
  int totallistforvehicle=0;
  bool driver_infowithotp = false;
  ProgressDialog progressDialog;
  BitmapDescriptor myIcon;
  StreamSubscription<DocumentSnapshot> driver_bookinglistner;
  StreamSubscription<DocumentSnapshot> driver_bookinglistner_sec;
  StreamSubscription<DocumentSnapshot> driver_latlngupdatetouserlistner;

  BitmapDescriptor mapvehicle_icon;
  BitmapDescriptor   starticon;
  BitmapDescriptor endicobn;
  SocketIOManager manager;
  bool ridestart=false;
  int cashmodevalue;
  DocumentSnapshot driver_detail_data;
  Map<String,dynamic> my_booking_Deteail_Data;

  Map<String,dynamic> driver_booking_header_datas;
  bool userisdriver=false;
  bool booking_request_driver_dialog=false;
  Timer driver_timer,sec_timer;
  var textController_ridestatus = new TextEditingController();
  MapGadiApi mapgadiresults;
  String paymentmodefinal;
  double selectedvehicleperkmprice;
  List<String> toPrint = ["trying to connect"];
  Map<String, SocketIO> sockets = {};
  Map<String, bool> _isProbablyConnected = {};
  var currentlat, currentlong;
  MarkerId markerId;
  List<VehicleTypeDatases> vehicledata;
  String ride_statue_button="Start Ride";
  bool vehicletypeselected=false;
  VehicletypeModels results;
  var starting_address;
  var ending_address;
  bool driveractivestatus=false;
  VehicleTypeApi _vehicleTypeApi;
  LatLng startpointlatlong, endpointlatlong;
  final Set<Marker> _markers = {};
  final Set<Marker> startendmarker = {};

  final Set<Polyline>_polyline={};
  Animation<double> topBarAnimation;
  ControllerCallback cab;
  bool startpointsearching = true;
  bool showbottomsheetdialog=true;
  bool endpointsearching = false;
  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool isuserisbooker=false;
  bool isuserisdriver=false;
  String driver_vehicleno="",driver_vehicle_detail="",ride_otp="",
      driver_name=""
  , driver_totalreview=""
  ,driver_image=""
  ,driver_vehicle_image="",string_label_start_address="",string_label_end_address="";

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
  PanelController _pc = new PanelController();

  @override
  void initState()  {
    _starteditcontroller = new TextEditingController();
    _endpointcontroller = new TextEditingController();
    _vehicleTypeApi=new VehicleTypeApi();
    vehicledata=new List();
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
    //// START ICON
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(20, 20)), 'images/startblack.png')
        .then((onValue) {
      starticon = onValue;
    });
    //// END ICON
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(20, 20)), 'images/endyellow.png')
        .then((onValue) {
      endicobn = onValue;
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
                                : Scaffold(
                                body: Center(child: Stack(
                                children: <Widget>[
                                  new Container(child: GoogleMap(
                                    mapType: MapType.normal,
                                    zoomGesturesEnabled: true,
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
                                    markers: _markers,


                                    trafficEnabled: false,

                                    /*onCameraMove: ((_position) =>
                                        _updateMarker(_position.target)),*/


                                    gestureRecognizers: <
                                        Factory<OneSequenceGestureRecognizer>>[
                                      new Factory<
                                          OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                                    ].toSet(),


                                  ),),
                                  /*  new Container(alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: Image.asset(
                                        'images/start ride.png', height: 35,
                                        width: 35,)),*/
                                ])),
                              floatingActionButton:isuserisbooker==true? Container(child:search_bar==true?
                              FloatingActionButton(
                                onPressed: () {
                                  _checklocationdistance();
                                },

                                child: Icon(Icons.arrow_forward),
                                backgroundColor: Colors.black, ):SizedBox()):driveractivestatus==true?FloatingActionButton.extended(
                                onPressed: () {
                                 _updatedriverstatus(true);
                                },
                                   label: Text('Active'),
                                icon: Icon(Icons.signal_wifi_4_bar),
                                backgroundColor: Colors.black, ):
                              FloatingActionButton.extended(
                                onPressed: () {
                                  _updatedriverstatus(false);
                                },

                                label: Text('Deactive'),
                                icon: Icon(Icons.signal_wifi_off),
                                backgroundColor: Colors.black, ),);
                          }
                        },
                      )


                  ),
                  isuserisbooker ? new Container(

                      child:
                          Column(children: <Widget>[

                      SlidingUpPanel( controller: _pc,
                          panel:BottomAppBar (

                            child:SingleChildScrollView(child: Column(children: <Widget>[

                              search_bar ? new Container(width:double.infinity,
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
                                                          .all(0),
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
                                                              child: InkWell(
                                                                  onTap: (){
                                                                    _getmycurrentlocation();
                                                                  },
                                                                  child:Image
                                                                      .asset(
                                                                    'images/currentlocation.png',
                                                                    width: 20,
                                                                    height: 20,)),),

                                                          ]))
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    new Container(
                                      margin: const EdgeInsets.only(top: 5),
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
                                                          .all(0),
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
                                                                 // _checklocationdistance();
                                                                },
                                                                child: Image
                                                                    .asset(
                                                                  'images/search.png',
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

                                    new Container(width:double.infinity,
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 0),


                                        child:Container(width:double.infinity,





                                            child:getMainListViewUI()),





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

                                                      _cancelbyuserupdatestatusandnotifytodriver();


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
                                    SizedBox(height:5),
                                    Align(alignment: Alignment
                                        .center,
                                      child: Text(ride_otp,
                                        textAlign: TextAlign
                                            .center,
                                        style: TextStyle(
                                            color: Colors
                                                .black87,
                                            fontSize: 16,fontWeight: FontWeight.bold),),
                                    ),
                                    SizedBox(height:5),
                                    Align(alignment: Alignment.topLeft,
                                        child: new Row(children: <Widget>
                                        [
                                          Expanded(flex: 1,
                                              child: new Column(
                                                  children: <Widget>[

                                                    Align(alignment: Alignment
                                                        .centerLeft,
                                                      child: Text(driver_vehicleno,
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
                                                        driver_vehicle_detail,
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
                                                                      driver_name,
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
                                                                      driver_totalreview,
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
                                                                          Container(
                                                                            height: 50,
                                                                            width: 50,
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
                                                                              child: driver_image!=null?Image.network(driver_image,fit: BoxFit.fill,):Image.asset('images/yellow_logo.png'),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height: 50,
                                                                            width: 50,
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
                                                                              child: driver_vehicle_image!=null?Image.network(driver_vehicle_image,fit: BoxFit.fill,):Image.asset('images/yellow_logo.png'),
                                                                            ),
                                                                          ),
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
                                                    onTap: () {
                                                      //// FOR CALL TO DRIVER

                                                      UrlLauncher.launch('tel:'+driver_detail_data['driver_mobile']);



                                                    },
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
                                                    onTap: () {



                                                      _user_cancel_my_ride();
                                                    },
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
                                                    onTap: () {
                                                      String message_for_share_detail='Hello , im on ride in NBER with '+driver_detail_data['driver_name']
                                                          +" \n from - "+my_booking_Deteail_Data['from_address']+"\n"+
                                                          "to - "+my_booking_Deteail_Data['from_address']+"\n"+
                                                          "Driver Name- "+driver_detail_data['driver_name']+"\n"+
                                                          "Vehicle No - "+driver_detail_data['vehicle_number']+"\n"+
                                                          "Driver Mobile - "+driver_detail_data['driver_mobile']+" \n please check me out if im in trouble";
                                                      Share.share(message_for_share_detail);



                                                    },
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
                                                              child: Text(string_label_start_address,maxLines: 2,style: TextStyle(color:Colors.black
                                                              ),),
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
                                                              child: Text(string_label_end_address,maxLines: 2,style: TextStyle(color:Colors.black
                                                              ),),
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
                          ))],)

                  ):SizedBox()],
              ),
            );
          }
        },
      ),


      bottomNavigationBar: userisdriver==true?showbottomsheetdialogfordriverlayout():SizedBox(),
    );
  }
  Widget getMainListViewUI() {
    try {
      return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(width: double.infinity,);
          } else {
            return  Container(
                child: ListView.builder(shrinkWrap: true,
                  controller: scrollController,

                  //  itemCount: results.vehicledata.length,
                  itemCount: totallistforvehicle,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    // widget.animationController.forward();
                    // return listViews[index];
                    return Align(
                        alignment: Alignment.topLeft,child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width*100,

                      margin: const EdgeInsets.only(left:10,right:10),

                      child:   new Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,

                        children: <Widget>[
                          InkWell(  onTap: () {
                            selectedvehicleperkmprice=  vehicledata[index].baseFare;
                            setvehicleonmapandselectvehicel(index,"searchvehicle");
                          },  child:Container(height:400, child:
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 0, bottom: 0),
                            child: Stack(

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
                                            Row(mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 95,
                                                    right: 16,
                                                    top: 16,
                                                  ),
                                                  child: Text(
                                                    vehicledata[index].type,
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
                                                "Capacity: "+vehicledata[index].capacity+"\n"+"Price: "+vehicledata[index].baseFare.toString()+" /km",
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
                                    width: 60,
                                    height: 50,
                                    child: Image.network( vehicledata[index].icon,fit: BoxFit.fill,),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          ))],


                      ),
                    ));
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
      progressDialog.dismiss();
      startpointlatlong = new LatLng(currentlat, currentlong);
      _updatedriverlatlongbysocket(currentlat,currentlong);

      /* Marker marker = _markers.firstWhere(
              (p) =>
          p.markerId == MarkerId("startpointmarker"),
          orElse: () => null);
      _markers.remove(marker);
      _markers.add(
        Marker(

          markerId: MarkerId("startmarker"),
          position: LatLng(currentlat,currentlong),
          draggable: true,
          icon: starticon,
          onDragEnd: (LatLng position) async {
            final coordinates = new Coordinates(
                position.latitude, position.longitude);
          },
        ),
      );*/


      _setvalueinstartpoint();


      Marker marker = _markers.firstWhere(
              (p) =>
          p.markerId == MarkerId('startpointmarker'),
          orElse: () => null);
      _markers.remove(marker);
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId('startpointmarker'),
        position: LatLng(currentlat, currentlong),
        draggable: false,
        infoWindow: InfoWindow(
          // title is the address

          // snippet are the coordinates of the position

        ),

        icon: starticon,
      ));
      mapController_sec.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: new LatLng(currentlat, currentlong),

            zoom: 12.0,
          ),
        ),
      );
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


  void _updateMarker(LatLng target ) async {
    try {
      /*  print(
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
          target.latitude, target.longitude);
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
      _polyline.clear();
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      if (startpointsearching == true) {

        _starteditcontroller.text = address.first.addressLine;
        startpointlatlong = new LatLng(lat, lng);
        Marker marker = _markers.firstWhere(
                (p) =>
            p.markerId == MarkerId('startpointmarker'),
            orElse: () => null);
        _markers.remove(marker);
        _markers.add(
          Marker(

            markerId: MarkerId('startpointmarker'),
            position: LatLng(lat,lng),
            draggable: false,
            icon: starticon,
            onDragEnd: (LatLng position) async {
              final coordinates = new Coordinates(
                  position.latitude, position.longitude);
            },
          ),
        );









      }
      else {
        _endpointcontroller.text = address.first.addressLine;

        endpointlatlong = new LatLng(lat, lng);
        Marker marker = _markers.firstWhere(
                (p) =>
            p.markerId == MarkerId('endmarker'),
            orElse: () => null);
        _markers.remove(marker);
        _markers.add(
          Marker(

            markerId: MarkerId('endmarker'),
            position: LatLng(lat, lng),
            draggable: false,
            icon: endicobn,
            onDragEnd: (LatLng position) async {
              final coordinates = new Coordinates(
                  position.latitude, position.longitude);
            },
          ),
        );

        //Toast.show("PANNEL UP CALL",context,duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
        _pc.open();



      }

      mapController_sec.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: new LatLng(lat, lng),

            zoom: 16.0,
          ),
        ),
      );


    }
  }

  _checklocationdistance() async {

    //// TESTING FOR ADD DAT IN FIREBASE ARRRAY LIST
    //a({"mybookinglist":['a']});






    String startpoint = _starteditcontroller.text.toString();
    String endpoint = _endpointcontroller.text.toString();

    if (startpoint == null || startpoint.length < 0 || startpoint.isEmpty) {

      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Plesse Enter Start Point to Book Ride",),
      );
    }
    else if (endpoint == null || endpoint.length < 0 || endpoint.isEmpty) {
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Plesse Enter Destination to Book Ride",),
      );
    }
    else {
      if(vehicletypeselected==true) {
        final query = endpoint;
        var addresses = await Geocoder.local.findAddressesFromQuery(query);
        endpointlatlong = new LatLng( addresses.first.coordinates.latitude,addresses.first.coordinates.longitude);






        double distance = calculateDistance(
            startpointlatlong.latitude, startpointlatlong.longitude,
            endpointlatlong.latitude, endpointlatlong.longitude);
        /* double distance = await Geolocator().distanceBetween(startpointlatlong.latitude, startpointlatlong.longitude,
           endpointlatlong.latitude, endpointlatlong.longitude);*/

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

          showDialog(barrierDismissible: false,
              context: context,
              builder: (_) => GeneralMessageDialogBox(Message: "Sorry, you can Book Ride Under 60 Kms ",
              ));
        }
      }else
      {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message: "Please select any vehicle to Book ride",
            ));
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
  async {
    //progressDialog.show();
    // String name= mobilenumbercontroller.text.toString();

    //// FOR FIREBASE


    /* progressDialog.show();
      sharedprefrences = await SharedPreferences.getInstance();
      String token="Bearer "+sharedprefrences.getString("TOKEN");
       vehicletypemodel = await _callapiforvehicle.search(token);
      String status = vehicletypemodel.status;
      String message = vehicletypemodel.message;
*/
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("vehicle_type")
        .getDocuments()
    ;
    var list = querySnapshot.documents;
    totallistforvehicle=list.length;
    try {
      for (int i = 0; i < list.length; i++) {
        _setvaluetolist(list[i].data);
      }
    } catch (e) {
      print(e);
      String ss = e.toString();
    }
    ////


    /* results = await _vehicleTypeApi.search(
          sharedprefrences.getString("USERID"),"Bearer "+sharedprefrences.getString("TOKEN"));

      String status = results.status;


      if (status == "200") {
        progressDialog.dismiss();
        var count = results.vehicledata.length;
        VehicleTypeDatases data=new VehicleTypeDatases();
        String gender=sharedprefrences.getString("GENDER");
        if(gender=="male"||gender=="Male"){
          listViews.clear();
          for (int i = 0; i < count; i++)
          {
            if(results.vehicledata[i].type!="scooty"||results.vehicledata[i].type!="scooty"||results.vehicledata[i].type!="scooty")
            listViews.add(VehicleTypeView(

              vehicletypedata: results.vehicledata[i],
            ),);
          }
        }
        else
          {
          listViews.clear();
          for (int i = 0; i < count; i++)
          {
            listViews.add(VehicleTypeView(

              vehicletypedata: results.vehicledata[i],
            ),);
          }
        }*/




  }

  Future<void> setvehicleonmapandselectvehicel(int index, String searchvehicle) async {

    String enddestination =_endpointcontroller.text.toString();
    if (enddestination == null || enddestination.length < 0 || enddestination.isEmpty) {

      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message: "Enter Destination to Start Ride",
          ));
    }
    else {
      pprint("Sending ACK message from '$searchvehicle'...");
      for (int i = 0; i < _markers.length; i++) {


        if (_markers
            .elementAt(i)
            .markerId.value == 'startpointmarker' || _markers
            .elementAt(i)
            .markerId.value == 'endmarker') {


        }
        else {

          Marker marker = _markers.firstWhere(
                  (p) =>
              p.markerId ==
                  MarkerId(_markers
                      .elementAt(i).markerId.value),
              orElse: () => null);

          _markers.remove(marker);



        }
      }



      try {


        //Toast.show(list.length.toString(), context,duration: Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
        ///// HERE WE CALL FIREBASE VEHICLE NEARBY VEHICLE LIST
        var list;
        try {
          QuerySnapshot querySnapshot = await  Firestore.instance
              .collection('driver').where('vehicle_type', isEqualTo: vehicledata[index].type).where('driver_status',isEqualTo:'free').getDocuments();
          ;
          final JsonDecoder _decoder = new JsonDecoder();
          list = querySnapshot.documents;
          //String jkj = data.toString();


          /*for (int i = 0; i < list.length; i++) {
              _setvaluetolist(list[i].data);
            }*/
        }catch(e){
          print(e);
          String ss=e.toString();
        }


        ////// FIREBASE VEHICLELIST CALL END





        mapgadiresults = new MapGadiApi.documentSnapShot(list);

        // _markers.clear();
        //// CHECK DRIVER LOCATION IN KM
        if(mapgadiresults.mapgadidata.length>0){
          for(int i=0;i<mapgadiresults.mapgadidata.length;i++) {
            double distance = calculateDistance(
                startpointlatlong.latitude, startpointlatlong.longitude,
                double.parse(mapgadiresults.mapgadidata[i].updated_lat),
                double.parse(mapgadiresults.mapgadidata[i].updated_lon));


            if (distance > 10.00) {
              mapgadiresults.mapgadidata.removeAt(i);
            }
          }
        }

        print("STARTLATLONG"+startpointlatlong.toString());
        if (mapgadiresults.mapgadidata.length == 0) {
          showDialog(barrierDismissible: false,
              context: context,
              builder: (_) => GeneralMessageDialogBox(Message: "Sorry, There is no any vehicle available",
              ));
          vehicletypeselected = false;
        }
        else {
          _polyline.clear();

          vehicletypeselected = true;




          if(vehicledata[index].category=="car") {
            BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(20, 20)), 'images/car_icon.png')
                .then((onValue) {
              mapvehicle_icon = onValue;
            });
          }
          else if(vehicledata[index].category=="two-wheeler"||vehicledata[index].category=="bike"){
            BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(20, 20)), 'images/bike_icon.png')
                .then((onValue) {
              mapvehicle_icon = onValue;
            });
          }
          else if(vehicledata[index].category=="auto"){
            BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(20, 20)), 'images/auto_icon.png')
                .then((onValue) {
              mapvehicle_icon = onValue;
            });
          }
          else if(vehicledata[index].category=="e-auto"){
            BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(20, 20)), 'images/E-rick_icon.png')
                .then((onValue) {
              mapvehicle_icon = onValue;
            });
          }
          else if(vehicledata[index].category=="scooty"){
            BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(20, 20)), 'images/scooty_icon.png')
                .then((onValue) {
              mapvehicle_icon = onValue;
            });
          }





          for (int i = 0; i < mapgadiresults.mapgadidata.length; i++) {
            if(i==0){
              double oldlat= double.parse(mapgadiresults.mapgadidata[i].updated_lat);
              double oldlng=double.parse(mapgadiresults.mapgadidata[i].updated_lon);
            var driverresponse=  Firestore.instance.collection('driver').document(mapgadiresults.mapgadidata[i].documentid.toString());
            driverresponse.snapshots().listen((querySnapshot) async {
              /// FIRST CHECK DRIVER LOCATION WITH USER CURENT LATLONG
              double driver_updatelat=double.parse(querySnapshot.data['driver_lat']);
              double driver_updatelong=double.parse(querySnapshot.data['driver_lng']);

              double distance = calculateDistance(
                  startpointlatlong.latitude, startpointlatlong.longitude,
                  driver_updatelat, driver_updatelong);
              if(distance<5){

                Marker marker = _markers.firstWhere(
                        (p) =>
                    p.markerId ==
                        MarkerId(mapgadiresults.mapgadidata[i].user_id),
                    orElse: () => null);
                double up_lat = double.parse(
                    mapgadiresults.mapgadidata[i].updated_lat);
                double up_lon = double.parse(
                    mapgadiresults.mapgadidata[i].updated_lon);
                _markers.remove(marker);




                ///

                double dLon = (driver_updatelong-oldlng);
                double y = sin(dLon) * cos(driver_updatelat);
                double x = cos(oldlat)*sin(driver_updatelat) - sin(oldlat)*cos(driver_updatelat)*cos(dLon);
                double brng = ((atan2(y, x)));
                brng = (360 - ((brng + 360) % 360));
                print("brng"+brng.toString());





                final _latTween = Tween<double>(
                    begin: oldlat, end: driver_updatelat);
                final _lngTween = Tween<double>(
                    begin: oldlng, end: driver_updatelong);
                final _zoomTween = Tween<double>(begin: 20.0, end: 20.0);
                var controller = AnimationController(
                    duration: const Duration(milliseconds: 1500), vsync: this);
                // The animation determines what path the animation will take. You can try different Curves values, although I found
                // fastOutSlowIn to be my favorite.
                Animation<double> animation =
                CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
                /* controller.addListener(() {
          mapController_sec.move(
              LatLng(updatelat.evaluate(animation), _lngTween.evaluate(animation)),
              _zoomTween.evaluate(animation));
        });*/


                _markers.add(Marker(
                  // This marker id can be anything that uniquely identifies each marker.
                  markerId: MarkerId(mapgadiresults.mapgadidata[i].user_id),
                  position: LatLng(driver_updatelat, driver_updatelong),
                  draggable: false,
                  rotation:brng,

                  infoWindow: InfoWindow(
                    // title is the address

                    // snippet are the coordinates of the position

                  ),

                  icon: mapvehicle_icon,
                ));

                controller.addListener(() {

                  mapController_sec.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: new LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),

                          zoom: _zoomTween.evaluate(animation)),
                    ),);
                  });



                  ///









                //// OLD CONDITION
                oldlat=driver_updatelat;
                oldlng=driver_updatelong;
                /*_markers.add(
                  Marker(

                    markerId: MarkerId(mapgadiresults.mapgadidata[i].user_id),
                    position: LatLng(driver_updatelat, driver_updatelong),
                    draggable: true,
                    icon: mapvehicle_icon,
                    onDragEnd: (LatLng position) async {
                      final coordinates = new Coordinates(
                          position.latitude, position.longitude);
                    },
                  ),
                );*/
///// OLD CONDITION END HERE
              }
              else{

                Marker marker = _markers.firstWhere(
                        (p) =>
                    p.markerId ==
                        MarkerId(mapgadiresults.mapgadidata[i].user_id),
                    orElse: () => null);

                _markers.remove(marker);
              //  mapgadiresults.mapgadidata.removeAt(0);

              }


            });
            }
            else if(i==1){
              double oldlat=double.parse(mapgadiresults.mapgadidata[i].updated_lat);
              double oldlng=double.parse(mapgadiresults.mapgadidata[i].updated_lon);
              var driverresponse=  Firestore.instance.collection('driver').document(mapgadiresults.mapgadidata[i].documentid.toString());
              driverresponse.snapshots().listen((querySnapshot) async {
                /// FIRST CHECK DRIVER LOCATION WITH USER CURENT LATLONG
                double driver_updatelat=double.parse(querySnapshot.data['driver_lat']);
                double driver_updatelong=double.parse(querySnapshot.data['driver_lng']);

                double distance = calculateDistance(
                    startpointlatlong.latitude, startpointlatlong.longitude,
                    driver_updatelat, driver_updatelong);
                if(distance<5){

                  Marker marker = _markers.firstWhere(
                          (p) =>
                      p.markerId ==
                          MarkerId(mapgadiresults.mapgadidata[i].user_id),
                      orElse: () => null);
                  double up_lat = double.parse(
                      mapgadiresults.mapgadidata[i].updated_lat);
                  double up_lon = double.parse(
                      mapgadiresults.mapgadidata[i].updated_lon);
                  _markers.remove(marker);
                  double dLon = (driver_updatelong-oldlng);
                  double y = sin(dLon) * cos(driver_updatelat);
                  double x = cos(oldlat)*sin(driver_updatelat) - sin(oldlat)*cos(driver_updatelat)*cos(dLon);
                  double brng = ((atan2(y, x)));
                  brng = (360 - ((brng + 360) % 360));
                  print("brng"+brng.toString());





                  final _latTween = Tween<double>(
                      begin: oldlat, end: driver_updatelat);
                  final _lngTween = Tween<double>(
                      begin: oldlng, end: driver_updatelong);
                  final _zoomTween = Tween<double>(begin: 20.0, end: 20.0);
                  var controller = AnimationController(
                      duration: const Duration(milliseconds: 1500), vsync: this);
                  // The animation determines what path the animation will take. You can try different Curves values, although I found
                  // fastOutSlowIn to be my favorite.
                  Animation<double> animation =
                  CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
                  /* controller.addListener(() {
          mapController_sec.move(
              LatLng(updatelat.evaluate(animation), _lngTween.evaluate(animation)),
              _zoomTween.evaluate(animation));
        });*/


                  _markers.add(Marker(
                    // This marker id can be anything that uniquely identifies each marker.
                    markerId: MarkerId(mapgadiresults.mapgadidata[i].user_id),
                    position: LatLng(driver_updatelat, driver_updatelong),
                    draggable: false,
                    rotation:brng,

                    infoWindow: InfoWindow(
                      // title is the address

                      // snippet are the coordinates of the position

                    ),

                    icon: mapvehicle_icon,
                  ));

                  controller.addListener(() {

                    mapController_sec.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: new LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),

                            zoom: _zoomTween.evaluate(animation)),
                      ),);
                  });



                  ///









                  //// OLD CONDITION
                  oldlat=driver_updatelat;
                  oldlng=driver_updatelong;


                }
                else{

                  Marker marker = _markers.firstWhere(
                          (p) =>
                      p.markerId ==
                          MarkerId(mapgadiresults.mapgadidata[i].user_id),
                      orElse: () => null);

                  _markers.remove(marker);
                //  mapgadiresults.mapgadidata.removeAt(1);

                }


              });

            }
            else if(i==2){
              double oldlat=double.parse(mapgadiresults.mapgadidata[i].updated_lat);
              double oldlng=double.parse(mapgadiresults.mapgadidata[i].updated_lon);
              var driverresponse=  Firestore.instance.collection('driver').document(mapgadiresults.mapgadidata[i].documentid.toString());
              driverresponse.snapshots().listen((querySnapshot) async {
                /// FIRST CHECK DRIVER LOCATION WITH USER CURENT LATLONG
                double driver_updatelat=double.parse(querySnapshot.data['driver_lat']);
                double driver_updatelong=double.parse(querySnapshot.data['driver_lng']);

                double distance = calculateDistance(
                    startpointlatlong.latitude, startpointlatlong.longitude,
                    driver_updatelat, driver_updatelong);
                if(distance<5){

                  Marker marker = _markers.firstWhere(
                          (p) =>
                      p.markerId ==
                          MarkerId(mapgadiresults.mapgadidata[i].user_id),
                      orElse: () => null);
                  double up_lat = double.parse(
                      mapgadiresults.mapgadidata[i].updated_lat);
                  double up_lon = double.parse(
                      mapgadiresults.mapgadidata[i].updated_lon);
                  _markers.remove(marker);
                  double dLon = (driver_updatelong-oldlng);
                  double y = sin(dLon) * cos(driver_updatelat);
                  double x = cos(oldlat)*sin(driver_updatelat) - sin(oldlat)*cos(driver_updatelat)*cos(dLon);
                  double brng = ((atan2(y, x)));
                  brng = (360 - ((brng + 360) % 360));
                  print("brng"+brng.toString());





                  final _latTween = Tween<double>(
                      begin: oldlat, end: driver_updatelat);
                  final _lngTween = Tween<double>(
                      begin: oldlng, end: driver_updatelong);
                  final _zoomTween = Tween<double>(begin: 20.0, end: 20.0);
                  var controller = AnimationController(
                      duration: const Duration(milliseconds: 1500), vsync: this);
                  // The animation determines what path the animation will take. You can try different Curves values, although I found
                  // fastOutSlowIn to be my favorite.
                  Animation<double> animation =
                  CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
                  /* controller.addListener(() {
          mapController_sec.move(
              LatLng(updatelat.evaluate(animation), _lngTween.evaluate(animation)),
              _zoomTween.evaluate(animation));
        });*/


                  _markers.add(Marker(
                    // This marker id can be anything that uniquely identifies each marker.
                    markerId: MarkerId(mapgadiresults.mapgadidata[i].user_id),
                    position: LatLng(driver_updatelat, driver_updatelong),
                    draggable: false,
                    rotation:brng,

                    infoWindow: InfoWindow(
                      // title is the address

                      // snippet are the coordinates of the position

                    ),

                    icon: mapvehicle_icon,
                  ));

                  controller.addListener(() {

                    mapController_sec.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: new LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),

                            zoom: _zoomTween.evaluate(animation)),
                      ),);
                  });



                  ///









                  //// OLD CONDITION
                  oldlat=driver_updatelat;
                  oldlng=driver_updatelong;


                }
                else{

                  Marker marker = _markers.firstWhere(
                          (p) =>
                      p.markerId ==
                          MarkerId(mapgadiresults.mapgadidata[i].user_id),
                      orElse: () => null);

                  _markers.remove(marker);
                 // mapgadiresults.mapgadidata.removeAt(2);

                }


              });

            }
            /*Marker marker = _markers.firstWhere(
                    (p) =>
                p.markerId ==
                    MarkerId(mapgadiresults.mapgadidata[i].user_id),
                orElse: () => null);
            double up_lat = double.parse(
                mapgadiresults.mapgadidata[i].updated_lat);
            double up_lon = double.parse(
                mapgadiresults.mapgadidata[i].updated_lon);
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
            );*/
          }
          mapController_sec.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: new LatLng(
                    startpointlatlong.latitude, startpointlatlong.longitude),

                zoom: 12.0,
              ),
            ),
          );
////// CRAETE POLYLINE
          _polyline.clear();
          List<LatLng> ccc;
          String str_origin = "origin=" +
              startpointlatlong.latitude.toString() + "," +
              startpointlatlong.longitude.toString();
          // Destination of route
          String str_dest = "destination=" +
              endpointlatlong.latitude.toString() + "," +
              endpointlatlong.longitude.toString();

          // Sensor enabled
          String sensor = "sensor=true";
          String mode = "mode=driving";
          String key = "key=" + "AIzaSyCFZrLl-0KWB2aYMCOCFw2YbjJUeh2j5aU";
          String parameters = str_origin + "&" + str_dest + "&" + sensor +
              "&" + mode + "&" + key;

          /////




/*

          CoordinateUtil network = new CoordinateUtil();
          network
              .get(parameters)
              .then((dynamic res) {
            List<Steps> rr = res;
            print(res.toString());

            ccc = new List();
            for (final i in rr) {
              LatLng ltlng = new LatLng(
                  i.startLocation.latitude, i.startLocation.longitude);

              ccc.add(ltlng);
              LatLng kk = new LatLng(
                  i.endLocation.latitude, i.endLocation.longitude);

              ccc.add(kk);
            }
            _polyline.add(Polyline(
              polylineId: PolylineId("polylineforroute"),
              visible: true,
              //latlng is List<LatLng>
              points: ccc,
              width: 1,
              color: Colors.black87,
            ));
          });
*/




          /////
/// TESTING FOR POLYLINES SECOND
          ccc = new List();
          PolylinePoints polylinePoints = PolylinePoints();
          List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates("AIzaSyCFZrLl-0KWB2aYMCOCFw2YbjJUeh2j5aU",
              startpointlatlong.latitude, startpointlatlong.longitude,
              endpointlatlong.latitude, endpointlatlong.longitude);
          if(result.isNotEmpty){
            result.forEach((PointLatLng point){
              ccc.add(LatLng(point.latitude, point.longitude));
            });
          }

          _polyline.add(Polyline(
            polylineId: PolylineId("polylineforroute"),
            visible: true,
            //latlng is List<LatLng>
            points: ccc,
            width: 3,
            color: Colors.black87,
          ));


        }
      }
      catch (e) {
        String jj = e.toString();
        print(jj);
      }

    }


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
      final f = new NumberFormat("######.00");
      String totalpaymentasperkm=f.format(selectedvehicleperkmprice*distance);

      List<String> driver_id_array = [];
      for (int i = 0; i < mapgadiresults.mapgadidata.length; i++)
      {
        driver_id_array.add(mapgadiresults.mapgadidata[i].user_id.toString());
      }

      ///// GENERATE SOCKET FOR BOOKING AND RESPONSE

      showDialog(
          context: context,
          builder: (context) {
            int selectedgrouptype=1;
            String paymentmode=sharedprefrences.getString("PAYMENTMODE");
            if(paymentmode=="COD"){
              selectedgrouptype=1;
            }
            else{
              selectedgrouptype=2;

            }

            String _selectedView="";
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Consts.padding),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,

              child:StatefulBuilder(  // You need this, notice the parameters below:
                  builder: (BuildContext context, StateSetter setState) {
             return Stack(
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
                        SizedBox(height: 24.0),
                        Column(
                          mainAxisSize: MainAxisSize.min, // To make the card compact
                          children: <Widget>[
                            Text(
                              "Payment mode for booking",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.0),
                            /// FOR BANK NAME
                            Row(children:<Widget>[
                              Radio(
                                value: 1,
                                groupValue: selectedgrouptype,
                                activeColor: Colors.black,

                                onChanged: (val) {
                                  print("Radio $val");
                                  setState(() {
                                    selectedgrouptype = 1;
                                  });
                                  setSelectedRadio(val);
                                },
                              ),Text('Cash',style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,),),

                              Radio(
                                value: 2,

                                groupValue: selectedgrouptype,

                                activeColor: Colors.black,
                                onChanged: (val) {
                                  print("Radio $val");
                                  setState(() {
                                    selectedgrouptype = 2;
                                  });
                                  setSelectedRadio(val);
                                },

                              ),

                              Text('Online',style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,),),
                            ]),



                            Padding(padding: const EdgeInsets.only(top:10),),
                            /// FOR BANK ACCOUNT NO





                            /////// BUTTON
                            SizedBox(height: 24.0),
                            /*  Row(children:<Widget>[

                Expanded(

                  child: FlatButton(
                    onPressed: () {

                      if(paymentmodefinal==null||paymentmodefinal.length<2){
                        Toast.show("Please Select any Paymnet Mode",context,duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
                      }
                      else {

                      }




                      // To close the dialog
                    },
                    child: Text("Submit",style: TextStyle(
                        fontSize: 16.0,fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ])*/

                          ],
                        ),
                        //// TO ADDRESS
                        /*Text(
                          "Payment Mode:-"+sharedprefrences.getString("PAYMENTMODE"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),*/








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
                              // Navigator.of(context).pop();

                              /*  sec_timer = Timer.periodic(Duration(seconds: 5), (Timer t) =>

                                  _ONBOOKINGREQUESTRESPONSE(sockets, identifiers, data));*/


                              /*     sockets[identifiers].emit("bookreq", [{
                                "user_id": sharedprefrences.getString("USERID"),
                                "driver_id": '5dcbee559373083dbbee0d01',
                                "fromLat": from_lat,
                                "mobile": sharedprefrences.getString("MOBILE"),
                                "fromLon": from_lan,
                                "paymentmode":sharedprefrences.getString("PAYMENTMODE"),
                                "fromAddress": from_address,
                                "otp": rNum.toString(),
                                "payment": totalpaymentasperkm,
                                "toLat": toLat,
                                "toLon": toLan,
                                "toAddress": toaddress,
                                "startTimestamp": starttimestamp,
                                "distance": distance,
                                "stopTimestamp": stoptimestamp,
                                "mac_id": mac_id,
                                "remark": remark,
                                "ipAddress": ipaddress,

                                "token_id": token_id,
                                "type": type,

                              },
                              ]);
*/
///// CREATE BOOKING AND INFORM TO DRIVER BOOKING
                              _createbookingstoretodatabaseandupdatetodriver(startpoint,endpoint,distance,context);





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

              );})


          );});
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
        _updatedriverlatlongbysocket(currentlat,currentlong);
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
      ///// CHECK USER STATUS
      Firestore.instance.collection('driver').document(sharedprefrences.getString("DRIVERID"))
          .get()
          .then((driverupdatedata){
            String  dstatus=driverupdatedata.data['driver_status'];
            if(dstatus=="deactive"){
              setState(() {
                driveractivestatus=true;
              });
            }
            else{
              setState(() {
                driveractivestatus=false;
              });
            }

      });

    }
    else
    {
      isuserisbooker=true;
      isuserisdriver=false;
      if(sharedprefrences.getString("BOOKINGID")!=null){

        _waitingfordriveracceptingbookingstatusanddriverstatusupdate();
      }
      //checkpoendingpaymentongoingbookingorfeedbackdetail();
      // _updatedriverlatlongbysocket(currentlat,currentlong);
    }
    callapiforvehiclelist();
    _getmycurrentlocation();
  }

  Future<void> _updatedriverlatlongbysocket(currentlat, currentlong) async {
    try{

      Map<String,dynamic> data = {
        'driver_lat' : currentlat.toStringAsFixed(5),
        'driver_lng' : currentlong.toStringAsFixed(5),  // Updating Document Reference
      };
      Firestore.instance.collection('driver')
          .document(sharedprefrences.getString('DRIVERID')).updateData(data);


      /*  String identifier="default";
    setState(() => _isProbablyConnected[identifier] = true);
    SocketIOManager manager  = SocketIOManager();
    try {
      SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
          'http://nberindia.com:4007/',

          //Enable or disable platform channel logging
          enableLogging: false,
          transports: [Transports.WEB_SOCKET *//*, Transports.POLLING*//*
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
      *//*socket.on("type:string", (data) => pprint("type:string | $data"));
    socket.on("type:bool", (data) => pprint("type:bool | $data"));
    socket.on("type:number", (data) => pprint("type:number | $data"));
    socket.on("type:object", (data) => pprint("type:object | $data"));
    socket.on("type:list", (data) => pprint("type:list | $data"));
    socket.on("message", (data) => pprint(data));*//*
      socket.connect();
      sockets[identifier] = socket;*/
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

    /*  String identifier="bookingrequestfordriver";
    setState(() => _isProbablyConnected[identifier] = true);
    SocketIOManager manager  = SocketIOManager();
    try {
      SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
          'http://nberindia.com:4007/',

          //Enable or disable platform channel logging
          enableLogging: false,
          transports: [Transports.WEB_SOCKET *//*, Transports.POLLING*//*
          ] //Enable required transport
      ));
      socket.onConnect((data) {
        pprint("connected...");
        pprint(data);

        driver_timer=Timer.periodic(Duration(seconds: 5), (Timer t) => startsocket_fordriver(sockets,identifier,manager,_isProbablyConnected),);
        *//*sockets[identifier].emit("input", [{
                 "lat":currentlat,"lon":currentlong,"role":sharedprefrences.getString("ROLE"),"user_id":sharedprefrences.getString("USERID")
               },]);
               sockets[identifier].on("driver" , (data){   //sample event
                 print("driver");
                 print(data);
               });*//*



      });
      socket.onConnectError(pprint);
      socket.onConnectTimeout(pprint);
      socket.onError(pprint);


      socket.connect();
      sockets[identifier] = socket;*/
    try{
      var reference = Firestore.instance.collection('driver').document(sharedprefrences.getString("DRIVERID"));
      driver_bookinglistner= reference.snapshots().listen((querySnapshot) async {

        //Toast.show(newbookingid, context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
        /*querySnapshot.documentChanges.forEach((change) {
          // Do something with change
        });*/
        String newbookingid=querySnapshot.data['new_bookingrequest_id'];
        if(newbookingid.length>2&&(querySnapshot.data['driver_status']=='free'||querySnapshot.data['driver_status']=='running'||querySnapshot.data['driver_status']=="accepted")) {
          //   if (booking_request_driver_dialog == false) {
          // booking_request_driver_dialog = true;
          sharedprefrences.setString('DRIVERVEHICLEID',querySnapshot.data['vehicle_type_id']);
          sharedprefrences.setString("BOOKINGID",newbookingid);
         // DocumentReference documentReference =
          Firestore.instance.collection("bookingrequest").document(newbookingid).get().then((datasnapshot) {
            if (datasnapshot.exists)
            {
              driver_bookinglistner.pause();
             // Toast.show('driverbookinglistnerpopup', context,duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
              //print('driverbookinglistnerpopup');
              if(datasnapshot.data['booking_status']=='pending')
              {
                driver_bookinglistner.pause();

               if(booking_request_driver_dialog==false) {
                 booking_request_driver_dialog=true;
                 _createdriverbookingrequestdialogandresponse(
                     datasnapshot.data, newbookingid);
               }
              }
              else if(datasnapshot.data['booking_status']=='accepted'||datasnapshot.data['booking_status']=='running'){

                driver_booking_header_datas=datasnapshot.data;
                driver_bookinglistner.pause();
                _continuewcheckifbookingiscanceledbydriverornot();
                //driver_bookinglistner.cancel();
                setState(() {
                  userisdriver=true;
                });

                //showbottomsheetdialogfordriverlayout(datasnapshot.data,driver_bookinglistner);
              }
              else if(datasnapshot.data['booking_status']=='cancel_by_user'){
              //  Toast.show('booking is cancel by user', context,duration:Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                sharedprefrences.setString("BOOKINGID", null);
                booking_request_driver_dialog = false;
               // driver_startsockerforsendrequestforbooking();
              }
            }
            else {
              print("No such user");
              booking_request_driver_dialog = false;
            }
          });

          //  Toast.show(user_id,context,duration: Toast.LENGTH_SHORT,gravity:Toast.CENTER);


          // }
        }


      });
    }catch(e)
    {
      String s =e.toString();
    }





  }

  startsocket_fordriver(Map<String, SocketIO>  socket , String identifier, SocketIOManager manager, Map<String, bool> isProbablyConnected) {
    Toast.show('driver in every second call toast',context,duration:Toast.LENGTH_SHORT,gravity: Toast.CENTER);

    socket[identifier].emit("driverbookingrequest", [{
      "driver_id":sharedprefrences.getString("USERID"),"booking_id":null,
    },]);
    socket[identifier].on("driverbookingresponse" , (data)
    {

      //print("driverbookingresponse"+data);

      Toast.show('driver booking response',context,duration:Toast.LENGTH_SHORT,gravity: Toast.CENTER);

      //sample event
      if(booking_request_driver_dialog==false) {
        booking_request_driver_dialog=true;
        // _createdriverbookingrequestdialogandresponse(sockets, identifier, data);
        manager.clearInstance(socket[identifier]);
        setState(() => isProbablyConnected[identifier] = false);

        //  Toast.show(user_id,context,duration: Toast.LENGTH_SHORT,gravity:Toast.CENTER);

        driver_timer.cancel();
      }});

  }

  void _createdriverbookingrequestdialogandresponse( data,String bookingid) {


    ///// TESTING DIALOG BOX START HERE
    showDialog(barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
      String paymentmode;

      if(data['paymentmode']=="COD"){
        paymentmode="Cash";
      }
      else{
        paymentmode="Online";
      }

          Timer(Duration(seconds: 15), () {
            Navigator.of(context).pop();

            booking_request_driver_dialog=false;
            String bookingid=sharedprefrences.get("BOOKINGID");
            Firestore.instance.collection('bookingrequest').document(bookingid).get().then((driverdata){
              String runningstatus=driverdata.data['booking_status'];

            });

            callapimethodfordriverresponsebooking(false,data,bookingid);

          });
          return Dialog(
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
                          "Pickup:-"+data["from_address"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 16.0),

                        //// TO ADDRESS
                        Text(
                          "Drop:-"+data["to_address"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Payment Mode : "+paymentmode,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),textAlign: TextAlign.center,
                        ),
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
                                callapimethodfordriverresponsebooking(false,data,bookingid);
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
                                callapimethodfordriverresponsebooking(true,data,bookingid);
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


          );});
    ///// TESTING DIALOG BOX END HERE





  }

  void callapimethodfordriverresponsebooking(bool acceptedornot, datas,String bookingid) async
  {

    try {
      //// HERE FIRST WE CHECK THAT MAY BE USER CANCEL THE BOOKKING BEFORE
Firestore.instance.collection("bookingrequest").document(bookingid).get().then((bookingdata){
   if(bookingdata.data['booking_status']=="cancel_by_user"){
     Firestore.instance.collection('driver')
         .document(sharedprefrences.getString('DRIVERID')).updateData({'driver_status':'free','new_bookingrequest_id':''});
     sharedprefrences.setString("BOOKINGID", null);
     //driver_bookinglistner_sec.pause();
     driver_startsockerforsendrequestforbooking() ;
     ////// CAL REQUEST SOCKET IN EVERY SECONDFOR BOOKING RE
     setState(() => userisdriver = false);
     booking_request_driver_dialog = false;
     showDialog(barrierDismissible: false,
       context: context,
       builder: (_) =>
           GeneralMessageDialogBox(
             Message: "Hello your current booking is cancel by user. now you can get another booking",),
     );
   }
   else {
     if (acceptedornot == true) {
       sharedprefrences.setString("BOOKINGID", bookingid);

       var driverdata = Firestore.instance.collection('driver')
           .document(sharedprefrences.getString('DRIVERID')).updateData(
           {'driver_status': 'accepted'});
       Firestore.instance.collection('bookingrequest')
           .document(bookingid).updateData({
         'booking_status': 'accepted',
         'driver_id': sharedprefrences.getString('DRIVERID'),
         'driver_name': sharedprefrences.getString("USERNAME"),
         'driver_image': sharedprefrences.getString("IMAGE")
       }).then((data) {
         //showbottomsheetdialogfordriverlayout(datas);
         driver_booking_header_datas = datas;
         setState(() {
           userisdriver = true;
         });
         String userid = sharedprefrences.getString("USERID");
         Firestore.instance.collection("users").document(userid).updateData(
             {"mybookinglist": FieldValue.arrayUnion([bookingid])});


         driver_startsockerforsendrequestforbooking();
       });
     }
     else {
       //// NEED TO IMPROVE FOR MULTIDRIVER CONDITION FOR SO
       driver_bookinglistner.resume();
       Firestore.instance.collection('bookingrequest')
           .document(sharedprefrences.getString('BOOKINGID')).updateData({
         'booking_status': 'ignore_by_driver',
         'driver_name': sharedprefrences.getString("USERNAME"),
         'driver_image': sharedprefrences.getString("IMAGE")
       });

       sharedprefrences.setString("BOOKINGID", null);
       Firestore.instance.collection('driver')
           .document(sharedprefrences.getString('DRIVERID')).updateData(
           {'new_bookingrequest_id': '', 'driver_status': 'free'});
       driver_startsockerforsendrequestforbooking();
     }
   }

});






    } catch (e) {
      String s = e.toString();
    }
  }

  Widget showbottomsheetdialogfordriverlayout() {
    String user_id=driver_booking_header_datas["user_id"];
    BuildContext bc;
    String otp=driver_booking_header_datas["otp"];
    double fromlat=double.parse(driver_booking_header_datas["from_lat"]);
    double fromlan=double.parse(driver_booking_header_datas["from_lng"]);
    double tolat=double.parse(driver_booking_header_datas["to_lat"]);
    double tolan=double.parse(driver_booking_header_datas["to_lng"]);
    String user_mobileno=driver_booking_header_datas["mobile"];


    if(driver_booking_header_datas['booking_status']=='accepted'){
      ride_statue_button='Start Ride';
      ridestart=false;
    }
    else if(driver_booking_header_datas['booking_status']=='running'){
      ride_statue_button='Complete Ride';
      ridestart=true;
    }

    //driver_bookinglistner.resume();
    //sharedprefrences.setString("booking_id",datas["booking_id"]);

    return   Container(margin: const EdgeInsets.only(bottom: 10),
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
                      _openotpverificationdialogbox(otp,bc);
                    }
                    else if(ridestart==true){
                      //Toast.show('MY RIDE IS RUNNING', context,duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
                      _confirmdialogboxforridecomplete();
                    }
                    /*if(driver_booking_header_datas['booking_status']=='accepted'){
                           _openotpverificationdialogbox(otp,bc);
                         }
                         else if(driver_booking_header_datas['booking_status']=='running'){
                           Toast.show('MY RIDE IS RUNNING', context,duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
                         }
                         else if(driver_booking_header_datas['booking_status']=='cancel_by_user'){

                         }
                         else if(driver_booking_header_datas['booking_status']=='cancel_by_driver'){

                         }*/
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            ride_statue_button,
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
                    String descriptionmessage='are you sure you want to cancel this booking';

                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button for close dialog!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Alert !'),
                          content:  Text(descriptionmessage),
                          actions: <Widget>[
                            FlatButton(
                              child: const Text('No'),
                              onPressed: () {

                                Navigator.of(context).pop("Cancel");
                                //callpaymentfeedback(false);
                              },
                            ),
                            FlatButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                //callpaymentfeedback(true);
                                //// UPSDATE BOOKINGDATA FOR CANCEL AND CHARGE

                                Firestore.instance.collection('vehicle_type').document(sharedprefrences.getString("DRIVERVEHICLEID")).get().then((data){
                                  double bookingpayment=double.parse(driver_booking_header_datas['bookingpayment']);

                                  double drivercancellationcharge=double.parse(data.data['driver_cancallation_charge']);



                                  double finaldrivercommisiontoaddwallet= ((bookingpayment*drivercancellationcharge)/100);
                                  double finalcompanycommisiontoaddwallet= ((bookingpayment*drivercancellationcharge)/100);

                                  ///// DEDUCT PAYMENT FROM DRIVER WALLET
                                  Firestore.instance.collection('wallet').document(sharedprefrences.getString('DRIVERWALLETID')).get().
                                  then((walletdata){
                                    double driver_balance=double.parse(walletdata.data['balance']);
                                    var updatedriverwalletbalance= driver_balance-finaldrivercommisiontoaddwallet;
                                    //// UPDATE TO DRIVER WALLET
                                    Firestore.instance.collection('wallet').document(sharedprefrences.getString('DRIVERWALLETID'))
                                        .updateData({'balance':updatedriverwalletbalance.toString()}).then((data){
                                      /// NOW HERE WE ADD TO COMPANY COMMISION



                                      Firestore.instance.collection('company_earning').add({'amount': finalcompanycommisiontoaddwallet.toString(),
                                        'amount_type':'driver cancellation charger',
                                        'balance':'',
                                        'booking_id':sharedprefrences.getString("BOOKINGID"),
                                        'driver_id':sharedprefrences.getString("DRIVERID"),
                                        'remark':'booking cancel by Driver',
                                        'status':'Booking Cancel',
                                        'transcation_id':"wallet",

                                      }).then((data){
                                        String bookingid=sharedprefrences.getString("BOOKINGID");
                                        Firestore.instance.collection('bookingrequest')
                                            .document(bookingid).updateData({'booking_status':'cancel_by_driver','payment_status':'complete'});


                                        Firestore.instance.collection('driver')
                                            .document(sharedprefrences.getString('DRIVERID')).updateData({'driver_status':'free','new_bookingrequest_id':''}).then((data){

                                          ///// HERE WE MAKE DRIVERWALLETCONDITION TO RETIVE PAYMENT FROM HIS WALLET


                                          setState(() {
                                            ridestart=false;

                                          });setState(() {
                                            userisdriver=false;

                                          });
                                          sharedprefrences.setString("BOOKINGID", null);
                                          driver_startsockerforsendrequestforbooking();
                                          driver_booking_header_datas.clear();
                                          driver_bookinglistner.resume();
                                          showDialog(barrierDismissible: false,
                                            context: context,
                                            builder: (_) =>
                                                GeneralMessageDialogBox(
                                                  Message: "Your on going  Booking is cancelled and company charges deduct from your wallet",),
                                          );







                                        });


                                      });



                                    });



                                  });

















                                  /// UPDATE IN BOOKING DATA


                                  //// UPDATE STATUS IN MY WALLET PAYMENT







                                });












                              },
                            )
                          ],
                        );
                      },
                    );


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

  void _openotpverificationdialogbox(String otp, BuildContext cont) {
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
                                // Toast.show("Enter Valid OTP", context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);
                                showDialog(barrierDismissible: false,
                                    context: context,
                                    builder: (_) => GeneralMessageDialogBox(Message: "Enter Valid OTP",
                                    ));
                              }
                              else{
                                if(otp==enterotp){


                                  Firestore.instance.collection('bookingrequest')
                                      .document(sharedprefrences.getString('BOOKINGID'))
                                      .updateData(
                                      {'booking_status': 'running'})
                                      .then((datas) async {
                                    ///
                                    Firestore.instance.collection("driver")
                                        .document(sharedprefrences.getString("DRIVERID"))
                                        .updateData({'driver_status':'running'}).then((datas){
                                      ridestart=true;

                                      setState(() =>
                                      ride_statue_button = 'Complete Ride');
                                      setState(() =>
                                      ridestart=true);
                                      var jj='running';
                                      setState(() =>
                                          driver_booking_header_datas.update("booking_status", (dynamic val) => 'running'));

                                      Navigator.of(context).pop();
                                      //crate_showbottomsheetdialogfordriverlayout(datas);


                                      Toast.show("OTP Verify Successfullty", context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);

                                    });




                                    //Redircetforpaymenttodriverregisterfees();
                                  });





                                }
                                else{
                                  showDialog(barrierDismissible: false,
                                      context: context,
                                      builder: (_) => GeneralMessageDialogBox(Message: "OTP is not match",                                     ));
                                }
                              }




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

  void _handleRadioValueChange1(Object value) {
    cashmodevalue = value;
    switch (value) {
      case 1:
        paymentmodefinal = value;
        break;
      case 2:
        paymentmodefinal = value;
        break;

      default:
        paymentmodefinal = null;
    }
    debugPrint(paymentmodefinal);
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
    if(val==1){
      sharedprefrences.setString("PAYMENTMODE", "COD");
    }
    else{
      sharedprefrences.setString("PAYMENTMODE", "ONLINE");
    }
  }

  void _setvaluetolist(Map<String,dynamic > data) {
    try {


      VehicleTypeDatases datas = new VehicleTypeDatases();
      datas.id = data['vehicle_type_id'].toString();
      datas.type=data['type'].toString();
      datas.category=data['type'].toString();
      datas.baseFare=double.parse(data['base_fare_km']);
      datas.capacity=data['capacity'];
      datas.companycommision=data['company_commision'];
      datas.driverCancellationCharge=double.parse(data['driver_cancallation_charge']);
      datas.drivercommision=data['driver_commision'];
      datas.extra=double.parse(data['extra']);
      datas.icon=data['icon'];
      datas.status=data['status'];
      datas.surcharge=double.parse(data['surcharge']);
      datas.tollcharge=data['toll_charge'];
      datas.userCancellationCharge=double.parse(data['user_cancallation_charge']);
      datas.waitingCharge=double.parse(data['waiting_charge']);


      String gender=sharedprefrences.getString("GENDER");
      if(gender=="male"||gender=="Male"){


        if(datas.type=="scooty"||datas.type=="scooty"||datas.type=="scooty") {
          try {
            totallistforvehicle=totallistforvehicle-1;

            /* listViews.add(
              VehicleTypeView(

              vehicletypedata: datas,
            ),);*/
          }
          catch(e){
            print(e);}
        }
        else{
          vehicledata.add(datas);
        }
      }
      else {
        vehicledata.add(datas);
        /* listViews.add(VehicleTypeView(

          vehicletypedata: datas,
        ),);*/

      }
    }catch(e){
      print(e);






    }
  }

  Future<void> _createbookingstoretodatabaseandupdatetodriver(String startpoint,String endpoint,double distance, BuildContext context) async {
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
    final f = new NumberFormat("######.00");
    String totalpaymentasperkm = f.format(selectedvehicleperkmprice * distance);

    List<String> driver_id_array = [];
    for (int i = 0; i < mapgadiresults.mapgadidata.length; i++) {
      driver_id_array.add(mapgadiresults.mapgadidata[i].user_id.toString());
    }

    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, dd/MMM/yyyy, hh:mm a ').format(now);

    await Firestore.instance.collection("bookingrequest").add({
      'booking_status':'pending',
      "driver_id": mapgadiresults.mapgadidata[0].documentid,
      "driver_lat": '',
      "driver_lng": '',
      "driver_name": '',
      "driver_image":"",
      "feedback_status": 'pending',
      "from_address": from_address,
      "from_lng": from_lan,
      "from_lat": from_lat,
      "ip_address": ipaddress,
      "mac_id": mac_id,
      "payment_status": 'pending',
      "remark": remark,
      "start_timestamp": starttimestamp,
      "stop_timestamp": stoptimestamp,
      "to_address": toaddress,
      "to_lat": toLat,
      "to_lng": toLan,
      "token_id": token_id,
      "type": type,

      "user_id": sharedprefrences.getString("USERID"),

      "mobile": sharedprefrences.getString("MOBILE"),

      "paymentmode": sharedprefrences.getString("PAYMENTMODE"),

      "otp": rNum.toString(),
      "bookingpayment": totalpaymentasperkm,



      "distance": distance,
      'bookingdate':formattedDate







    }).then((documentReference) {
      print(documentReference.documentID);

      //
      sharedprefrences.setString(
          'BOOKINGID', documentReference.documentID.toString());
      _waitingfordriveracceptingbookingstatusanddriverstatusupdate();
      print(documentReference.documentID);
      Firestore.instance.collection('driver')
          .document(mapgadiresults.mapgadidata[0].documentid)
          .updateData(
          {'new_bookingrequest_id': documentReference.documentID.toString()})
          .then((data) async {

        //Redircetforpaymenttodriverregisterfees();
      });


      /// SAVE VALUES TO SHAREDPREFRENCES


//


    }).catchError((e) {
      progressDialog.hide();

      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) =>
            GeneralMessageDialogBox(
              Message: "Sorry there seems to be network server error please try again later",),
      );
    });


  }
  int count=1;
  Future<void> _waitingfordriveracceptingbookingstatusanddriverstatusupdate() async {
    String bookingid=sharedprefrences.getString('BOOKINGID');

    try{

      var reference = Firestore.instance.collection('bookingrequest').document(bookingid);
      reference.snapshots().listen((querySnapshot) async {

        //Toast.show(querySnapshot.data['driver_status'], con,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
        if(querySnapshot.data['booking_status']=='accepted'||querySnapshot.data['booking_status']=='running'){
          my_booking_Deteail_Data=querySnapshot.data;

          //// UPDATEVALUE FOR DRIVER DETAIL
          var driverdetailsnapshot = await Firestore.instance
              .collection('driver').document(querySnapshot.data['driver_id']);

          driverdetailsnapshot.get().then((data){
            driver_detail_data=data;
            setState(() =>
            booking_search =
            false);
            setState(() =>
            driver_infowithotp =
            true);
            setState(() =>
            search_bar =
            false);

            setState(() =>
            ride_otp ="OTP "+
                my_booking_Deteail_Data['otp']);
            setState(() =>
            driver_vehicleno =
            data['vehicle_number']);
            setState(() =>
            driver_vehicle_detail =
            data['vehicle_detail']);
            setState(() =>
            driver_name =
            data['driver_name']);
            setState(() =>
            driver_totalreview =
            data['reviews']);
            setState(() =>
            driver_vehicle_image =
            data['vehicle_front']);
            setState(() =>
            driver_image =
            data['driver_image']);

            setState(() =>
            string_label_start_address =
            my_booking_Deteail_Data['from_address']);
            setState(() =>
            string_label_end_address =
            my_booking_Deteail_Data['to_address']);

            String userid=sharedprefrences.getString("USERID");
            Firestore.instance.collection("users").document(userid).updateData({"mybookinglist":FieldValue.arrayUnion([bookingid])});

            _updatemapandgetdriverlatlongandrotateonmap(querySnapshot.data);

          });



          //reference.delete();
        }
        else if(querySnapshot.data['booking_status']=='cancel_by_user'&&querySnapshot.data['payment_status']=="pending"){
          driver_latlngupdatetouserlistner.cancel();

          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button for close dialog!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert !'),
                content:  Text('Hello your previous booking was cancel by you and your cancellation charge due , for continue booking please pay this charges'),
                actions: <Widget>[
                  /*FlatButton(
                    child: const Text('No'),
                    onPressed: () {

                      Navigator.of(context).pop("Cancel");
                      callpaymentfeedback(false);
                    },
                  ),*/
                  FlatButton(
                    child: const Text('ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _callpaymentscreen(querySnapshot.data);

                    },
                  )
                ],
              );
            },
          );

          /* setState(() =>
          search_bar = true);
          sharedprefrences.setString('BOOKINGID', null);*/
        }
        else if(querySnapshot.data['booking_status']=='cancel_by_driver'){
          driver_latlngupdatetouserlistner.cancel();
          showDialog(barrierDismissible: false,
              context: context,
              builder: (_) => GeneralMessageDialogBox(Message:"Hello , your current booking is cancel by driver please book again and try later.",
              ));
          setState(() =>
          search_bar = true);
          mapgadiresults.mapgadidata.clear();
          _polyline.clear();
          setState(() {
            _endpointcontroller.text=null;
          });

          for (int i = 0; i < _markers.length; i++) {


            if (_markers
                .elementAt(i)
                .markerId.value == 'startpointmarker' ) {


            }
            else {

              Marker marker = _markers.firstWhere(
                      (p) =>
                  p.markerId ==
                      MarkerId(_markers
                          .elementAt(i).markerId.value),
                  orElse: () => null);

              _markers.remove(marker);



            }
          }
          setState(() =>
          driver_infowithotp = false);
          _markers.clear();

          Marker marker = _markers.firstWhere(
                  (p) =>
              p.markerId == MarkerId('startpointmarker'),
              orElse: () => null);
          _markers.remove(marker);
          Marker drivermarker = _markers.firstWhere(
                  (p) =>
              p.markerId == MarkerId(querySnapshot.data['driver_id']),
              orElse: () => null);
          _markers.remove(drivermarker);

          _markers.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId('startpointmarker'),
            position: LatLng(currentlat, currentlong),
            draggable: false,
            infoWindow: InfoWindow(
              // title is the address

              // snippet are the coordinates of the position

            ),

            icon: starticon,
          ));
          mapController_sec.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: new LatLng(currentlat, currentlong),

                zoom: 12.0,
              ),
            ),
          );
         setState(() {
           _endpointcontroller.text="";
         });

          sharedprefrences.setString('BOOKINGID', null);
        }
        else if(querySnapshot.data['booking_status']=='complete'){
          setState(() {
            driver_infowithotp=false;
          });
          setState(() {
            search_bar=true;
          });
          mapgadiresults.mapgadidata.clear();
          _polyline.clear();
          setState(() {
            _endpointcontroller.text=null;
          });

          for (int i = 0; i < _markers.length; i++) {


            if (_markers
                .elementAt(i)
                .markerId.value == 'startpointmarker' ) {


            }
            else {

              Marker marker = _markers.firstWhere(
                      (p) =>
                  p.markerId ==
                      MarkerId(_markers
                          .elementAt(i).markerId.value),
                  orElse: () => null);

              _markers.remove(marker);



            }
          }
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button for close dialog!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert !'),
                content:  Text('Your current booking is complete'),
                actions: <Widget>[

                  FlatButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if(querySnapshot.data['payment_status']=='pending'){
                        setState(() =>
                        search_bar = false);
                        setState(() {
                          driver_infowithotp=false;
                        });
                        //reference.delete();
                        /* setState(() =>
                 booking_search =
                 !booking_search);*/
                        _callpaymentscreen(querySnapshot.data);

                      }
                      else if(querySnapshot.data['feedback_status']=='pending'){
                        setState(() =>
                        search_bar = false);
                        //reference.delete();
                        /*setState(() =>
                 booking_search =
                 !booking_search);*/
                        String fromaddresss=querySnapshot.data['from_address'];
                        String toaddress=querySnapshot.data['to_address'];
                        String descriptionmessage='lets tell about your previous ride from '+fromaddresss+" to "+toaddress +".";

                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button for close dialog!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alert !'),
                              content:  Text(descriptionmessage),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text('No'),
                                  onPressed: () {

                                    Navigator.of(context).pop("Cancel");
                                    callpaymentfeedback(false);
                                  },
                                ),
                                FlatButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    callpaymentfeedback(true);

                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                      else{
                        setState(() =>
                        search_bar = true);
                        mapgadiresults.mapgadidata.clear();
                        _polyline.clear();
                        setState(() {
                          _endpointcontroller.text=null;
                        });

                        for (int i = 0; i < _markers.length; i++) {


                          if (_markers
                              .elementAt(i)
                              .markerId.value == 'startpointmarker' ) {


                          }
                          else {

                            Marker marker = _markers.firstWhere(
                                    (p) =>
                                p.markerId ==
                                    MarkerId(_markers
                                        .elementAt(i).markerId.value),
                                orElse: () => null);

                            _markers.remove(marker);



                          }
                        }


                        setState(() {
                          driver_infowithotp=false;
                        });
                        sharedprefrences.setString('BOOKINGID', null);
                      }

                    },
                  )
                ],
              );
            },
          );

        }
        else if(querySnapshot.data['booking_status']=='ignore_by_driver')
        {

          int totaldriversize=mapgadiresults.mapgadidata.length;
          if(count==totaldriversize)
          {
            count=1;
            //Toast.show('ignorebydriver', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
            setState(() =>
            booking_search =
            false);
            setState(() =>
            search_bar = true);
            mapgadiresults.mapgadidata.clear();
            _polyline.clear();
            setState(() {
              _endpointcontroller.text=null;
            });

            setState(() {
              _endpointcontroller.text=null;
            });

            for (int i = 0; i < _markers.length; i++) {


              if (_markers
                  .elementAt(i)
                  .markerId.value == 'startpointmarker' ) {


              }
              else {

                Marker marker = _markers.firstWhere(
                        (p) =>
                    p.markerId ==
                        MarkerId(_markers
                            .elementAt(i).markerId.value),
                    orElse: () => null);

                _markers.remove(marker);



              }
            }
            showDialog(barrierDismissible: false,
                context: context,
                builder: (_) => GeneralMessageDialogBox(Message:"Sorry, there is no any driver available to accept your booking, please try after some time.",
                ));
            sharedprefrences.setString('BOOKINGID', null);
          }
          else{
            count++;

            Firestore.instance.collection('bookingrequest').document(bookingid).updateData({'driver_id':mapgadiresults.mapgadidata[count-1].documentid.toString(),"booking_status":"pending"});
            Firestore.instance.collection('driver').document(mapgadiresults.mapgadidata[count-1].documentid.toString()).updateData({'new_bookingrequest_id':bookingid});



            /*if(totaldriversize==1){
              Toast.show('ignorebydriver', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
              setState(() =>
              booking_search =
              false);
              setState(() =>
              search_bar = true);
            }
            else if(totaldriversize==2){
              count++;


            }
            else if(totaldriversize==3){
              count++;


            }*/

            //// ASSIGNTOANOTHERDRIVER





          }




        }



      });





      /*  var reference = Firestore.instance.collection('driver').document("2QN5nsvZQZ1plq4nBIVX");
        reference.snapshots().listen((querySnapshot) async {

          Toast.show(querySnapshot.data['driver_status'], con,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
         // querySnapshot.documentChanges.forEach((change) {
          // Do something with change
        });*/

      ///// HERE WE CHECK VALUE AFTER100 SECONDS THAT USER GET ANY RESPONSE  BY ANY DRIVER OR NOT
      Timer(Duration(seconds: 110), () {
        Firestore.instance.collection('bookingrequest').document(bookingid).get().then((bookingdataontime){
          if(bookingdataontime.data['booking_status']=="pending"||bookingdataontime.data['booking_status']=="ignore_by_driver"){
            if(sharedprefrences.getString("BOOKINGID")!=null) {
              Firestore.instance.collection('driver').document(bookingdataontime.data['driver_id']).updateData({'new_bookingrequest_id':''}).then((data){
                setState(() =>
                booking_search =
                false);
                setState(() =>
                search_bar = true);
                mapgadiresults.mapgadidata.clear();
                _polyline.clear();
                setState(() {
                  _endpointcontroller.text=null;
                });

                setState(() {
                  _endpointcontroller.text=null;
                });

                for (int i = 0; i < _markers.length; i++) {


                  if (_markers
                      .elementAt(i)
                      .markerId.value == 'startpointmarker' ) {


                  }
                  else {

                    Marker marker = _markers.firstWhere(
                            (p) =>
                        p.markerId ==
                            MarkerId(_markers
                                .elementAt(i).markerId.value),
                        orElse: () => null);

                    _markers.remove(marker);



                  }
                }
                sharedprefrences.setString("BOOKINGID", null);
                showDialog(barrierDismissible: false,
                    context: context,
                    builder: (_) => GeneralMessageDialogBox(Message:"Sorry, there is no any driver available to accept your booking, please try after some time.",
                    ));

              });

            }
          }

        });

      });




    }
    catch(e)
    {
      String s =e.toString();
      Toast.show(s, context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);

    }





  }

  void _callpaymentscreen(Map<String,dynamic > bookingdata) {


    if(bookingdata['booking_status']=='cancel_by_user'&&bookingdata['payment_status']=="pending"){

      String mybookingdriverid=bookingdata['driver_id'];

      Firestore.instance.collection('driver').document(mybookingdriverid).get().then((data)
      {

        String drivervehicleid=data.data['vehicle_type_id'];

        Firestore.instance.collection('vehicle_type').document(
            drivervehicleid).get().then((datas) {
          double bookingpayment = double.parse(
              bookingdata['bookingpayment']);

          double drivercancellationcharge = double.parse(datas
              .data['user_cancallation_charge']);



          double finalcompanycommisiontoaddwallet = ((bookingpayment *
              drivercancellationcharge) / 100);

          int payment = (finalcompanycommisiontoaddwallet * 100).round();
          String fromaddresss = bookingdata['from_address'];
          String toaddress = bookingdata['to_address'];
          String descriptionmessage = 'your previous booking from ' + fromaddresss +
              " to " + toaddress +
              " is pending. please complete this payment to continue booking";


          var _razorpay = Razorpay();
          var _razorpays = Razorpay();
          var options = {
            'key': Constants.PAYMENTGATEWAYKEY,
            //'key': 'rzp_live_qdUReWKfy2SE4Y',
            'amount': payment,
            //in thuserImage(File _image) asynce smallest currency sub-unit.
            'name': 'NBER',
            'description': descriptionmessage,
            'prefill': {
              'contact': sharedprefrences.getString('MOBILE'),
              'email': sharedprefrences.getString('USEREMAIL')
            }
          };
          try {
            _razorpays.on(
                Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessforusercancellationcharger(finalcompanycommisiontoaddwallet,mybookingdriverid));
            _razorpay.on(
                Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
            _razorpay.on(
                Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
            _razorpay.open(options);
          }
          catch (e) {
            print(e);
          }




          ///// DEDUCT PAYMENT FROM DRIVER WALLET

          /// NOW HERE WE ADD TO COMPANY COMMISION



        });

      });







    }
    else {
      double payment = (double.parse(bookingdata['bookingpayment']) * 100);
      String fromaddresss = bookingdata['from_address'];
      String toaddress = bookingdata['to_address'];
      String descriptionmessage = 'your previous booking from ' + fromaddresss +
          " to " + toaddress +
          " is pending. please complete this payment to continue booking";

      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert !'),
            content: Text(descriptionmessage),
            actions: <Widget>[
              FlatButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop("Cancel");
                },
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  var _razorpay = Razorpay();
                  var _razorpays = Razorpay();
                  var options = {
                    'key': Constants.PAYMENTGATEWAYKEY,
                    //'key': 'rzp_live_qdUReWKfy2SE4Y',
                    'amount': payment,
                    //in thuserImage(File _image) asynce smallest currency sub-unit.
                    'name': 'NBER',
                    'description': descriptionmessage,
                    'prefill': {
                      'contact': sharedprefrences.getString('MOBILE'),
                      'email': sharedprefrences.getString('USEREMAIL')
                    }
                  };
                  try {
                    _razorpays.on(
                        Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                    _razorpay.on(
                        Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                    _razorpay.on(
                        Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                    _razorpay.open(options);
                  }
                  catch (e) {
                    print(e);
                  }
                },
              )
            ],
          );
        },
      );
    }



  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    try {
      String bokingid=sharedprefrences.getString('BOOKINGID');
      Firestore.instance.collection('bookingrequest')
          .document(bokingid).updateData({
        'payment_status': 'complete',

      }).then((updateddata)  {
        /// ADD PAYMENT TO DRIVER WALLET AND CRATE TRANSCATION TABLE
        Firestore.instance.collection('bookingrequest').document(bokingid).get().then((bookingdata){
          String driverid=bookingdata.data['driver_id'];
          Firestore.instance.collection('driver').document(driverid).get().then((driverdata){
            String userid=driverdata.data['user_id'];
// NOW GET DRIVER WALLET ID FROM USERS
            Firestore.instance.collection('users').document(userid).get().then((usrdata){
              String walletid=usrdata.data['driver_wallet_id'];

              Firestore.instance.collection('vehicle_type').document(driverdata.data['vehicle_type_id']).get().then((data){
                double bookingpayment=double.parse(bookingdata.data['bookingpayment']);

                double drivercommision=double.parse(data.data['driver_commision']);
                double companycommision=double.parse(data.data['company_commision']);


                double finaldrivercommisiontoaddwallet= ((bookingpayment*drivercommision)/100);
                double finalcompanycommisiontoaddwallet= ((bookingpayment*companycommision)/100);

                ///// DEDUCT PAYMENT FROM DRIVER WALLET
                DateTime now = DateTime.now();
                String formattedDate = DateFormat('EEE, dd/MMM/yyyy, hh:mm a ').format(now);

                Map<String,dynamic> transcationdata=
                {
                  'amount':bookingpayment.toString(),
                  'booking_id':sharedprefrences.getString("BOOKINGID"),
                  'driver_id':driverid,
                  'message': bookingpayment.toString()+" is credited in your wallet",
                  'order_id':response.orderId,
                  'payment_id':response.paymentId,
                  'paymentmethod':"online",
                  'paymentstatus':"cr",
                  'signature':"",
                  'user_id':"",'timestamp':formattedDate,
                  'walletname':walletid,

                };
                Firestore.instance.collection('transcation').add(transcationdata).then((transcationdata){


                  Firestore.instance.collection('wallet').document(walletid).get().
                  then((walletdata){
                    double driver_balance=double.parse(walletdata.data['balance']);
                    double driver_totalearning=double.parse(walletdata.data['total_earning']);
                    double update_driver_total_earning=driver_totalearning+bookingpayment;

                    var updatedriverwalletbalance= driver_balance-finaldrivercommisiontoaddwallet;
                    //// UPDATE TO DRIVER WALLET
                    Firestore.instance.collection('wallet').document(sharedprefrences.getString('DRIVERWALLETID'))
                        .updateData({'balance':updatedriverwalletbalance.toString(),'total_earning':update_driver_total_earning,"mytranscation":  FieldValue.arrayUnion([transcationdata.documentID.toString()])    }).then((data){
                      /// NOW HERE WE ADD TO COMPANY COMMISION



                      Firestore.instance.collection('company_earning').add({'amount': finalcompanycommisiontoaddwallet.toString(),
                        'amount_type':'booking complete',
                        'balance':'',
                        'booking_id':sharedprefrences.getString("BOOKINGID"),
                        'driver_id':driverid,
                        'remark':'BOOKINGCOMPLETE',
                        'status':'COMPLETE',
                        'transcation_id':transcationdata.documentID.toString(),

                      }).then((data){
                        String bookingid=sharedprefrences.getString("BOOKINGID");
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button for close dialog!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alert !'),
                              content:  Text('payment receive successfully done. please give review for other users.'),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text('No'),
                                  onPressed: () {

                                    Navigator.of(context).pop("Cancel");
                                    callpaymentfeedback(false);
                                  },
                                ),
                                FlatButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    callpaymentfeedback(true);

                                  },
                                )
                              ],
                            );
                          },
                        );
                        /*       Firestore.instance.collection('bookingrequest')
                            .document(bookingid).updateData({'booking_status':'complete','payment_status':'complete'});*/









                      });
                    });
                  });
                });
              });


            });
          });
        });











      });
    }
    catch(e){
      print(e);

    }
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message:"Payment Fail. please make payment to continue as a driver",
        ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("ExternalWalletResponse"+response.toString());
    // Do something when an external wallet is selected
  }


  void callpaymentfeedback(bool flag) {
    String bookingid=sharedprefrences.getString('BOOKINGID');

    try {
      var reference = Firestore.instance.collection('bookingrequest').document(
          bookingid);

      if(flag==false){
        String bokingid=sharedprefrences.getString('BOOKINGID');
        Firestore.instance.collection('bookingrequest')
            .document(bokingid).updateData({
          'feedback_status': 'ignore_by_user',

        }).then((data) async {

          setState(() =>
          search_bar = true);
          mapgadiresults.mapgadidata.clear();
          _polyline.clear();
          setState(() {
            _endpointcontroller.text=null;
          });

          setState(() {
            _endpointcontroller.text=null;
          });

          for (int i = 0; i < _markers.length; i++) {


            if (_markers
                .elementAt(i)
                .markerId.value == 'startpointmarker' ) {


            }
            else {

              Marker marker = _markers.firstWhere(
                      (p) =>
                  p.markerId ==
                      MarkerId(_markers
                          .elementAt(i).markerId.value),
                  orElse: () => null);

              _markers.remove(marker);



            }
          }
          sharedprefrences.setString('BOOKINGID', null);








        });
      }
      else{

        _createfeedbackdialogandupdaterefrencsesvalue(reference);


      }


    }catch(e){
      print(e);
    }
  }

  void _createfeedbackdialogandupdaterefrencsesvalue(DocumentReference reference) {

    ////
    var initialrationg=3.0;
    var feedbackcontroller= new TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
                ]),



            child: new Wrap(
              children: <Widget>[
                new Container(height: 50,width: double.infinity,color: Colors.black,alignment: Alignment.center,






                    child:Text('Feedback & Review',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),textAlign:TextAlign.center,)
                ),
                new Container(margin:const EdgeInsets.only(top:5,bottom: 5),alignment: Alignment.center,child:

                RatingBar(
                  initialRating: initialrationg,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.black,
                  ),
                  onRatingUpdate: (rating) {
                    initialrationg=rating;
                    print(rating);
                  },
                )
                ),
                new Container(height:250,decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.black)
                ),margin:const EdgeInsets.only(top:5,bottom: 5,left:5,right:5),
                    ////// FOR PASSWORD
                    child: new  SizedBox.expand( child:TextFormField(controller:feedbackcontroller,  maxLength: 250, maxLines: 20,  keyboardType: TextInputType.multiline,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 16) ,decoration: new InputDecoration(
                      hintText: 'Enter Feedback',
                      border: InputBorder.none,

                    ),))),
                new Container(margin:const EdgeInsets.only(top:5,bottom: 35),child:  Container(


                  child: Center(
                    child: Container(margin: const EdgeInsets.only(left: 55,right:55,top:0,bottom: 10) ,alignment: Alignment.center,
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
                            String feedback=feedbackcontroller.text.toString();
                            if(feedback.length==0||feedback.isEmpty||feedback==""){
                              Toast.show('Please enter feedback',context,duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
                            }
                            else{
                              Navigator.of(context).pop();
                              _sendfeedback(feedbackcontroller,initialrationg,reference);
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
                                    'Submit',
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
                    ),
                  ),
                ),),
              ],
            ),
          );
        }
    );
    ////

  }

  Future<void> _sendfeedback(TextEditingController feedbackcontroller, double initialrationg, DocumentReference reference) async {
    ///
    reference.get().then((datasnapshot) async{
      if (datasnapshot.exists) {

        await Firestore.instance.collection("feedback").add({
          'booking_id':sharedprefrences.getString('BOOKINGID'),
          "driver_id": datasnapshot.data['driver_id'],
          "feedback": feedbackcontroller.text.toString(),
          "level": '',
          "priority": '',
          "rating": initialrationg.toString(),
          "status": 'done',



          "user_id": sharedprefrences.getString("USERID"),








        }).then((documentReference) {
          print(documentReference.documentID);

          //

          print(documentReference.documentID);
          Firestore.instance.collection('bookingrequest')
              .document(sharedprefrences.getString('BOOKINGID'))
              .updateData(
              {'feedback_status': documentReference.documentID.toString()})
              .then((data) async {
            setState(() =>
            search_bar = true);
            mapgadiresults.mapgadidata.clear();
            _polyline.clear();
            setState(() {
              _endpointcontroller.text=null;
            });

            setState(() {
              _endpointcontroller.text=null;
            });

            for (int i = 0; i < _markers.length; i++) {


              if (_markers
                  .elementAt(i)
                  .markerId.value == 'startpointmarker' ) {


              }
              else {

                Marker marker = _markers.firstWhere(
                        (p) =>
                    p.markerId ==
                        MarkerId(_markers
                            .elementAt(i).markerId.value),
                    orElse: () => null);

                _markers.remove(marker);



              }
            }
            sharedprefrences.setString('BOOKINGID', null);



            //Redircetforpaymenttodriverregisterfees();
          });


          /// SAVE VALUES TO SHAREDPREFRENCES


//


        }).catchError((e) {
          progressDialog.hide();

          showDialog(barrierDismissible: false,
            context: context,
            builder: (_) =>
                GeneralMessageDialogBox(
                  Message: "Sorry there seems to be network server error please try again later",),
          );
        });




      }
      else{
        print("No such user");
      }});
    ///// BOOKING FEEDBACK SUBMIT AND GET DOCUMENT ID













  }

  void _cancelbyuserupdatestatusandnotifytodriver() {
    String bookingid=sharedprefrences.getString('BOOKINGID');

    var documentReference =
    Firestore.instance.collection("bookingrequest").document(bookingid);
    documentReference.get().then((data){
      if(data['booking_status']=='running'){
        /// createdialogboxwithcharges
      }
      else if(data['booking_status']=='accepted'||data['booking_status']=='pending'){


        Firestore.instance.collection('bookingrequest')
            .document(sharedprefrences.getString('BOOKINGID'))
            .updateData(
            {'booking_status': 'cancel_by_user','payment_status':'cancel by user before ride start'})
            .then((data) async {
          setState(() =>
          booking_search =
          false);
          setState(() =>
          search_bar = true);
          mapgadiresults.mapgadidata.clear();
          _polyline.clear();
          setState(() {
            _endpointcontroller.text=null;
          });

          setState(() {
            _endpointcontroller.text=null;
          });

          for (int i = 0; i < _markers.length; i++) {


            if (_markers
                .elementAt(i)
                .markerId.value == 'startpointmarker' ) {


            }
            else {

              Marker marker = _markers.firstWhere(
                      (p) =>
                  p.markerId ==
                      MarkerId(_markers
                          .elementAt(i).markerId.value),
                  orElse: () => null);

              _markers.remove(marker);



            }
          }
          sharedprefrences.setString('BOOKINGID', null);



          //Redircetforpaymenttodriverregisterfees();
        });







      }

    });










  }

  void _user_cancel_my_ride() {
    String fromaddresss=my_booking_Deteail_Data['from_address'];
    String toaddress=my_booking_Deteail_Data['to_address'];
    String descriptionmessage='are you sure you want to cancel this booking, standard charges will apply if you cancel this booking after ride start';

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert !'),
          content:  Text(descriptionmessage),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {

                Navigator.of(context).pop("Cancel");
                //callpaymentfeedback(false);
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                //callpaymentfeedback(true);
                //// UPSDATE BOOKINGDATA FOR CANCEL AND CHARGE

                String mybookingdriverid=my_booking_Deteail_Data['driver_id'];

                Firestore.instance.collection('driver').document(mybookingdriverid).get().then((data)
                {
                  String getdriver_status=data.data['driver_status'];
                  String drivervehicleid=data.data['vehicle_type_id'];
                  if(getdriver_status=="running")
                  {

                    Firestore.instance.collection('vehicle_type').document(drivervehicleid).get().then((data) {
                      double bookingpayment = double.parse(
                          my_booking_Deteail_Data['bookingpayment']);

                      double drivercancellationcharge = double.parse(data
                          .data['user_cancallation_charge']);


                      double finaldrivercommisiontoaddwallet = ((bookingpayment *
                          drivercancellationcharge) / 100);
                      double finalcompanycommisiontoaddwallet = ((bookingpayment *
                          drivercancellationcharge) / 100);

                      ///// DEDUCT PAYMENT FROM DRIVER WALLET

                      /// NOW HERE WE ADD TO COMPANY COMMISION


                      /* Firestore.instance.collection('company_earning').add({
                            'amount': finalcompanycommisiontoaddwallet
                                .toString(),
                            'amount_type': 'user cancellation charger',
                            'balance': '',
                            'booking_id': sharedprefrences.getString(
                                "BOOKINGID"),
                            'driver_id': mybookingdriverid,
                            'remark': 'booking cancel by user',
                            'status': 'payment collection pending',
                            'transcation_id': "wallet",

                          }).then((data) {*/
                      String bookingid = sharedprefrences.getString(
                          "BOOKINGID");
                      Firestore.instance.collection('bookingrequest')
                          .document(bookingid).updateData({
                        'booking_status': 'cancel_by_user',
                        'payment_status': 'pending'
                      });


                      Firestore.instance.collection('driver')
                          .document(
                          mybookingdriverid)
                          .updateData({
                        'driver_status': 'free',
                        'new_bookingrequest_id': ''
                      })
                          .then((data) {
                        ///// HERE WE MAKE DRIVERWALLETCONDITION TO RETIVE PAYMENT FROM HIS WALLET


                        /*setState(() =>
                              driver_infowithotp= false);
                              setState(() =>
                              search_bar = true);*/

                        // sharedprefrences.setString('BOOKINGID', null);
                        showDialog(barrierDismissible: false,
                          context: context,
                          builder: (_) =>
                              GeneralMessageDialogBox(
                                Message: "Your on going  Booking is cancelled and company charges deduct from your wallet",),
                        );


                      });

                    });
                    // });
                  }
                  else{

                    Firestore.instance.collection('bookingrequest')
                        .document(sharedprefrences.getString('BOOKINGID')).updateData({'booking_status':'cancel_by_user','payment_status':'cancelbeforeridestart'}).then((data)async{
                      setState(() =>
                      driver_infowithotp= false);
                      setState(() =>
                      search_bar = true);
                      mapgadiresults.mapgadidata.clear();
                      _polyline.clear();
                      setState(() {
                        _endpointcontroller.text=null;
                      });

                      setState(() {
                        _endpointcontroller.text=null;
                      });

                      for (int i = 0; i < _markers.length; i++) {


                        if (_markers
                            .elementAt(i)
                            .markerId.value == 'startpointmarker' ) {


                        }
                        else {

                          Marker marker = _markers.firstWhere(
                                  (p) =>
                              p.markerId ==
                                  MarkerId(_markers
                                      .elementAt(i).markerId.value),
                              orElse: () => null);

                          _markers.remove(marker);



                        }
                      }
                      sharedprefrences.setString('BOOKINGID', null);
                    });


                  }







                });

















              },
            )
          ],
        );
      },
    );




  }

  void crate_showbottomsheetdialogfordriverlayout(DocumentSnapshot datas) {

    String user_id=datas["user_id"];
    String otp=datas["otp"];
    double fromlat=double.parse(datas["from_lat"]);
    double fromlan=double.parse(datas["from_lng"]);
    double tolat=double.parse(datas["to_lat"]);
    double tolan=double.parse(datas["to_lng"]);
    String user_mobileno=datas["mobile"];
    //sharedprefrences.setString("booking_id",datas["booking_id"]);
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
                            _openotpverificationdialogbox(otp,context);
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
                                  ride_statue_button,
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

                          /////









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
                  ))]),
              ],
            ),
          );
        }
    );


  }

  void _continuewcheckifbookingiscanceledbydriverornot() {
    try{
      String bookingid=sharedprefrences.getString('BOOKINGID');
      var reference = Firestore.instance.collection('bookingrequest').document(bookingid);
      driver_bookinglistner_sec= reference.snapshots().listen((querySnapshot) async {

        //Toast.show(newbookingid, context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
        /*querySnapshot.documentChanges.forEach((change) {
          // Do something with change
        });*/
        String bookingstatus=querySnapshot.data['booking_status'];
        if(bookingstatus=='cancel_by_user'){
          //Toast.show('booking is cancelled by user',context,duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
          Firestore.instance.collection('driver')
              .document(sharedprefrences.getString('DRIVERID')).updateData({'driver_status':'free','new_bookingrequest_id':''});
          sharedprefrences.setString("BOOKINGID", null);
          driver_bookinglistner_sec.pause();
          driver_startsockerforsendrequestforbooking() ;
            ////// CAL REQUEST SOCKET IN EVERY SECONDFOR BOOKING RE
          setState(() => userisdriver = false);
          booking_request_driver_dialog = false;
          showDialog(barrierDismissible: false,
            context: context,
            builder: (_) =>
                GeneralMessageDialogBox(
                  Message: "Hello your current booking is cancel by user. now you can get another booking",),
          );
          //// UPDATE STATUS TO DRIVER



        }


      });
    }catch(e)
    {
      String s =e.toString();
    }

  }

  void _confirmdialogboxforridecomplete() {
    String paymentstatus =driver_booking_header_datas['paymentmode'];
    String payment=driver_booking_header_datas['bookingpayment'];
    String descriptionmessage;
    if(paymentstatus=="COD"){
      descriptionmessage='are you sure you want to complete this booking and collect amount to rider '+payment+" ?";
    }
    else{
      descriptionmessage='are you sure you want to complete this booking ?';
    }


    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert !'),
          content:  Text(descriptionmessage),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {

                Navigator.of(context).pop("Cancel");
                //callpaymentfeedback(false);
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                //callpaymentfeedback(true);
                //// UPSDATE BOOKINGDATA FOR CANCEL AND CHARGE
                if(paymentstatus=="COD")
                {
                  _createdialogforclosewithcod();
                }
                else{







                  /// UPDATE IN BOOKING DATA
                  String bookingid=sharedprefrences.getString("BOOKINGID");
                  Firestore.instance.collection('bookingrequest')
                      .document(bookingid).updateData({'booking_status':'complete'});


                  Firestore.instance.collection('driver')
                      .document(sharedprefrences.getString('DRIVERID')).updateData({'driver_status':'free','new_bookingrequest_id':''}).then((data){
                    setState(() {
                      ridestart=false;

                    });setState(() {
                      userisdriver=false;

                    });
                    sharedprefrences.setString("BOOKINGID", null);
                    driver_booking_header_datas.clear();
                    driver_bookinglistner.resume();
                    driver_startsockerforsendrequestforbooking();


                  });





                  showDialog(barrierDismissible: false,
                    context: context,
                    builder: (_) =>
                        GeneralMessageDialogBox(
                          Message: "Congratulation. your booking is complete and payment will added in your wallet soon.",),
                  );
                }







              },
            )
          ],
        );
      },
    );

  }

  void _createdialogforclosewithcod() {

    String paymentstatus =driver_booking_header_datas['paymentmode'];
    String payment=driver_booking_header_datas['bookingpayment'];
    String descriptionmessage;

    descriptionmessage='Your booking is complete and make sure you collect amount of '+payment+" from rider ?";



    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert !'),
          content:  Text(descriptionmessage),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {

                Navigator.of(context).pop("Cancel");
                //callpaymentfeedback(false);
              },
            ),
            FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  //callpaymentfeedback(true);
                  //// UPSDATE BOOKINGDATA FOR CANCEL AND CHARGE
                  Firestore.instance.collection('vehicle_type').document(sharedprefrences.getString("DRIVERVEHICLEID")).get().then((data){
                    double bookingpayment=double.parse(payment);

                    double drivercommision=double.parse(data.data['driver_commision']);
                    double companycommision=double.parse(data.data['company_commision']);


                    double finaldrivercommisiontoaddwallet= ((bookingpayment*drivercommision)/100);
                    double finalcompanycommisiontoaddwallet= ((bookingpayment*companycommision)/100);

                    ///// DEDUCT PAYMENT FROM DRIVER WALLET
                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('EEE, dd/MMM/yyyy, hh:mm a ').format(now);

                    Map<String,dynamic> transcationdata=
                    {
                      'amount':payment,
                      'booking_id':sharedprefrences.getString("BOOKINGID"),
                      'driver_id':sharedprefrences.getString("DRIVERID"),
                      'message': payment+" is credited in your wallet",
                      'order_id':"cod",
                      'payment_id':"cod",
                      'paymentmethod':"cod",
                      'paymentstatus':"cr",
                      'signature':"",
                      'user_id':"",
                      'timestamp':formattedDate,
                      'walletname':sharedprefrences.getString('DRIVERWALLETID'),

                    };
                    Firestore.instance.collection('transcation').add(transcationdata).then((transcationdata){


                      Firestore.instance.collection('wallet').document(sharedprefrences.getString('DRIVERWALLETID')).get().
                      then((walletdata){
                        double driver_balance=double.parse(walletdata.data['balance']);
                        double driver_totalearning=double.parse(walletdata.data['total_earning']);
                        double update_driver_total_earning=driver_totalearning+bookingpayment;

                        var updatedriverwalletbalance= driver_balance-finaldrivercommisiontoaddwallet;
                        //// UPDATE TO DRIVER WALLET
                        Firestore.instance.collection('wallet').document(sharedprefrences.getString('DRIVERWALLETID'))
                            .updateData({'balance':updatedriverwalletbalance.toString(),'total_earning':update_driver_total_earning.toString(),"mytranscation":  FieldValue.arrayUnion([transcationdata.documentID.toString()])    }).then((data){
                          /// NOW HERE WE ADD TO COMPANY COMMISION



                          Firestore.instance.collection('company_earning').add({'amount': finalcompanycommisiontoaddwallet.toString(),
                            'amount_type':'booking complete',
                            'balance':'',
                            'booking_id':sharedprefrences.getString("BOOKINGID"),
                            'driver_id':sharedprefrences.getString("DRIVERID"),
                            'remark':'BOOKINGCOMPLETE',
                            'status':'COMPLETE',
                            'transcation_id':transcationdata.documentID.toString(),

                          }).then((data){
                            String bookingid=sharedprefrences.getString("BOOKINGID");
                            Firestore.instance.collection('bookingrequest')
                                .document(bookingid).updateData({'booking_status':'complete','payment_status':'complete'});


                            Firestore.instance.collection('driver')
                                .document(sharedprefrences.getString('DRIVERID')).updateData({'driver_status':'free','new_bookingrequest_id':''}).then((data){

                              ///// HERE WE MAKE DRIVERWALLETCONDITION TO RETIVE PAYMENT FROM HIS WALLET


                              setState(() {
                                ridestart=false;

                              });setState(() {
                                userisdriver=false;

                              });
                              sharedprefrences.setString("BOOKINGID", null);
                              driver_startsockerforsendrequestforbooking();
                              driver_booking_header_datas.clear();
                              driver_bookinglistner.resume();
                              showDialog(barrierDismissible: false,
                                context: context,
                                builder: (_) =>
                                    GeneralMessageDialogBox(
                                      Message: "Congratulation. your booking is complete and payment will added in your wallet soon.",),
                              );






                            });


                          });



                        });



                      });});

















                    /// UPDATE IN BOOKING DATA


                    //// UPDATE STATUS IN MY WALLET PAYMENT







                  });






                }








            )
          ],
        );
      },
    );



  }


  _handlePaymentSuccessforusercancellationcharger(double finalcompanycommisiontoaddwallet, String mybookingdriverid) {



    try {
      ////  FIRST CALL TRANSCATION AND THEN UPDATE IN SDRIVER WALLET ID


      Firestore.instance.collection('company_earning').add({
        'amount': finalcompanycommisiontoaddwallet
            .toString(),
        'amount_type': 'user cancellation charger',
        'balance': '',
        'booking_id': sharedprefrences.getString(
            "BOOKINGID"),
        'driver_id': mybookingdriverid,
        'remark': 'booking cancel by user',
        'status': 'Booking Cancel',
        'transcation_id': "wallet",

      }).then((data) {
        String bokingid=sharedprefrences.getString('BOOKINGID');
        Firestore.instance.collection('bookingrequest')
            .document(bokingid).updateData({
          'payment_status': 'complete',

        }).then((data) async {


          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button for close dialog!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert !'),
                content:  Text('payment receive successfully done. please give review for other users.'),
                actions: <Widget>[

                  FlatButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() =>
                      driver_infowithotp = false);
                      setState(() =>
                      search_bar = true);
                      mapgadiresults.mapgadidata.clear();
                      _polyline.clear();
                      setState(() {
                        _endpointcontroller.text=null;
                      });

                      setState(() {
                        _endpointcontroller.text=null;
                      });

                      for (int i = 0; i < _markers.length; i++) {


                        if (_markers
                            .elementAt(i)
                            .markerId.value == 'startpointmarker' ) {


                        }
                        else {

                          Marker marker = _markers.firstWhere(
                                  (p) =>
                              p.markerId ==
                                  MarkerId(_markers
                                      .elementAt(i).markerId.value),
                              orElse: () => null);

                          _markers.remove(marker);



                        }
                      }
                      sharedprefrences.setString('BOOKINGID', null);

                    },
                  )
                ],
              );
            },
          );






        });



      });










    }
    catch(e){
      print(e);

    }








  }

  void _updatemapandgetdriverlatlongandrotateonmap(Map<String,dynamic > data) {
    /// CLEAR MAP
    _markers.clear();
    _polyline.clear();

    /// GET DRIVER VEHICLE TYPE AND SET VEHICLE ICON ACCORDING TO DRIVER TYPE
    String driver_id=data['driver_id'];

    Firestore.instance.collection('driver').document(driver_id).get().then((driverdata){
      String vehicletype=driverdata.data['vehicle_type'];


      if(vehicletype=="car") {
        BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), 'images/car_icon.png')
            .then((onValue) {
          mapvehicle_icon = onValue;
        });
      }
      else if(vehicletype=="two-wheeler"||vehicletype=="bike"){
        BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), 'images/bike_icon.png')
            .then((onValue) {
          mapvehicle_icon = onValue;
        });
      }
      else if(vehicletype=="Auto"){
        BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), 'images/auto_icon.png')
            .then((onValue) {
          mapvehicle_icon = onValue;
        });
      }
      else if(vehicletype=="E-Auto"){
        BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), 'images/car_icon.png')
            .then((onValue) {
          mapvehicle_icon = onValue;
        });
      }
      else if(vehicletype=="scooty")
      {
        BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), 'images/car_icon.png')
            .then((onValue) {
          mapvehicle_icon = onValue;
        });
      }








      ///// NOW LISTEN LATLONG AND MOVE CAMERA AND ICON
      double oldlat=0.0,oldlng=0.0;
       var refrence= Firestore.instance.collection('driver').document(driver_id);

      driver_latlngupdatetouserlistner= refrence.snapshots().listen((querySnapshot) async {
        double updatelat=double.parse(querySnapshot.data['driver_lat']);
        double updatetlon=double.parse(querySnapshot.data['driver_lng']);

        double _direction;

        double dLon = (updatetlon-oldlng);
        double y = sin(dLon) * cos(updatelat);
        double x = cos(oldlat)*sin(updatelat) - sin(oldlat)*cos(updatelat)*cos(dLon);
        double brng = ((atan2(y, x)));
        brng = (360 - ((brng + 360) % 360));
        print("brng"+brng.toString());



        FlutterCompass.events.listen((double direction) {
          setState(() {
            _direction = direction;
          });
        });
        Marker marker = _markers.firstWhere(
                (p) =>
            p.markerId == MarkerId(driver_id),
            orElse: () => null);
        _markers.remove(marker);
        final _latTween = Tween<double>(
            begin: oldlat, end: updatelat);
        final _lngTween = Tween<double>(
            begin: oldlng, end: updatetlon);
        final _zoomTween = Tween<double>(begin: 20.0, end: 20.0);
        var controller = AnimationController(
            duration: const Duration(milliseconds: 1500), vsync: this);
        // The animation determines what path the animation will take. You can try different Curves values, although I found
        // fastOutSlowIn to be my favorite.
        Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
       /* controller.addListener(() {
          mapController_sec.move(
              LatLng(updatelat.evaluate(animation), _lngTween.evaluate(animation)),
              _zoomTween.evaluate(animation));
        });*/


        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(driver_id),
          position: LatLng(updatelat, updatetlon),
          draggable: false,
          rotation:brng,

          infoWindow: InfoWindow(
            // title is the address

            // snippet are the coordinates of the position

          ),

          icon: mapvehicle_icon,
        ));

         controller.addListener(() {

           mapController_sec.animateCamera(
             CameraUpdate.newCameraPosition(
               CameraPosition(
                 target: new LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),

                 zoom: _zoomTween.evaluate(animation)),
               ),
             );

          /*mapController_sec.move(
              LatLng(updatelat.evaluate(animation), _lngTween.evaluate(animation)),
              _zoomTween.evaluate(animation));*/
        });
        /*mapController_sec.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: new LatLng(updatelat, updatetlon),

              zoom: 20.0,
            ),
          ),
        );*/
        oldlat=updatelat;
        oldlng=updatetlon;


      });









    });





  }

  void _updatedriverstatus(bool driverchoice) {
    if(driverchoice==true){
      Firestore.instance.collection('driver').
      document(sharedprefrences.getString("DRIVERID"))
          .updateData({'driver_status':'free'})
          .then((updatedata){
setState(() {
  driveractivestatus=false;
});
      });
    }
    else{
      Firestore.instance.collection('driver').
      document(sharedprefrences.getString("DRIVERID"))
          .updateData({'driver_status':'deactive'})
          .then((updatedata){
        setState(() {
          driveractivestatus=true;
        });
      });

    }


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

