import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nber_flutter/CommonModels.dart';
import 'package:nber_flutter/VehicleTypeModel.dart';
import 'dart:convert';
import 'CallApiforGetVehicle.dart';
import 'ImagePickerHandler.dart';
import 'MyColors.dart';
import 'UpdateDriverDocumentApi.dart';
import 'appTheme.dart';
import 'package:image/image.dart' as ImageProcess;
import 'fitnessApp/fintnessAppTheme.dart';

class BEcomeDriverFile extends StatefulWidget {
  @override
  _BEcomeDriverFileState createState() => _BEcomeDriverFileState();
}

class _BEcomeDriverFileState extends State<BEcomeDriverFile>
    with TickerProviderStateMixin,ImagePickerListener {
  AnimationController animationController;
  CallApiforGetVehicle _callapiforvehicle;
  List<String> _locations;
  Future<File> imageFile;
  String selectedvehiceltype;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  UploadDriverDocumentApi _uploaddriverdocumentapi;
  File _image;
bool dlfrontcopy,dlbackcopy,pancardcopy,rtocertificatecopyfront,rtodertificateback,insurancefirst,insurancesecond,insurancethird,aadharfront,aadharback,policiverificationcopy,vehiclephotofrontcopy,vehiclephotoback,rccopyfront,rccopyback;
  String str_dlfrontcopy,str_dlbackcopy,str_pancardcopy,str_rtocertificatecopyfront,str_rtodertificateback,
      str_insurancefirst,str_insurancesecond,str_insurancethird,str_aadharfront,str_aadharback,
      str_policiverificationcopy,str_vehiclephotofrontcopy,str_vehiclephotoback,
      str_rccopyfront,str_rccopyback;

Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

  @override
  void initState() {
    _uploaddriverdocumentapi=UploadDriverDocumentApi();
    _callapiforvehicle = new CallApiforGetVehicle();
    _locations = new List();
    _controller = new AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 500),
    );


    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    callapiforgetvehicle();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return

              Container(
                  color: FintnessAppTheme.background,
                  child:
                  Scaffold(
                      backgroundColor: AppTheme.white,
                      body:


                      SingleChildScrollView(scrollDirection: Axis.vertical,
                          child: new Container(margin: const EdgeInsets.only(
                              top: 10, left: 00, bottom: 10, right: 00),


                            child: new Column(children: <Widget>[

                              appBar(),
                              ///// VEHICLE NO
                              Align(alignment: Alignment.topLeft,
                                child: new Container(alignment: Alignment
                                    .topLeft,
                                  child: Text('First Name', style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),


                                  ),),),
                              Container(margin: const EdgeInsets.only(
                                  left: 0, right: 10),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 4),
                                  decoration: new BoxDecoration(color: MyColors
                                      .white, border: Border(
                                      bottom: BorderSide(color: Colors.black,
                                        width: 1.0,)),),


                                  child: new Row(children: <Widget>[

                                    Expanded(flex: 10,
                                      child: TextFormField(
                                          textAlign: TextAlign.start,
                                          keyboardType: TextInputType.text,
                                          obscureText: false,
                                          style: TextStyle(color: Colors.black,
                                              fontSize: 14),
                                          decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: new OutlineInputBorder(
                                                  borderRadius: new BorderRadius
                                                      .circular(20.00),
                                                  borderSide: new BorderSide(
                                                      color: Colors.white)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius: BorderRadius
                                                      .circular(20.00)),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius
                                                    .circular(20.0),),
                                              contentPadding: EdgeInsets.only(
                                                  left: 00,
                                                  top: 0,
                                                  right: 10,
                                                  bottom: 0),
                                              hintText: "Enter Vehicle Number"
                                          )),
                                    ),

                                  ])),
                              ///// VEHICLE TYPE
                              Row(children: <Widget>[
                                Expanded(flex: 10,
                                  child: Text('Select Your Vehicle Type'),
                                ),
                                Expanded(flex: 10,
                                  child: new DropdownButton<String>(
                                    hint: new Text("Select a user"),
                                    value: selectedvehiceltype,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectedvehiceltype = newValue;
                                      });
                                    },
                                    items: _locations.map((String user) {
                                      return new DropdownMenuItem<String>(
                                        value: user,
                                        child: new Text(
                                          user,
                                          style: new TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ]),


                              //// LICENCE FRONT
                              InkWell(
                                  onTap: () {
                                    dlfrontcopy=true;
                                    imagePicker.showDialog(context);
                                  },
                                  child: Container(margin: const EdgeInsets
                                      .only(top: 10),
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text(
                                            'Upload Driving Licence Front Copy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// LICENCE BACK
                              , InkWell(onTap: () {
                                dlbackcopy=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Driving Licence Back Copy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// PANCARD
                              , InkWell(onTap: () {
                                pancardcopy=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Pancard Front Copy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// RTO CERTIFICATE FRONT
                              , InkWell(onTap: () {
                                rtocertificatecopyfront=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text(
                                            'Upload RTO Certificate Front Copy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// RTO CERTIFICATE BACK
                              , InkWell(onTap: () {
                                rtodertificateback=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload RTO Certificate Back Copy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// INSURANCE FIRST PAGE
                              , InkWell(onTap: () {
                                insurancefirst=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Insurance First Page',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// INSURANCE SECOND
                              , InkWell(onTap: () {
                                insurancesecond=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Insurance Second Page',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// INSURANCE THIRD
                              , InkWell(onTap: () {
                                insurancethird=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Insurance Third Page',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// AADHAR FRONT
                              , InkWell(onTap: () {
                                aadharfront=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Aadhar Front Copy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// AADHAR SECOND
                              , InkWell(onTap: () {
                                aadharback=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Aadhar back Copy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// POLICE VERIFICATION
                              , InkWell(onTap: () {
                                policiverificationcopy=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Police Verification Copy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// VEHICLE PHOTO FRONT
                              , InkWell(onTap: () {
                                vehiclephotofrontcopy=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Vehicle Photo Front',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// VEHICLE PHOTO BACK
                              , InkWell(onTap: () {
                                vehiclephotoback=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload Vehicle Photo Back',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// RC COPY FRONT
                              , InkWell(onTap: () {
                                rccopyfront=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload RC Copy Front',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              )

                              /// RC COPY BACK
                              , InkWell(onTap: () {
                                rccopyback=true;
                                imagePicker.showDialog(context);
                              },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        color: MyColors.white,
                                        border: Border(bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,),
                                            top: BorderSide(color: Colors.black,
                                              width: 1.0,)),),
                                      padding: EdgeInsets.only(top: 10,
                                          left: 5,
                                          right: 5,
                                          bottom: 10),

                                      child: Row(children: <Widget>[
                                        Text('Upload RC Copy Back',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),
                                        Flexible(fit: FlexFit.tight,
                                            child: SizedBox()),
                                        Expanded(child: Image.asset(
                                          'images/yellow_logo.png', height: 25,
                                          width: 25,))


                                      ],))
                              ),

                              ///
                              Align( alignment: Alignment.bottomCenter,
                                child: new Container(


                                  margin: const EdgeInsets.only(left: 55,right:55,top:15) ,
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
                                      onTap: ()
                                      {
                                        // _callvalidation();
                                        //////
                                        /* Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(builder: (ctxt) => new DashBoardFile()),
                      );*/
                                        callapiforpostdocumentandgetresponse();


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
                                                'Next',
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
                              )

                            ]),
                          )
                      )
                  )
              );
          };
        });
  }


  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "Profile",
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

  Future<void> callapiforgetvehicle() async {
    VehicleTypeModel vehicletypemodel = await _callapiforvehicle.search("");
    String status = vehicletypemodel.status;
    String message = vehicletypemodel.message;
    if (status == "200") {
      for (int i = 0; i < vehicletypemodel.notificationdata.length; i++) {
        String jj = vehicletypemodel.notificationdata[i].type;

        _locations.add(jj);
      }
      int jj = _locations.length;
    }
    else {

    }
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    return true;
  }

  @override
  userImage(File _image) async {
    setState(() {
      final _imageFile = ImageProcess.decodeImage(_image.readAsBytesSync(),
      );



      String base64Image = base64Encode(ImageProcess.encodePng(_imageFile));
      String jj=base64Image;
      print("IMAGEIN BASDE"+jj);
      ////
     if( dlfrontcopy==true){
       dlbackcopy=false;
       str_dlbackcopy=base64Image;
     }
     if( pancardcopy==true){
      pancardcopy=false;
      str_pancardcopy=base64Image;
      }

      if( rtocertificatecopyfront==true){
      rtocertificatecopyfront=false;
      str_rtocertificatecopyfront=base64Image;
      }

      if( rtodertificateback==true){
      rtodertificateback=false;
      str_rtodertificateback=base64Image;
      }

      if( insurancefirst==true){
      insurancefirst=false;
      str_insurancefirst=base64Image;
      }

      if( insurancesecond==true){
      insurancesecond=false;
      str_insurancesecond=base64Image;
      }

      if( insurancethird==true){
      insurancethird=false;
      str_insurancethird=base64Image;
      }

      if( aadharfront==true){
      aadharfront=false;
      str_aadharfront=base64Image;
      }

      if( aadharback==true){
      aadharback=false;
      str_aadharback=base64Image;
      }

      if( policiverificationcopy==true){
      policiverificationcopy=false;
      str_policiverificationcopy=base64Image;
      }

      if( vehiclephotofrontcopy==true){
      vehiclephotofrontcopy=false;
      str_vehiclephotofrontcopy=base64Image;
      }

      if( vehiclephotoback==true){
      vehiclephotoback=false;
      str_vehiclephotoback=base64Image;
      }

      if( rccopyfront==true){
      rccopyfront=false;
      str_rccopyfront=base64Image;
      }

      if( rccopyback==true){
      rccopyback=false;
      str_rccopyback=base64Image;
      }


      ////












    });
  }

  Widget showimage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Future<void> callapiforpostdocumentandgetresponse()  async{
   /* print( "str_dlfrontcopy"+str_dlfrontcopy);
    print( "str_pancardcopy"+str_pancardcopy);

        print( "str_rtocertificatecopyfront"+str_rtocertificatecopyfront);

        print( "str_rtodertificateback"+str_rtodertificateback);

        print( "str_insurancefirst"+str_insurancefirst);

        print( "str_insurancesecond"+str_insurancesecond);

        print( "str_insurancethird"+str_insurancethird);

        print( "str_aadharfront"+str_aadharfront);

        print( "str_aadharback"+str_aadharback);

        print( "str_policiverificationcopy"+str_policiverificationcopy);

        print( "str_vehiclephotofrontcopy"+str_vehiclephotofrontcopy);

        print( "str_vehiclephotoback"+str_vehiclephotoback);

        print( "str_rccopyfront"+str_rccopyfront);

        print( "rccopyback"+str_rccopyback);

*/

   CommonModels models= await _uploaddriverdocumentapi.search("", "", "", "", "", "", "", "", "", "", "","");
   String status= models.status;


   if(status=='200')
     {

     }
   else
     {

   }




  }
}