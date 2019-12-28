import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nber_flutter/CommonModels.dart';
import 'package:nber_flutter/VehicleTypeModel.dart';
import 'package:nber_flutter/customDrawer/homeDrawer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'CallApiforGetVehicle.dart';
import 'GenralMessageDialogBox.dart';
import 'ImagePickerHandler.dart';
import 'Login.dart';
import 'MyColors.dart';
import 'UpdateDriverDocumentApi.dart';
import 'Utils/Constants.dart';
import 'appTheme.dart';
import 'package:toast/toast.dart';
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
  List<String> vehicle_type_id;
  Future<File> imageFile;
  ProgressDialog progressDialog;
  String selectedvehiceltype;
  String selectedvehicletypeid;
  bool  showdata = false;
  VehicleTypeModel vehicletypemodel;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  SharedPreferences sharedprefrences;
  List<VehicleTypeData> vehicledatalist;
  UploadDriverDocumentApi _uploaddriverdocumentapi;
  File _image;
  final ScrollController listScrollController = ScrollController();
  final focusNode = FocusNode();
  var vehiclenumbercontroller;
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
    vehicledatalist=new List();
    listScrollController.addListener(_scrollListener);
    vehiclenumbercontroller=TextEditingController();
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
    _uploaddriverdocumentapi=UploadDriverDocumentApi();
    _callapiforvehicle = new CallApiforGetVehicle();
    _locations = new List();
    vehicle_type_id=new List();
    _controller = new AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 500),
    );


    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    Future.delayed(Duration.zero, () {
      callapiforgetvehicle();
    });

    super.initState();


  }
  _scrollListener() {
    focusNode.nextFocus();
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      new GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            focusNode.unfocus();
            FocusScope.of(context).requestFocus(new FocusNode());

            //FocusScope.of(context).unfocus();
          },
          child:
          Container(
              color: FintnessAppTheme.background,

              child:
              showdata ? Scaffold(
                  appBar: appBar(),
                  backgroundColor: AppTheme.white,
                  body:


                  SingleChildScrollView(scrollDirection: Axis.vertical,
                      controller: listScrollController,
                      child: new Container(margin: const EdgeInsets.only(
                          top: 10, left: 10, bottom: 10, right: 10),


                        child: new Column(children: <Widget>[


                          ///// VEHICLE NO
                          Align(alignment: Alignment.topLeft,
                            child: new Container(margin: const EdgeInsets.only(left:10), alignment: Alignment
                                .topLeft,
                              child: Text('Vehicle Number', style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),


                              ),),),
                          Container(margin: const EdgeInsets.only(
                              left: 10, right: 10),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 4),
                              decoration: new BoxDecoration(color: MyColors
                                  .white, border: Border(
                                  bottom: BorderSide(color: Colors.black,
                                    width: 1.0,)),),


                              child: new Row(children: <Widget>[

                                Expanded(flex: 10,
                                  child: TextFormField(controller: vehiclenumbercontroller,
                                      textAlign: TextAlign.start,focusNode: focusNode,
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
                          Container(margin: const EdgeInsets.only(left:10), child:Row(children: <Widget>[
                            Expanded(flex: 10,
                              child: Text('Select Your Vehicle Type'),
                            ),
                            Expanded(flex: 10,
                              child: new DropdownButton<String>(
                                hint: new Text("Select Vehicle"),
                                value: selectedvehiceltype,
                                onChanged: (String newValue) {
                                  setState(() {
                                    selectedvehiceltype = newValue;
                                    Toast.show(selectedvehiceltype, context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);
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
                          ])),


                          //// LICENCE FRONT
                          InkWell(
                              onTap: () {
                                dlfrontcopy=true;
                                imagePicker.showDialog(context);
                              },
                              child: Container(width:double.infinity,margin: const EdgeInsets
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

                                  child: Row( children: <Widget>[

                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text(
                                        'Upload Driving Licence Front Copy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_dlfrontcopy!=null?Expanded(child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,)):SizedBox(),






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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Driving Licence Back Copy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_dlbackcopy!=null?Expanded(child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,)):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Pancard Front Copy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_pancardcopy!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 43), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text(
                                        'Upload RTO Certificate Front Copy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_rtocertificatecopyfront!=null?Expanded(child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,)):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload RTO Certificate Back Copy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_rtodertificateback!=null?Expanded(child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,)):SizedBox(),




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Insurance First Page',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_insurancefirst!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 38), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Insurance Second Page',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_insurancesecond!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 20), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Insurance Third Page',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_insurancethird!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 35), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Aadhar Front Copy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_aadharfront!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 50), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Aadhar back Copy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_aadharback!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 52), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Police Verification Copy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_policiverificationcopy!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 20), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Vehicle Photo Front',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_vehiclephotofrontcopy!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 45), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload Vehicle Photo Back',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_vehiclephotoback!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 46), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox()




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),
                                    Text('Upload RC Copy Front',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_rccopyfront!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 80), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox(),




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
                                    Padding(padding: const EdgeInsets.only(right: 10),child:Image.asset(
                                      'images/upload.png', height: 25,
                                      width: 25,) ,),

                                    Text('Upload RC Copy Back',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    str_rccopyback!=null?Expanded(child:
                                    Container(margin: const EdgeInsets.only(left: 80), child:
                                    Image.asset('images/green-tick.png',height: 25,
                                      width: 25,))):SizedBox(),




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
              ): SizedBox()
          ));


  }


  Widget appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48.0),


      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "Become Driver",
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
    try {
      sharedprefrences= await SharedPreferences.getInstance();
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
      try {
        for (int i = 0; i < list.length; i++) {

          _setvaluetolist(list[i].data,list[i].documentID);
        }
      }catch(e){
        print(e);
        String ss=e.toString();
      }




      /*if (status == "200") {
        progressDialog.hide();
        if (vehicletypemodel.notificationdata.length > 0) {


        for (int i = 0; i < vehicletypemodel.notificationdata.length; i++) {
          String jj = vehicletypemodel.notificationdata[i].type;

          _locations.add(jj);
        }
        int jj = _locations.length;
        setState(() {
          showdata=!showdata;
        });

      }
        else{
          progressDialog.hide();
          showDialog(barrierDismissible: false,
              context: context,
              builder: (_) => GeneralMessageDialogBox(Message:"Sorry There is No any Vehicle Model availalbe for you can book your Vehicle.",
              ));
        }

      }
      else {
        progressDialog.hide();


        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:message,
            ));
       // Navigator.of(context).pop();
      }*/
    }catch(e){
      progressDialog.hide();
      print(e);
      String ss=e.toString();
      // Navigator.of(context).pop();
      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message:"Sorry there seems to be a network server error please try again later.",
          ));

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


      ////
      if( dlfrontcopy==true){
        // dlfrontcopy=false;
        /// UPLOAD IMAGE FILE TO FIREBASE INSTANCE AFTER SELECTION COMPLETE


        _uploadimageinstancetofirebase(_image,'driver_dlfrontcopy');

      }
      else if( dlbackcopy==true){
        _uploadimageinstancetofirebase(_image,'driver_dlbackcopy');
      }
      else  if( pancardcopy==true){
        _uploadimageinstancetofirebase(_image,'driver_pancardcopy');
      }

      else if( rtocertificatecopyfront==true){
        _uploadimageinstancetofirebase(_image,'driver_rtocertificatefrontcopy');
      }

      else if( rtodertificateback==true){
        _uploadimageinstancetofirebase(_image,'driver_trocertificatebackcopy');
      }

      else if( insurancefirst==true){
        _uploadimageinstancetofirebase(_image,'driver_insurancefirstcopy');
      }

      else if( insurancesecond==true){
        _uploadimageinstancetofirebase(_image,'driver_insurancesecondcopy');
      }

      else if( insurancethird==true){
        _uploadimageinstancetofirebase(_image,'driver_insurancethirdcopy');
      }

      else  if( aadharfront==true){
        _uploadimageinstancetofirebase(_image,'driver_aadharfrontcopy');
      }

      else  if( aadharback==true){
        _uploadimageinstancetofirebase(_image,'driver_aadharbackcopy');

      }

      if( policiverificationcopy==true){
        _uploadimageinstancetofirebase(_image,'driver_policeverificationcopy');
      }

      if( vehiclephotofrontcopy==true){
        _uploadimageinstancetofirebase(_image,'driver_vehiclefrontcopy');
      }

      if( vehiclephotoback==true){
        _uploadimageinstancetofirebase(_image,'driver_vehiclebackcopy');
      }

      if( rccopyfront==true){
        _uploadimageinstancetofirebase(_image,'driver_rcfrontcopy');
      }

      if( rccopyback==true){
        _uploadimageinstancetofirebase(_image,'driver_rcbackcopy');
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
    try {
      String vehiclenumber = vehiclenumbercontroller.text.toString();
      if(selectedvehiceltype==null|| selectedvehiceltype.isEmpty||selectedvehiceltype==""){

        /* for(int i=0;i<vehicletypemodel.notificationdata.length;i++){
        if(vehicletypemodel.notificationdata[i].type==selectedvehiceltype){
          selectedvehicletypeid=vehicletypemodel.notificationdata[i].id;
          break;
        }
      }*/

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Select Vehicle Type",
            ));
      }
      else if (vehiclenumber == null || vehiclenumber.length <= 0) {
        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Enter Vehicle Number",
            ));
      }
      else if (str_dlfrontcopy == null || str_dlfrontcopy.length <= 0) {
        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload DL Front Copy",
            ));
      }

      else if (str_pancardcopy == null || str_pancardcopy.length <= 0) {
        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload PAN CARD COPY",
            ));
      }

      else if (str_rtocertificatecopyfront == null ||
          str_rtocertificatecopyfront.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload RTO Certificate Front Copy",
            ));
      }


      else if (str_rtodertificateback == null ||
          str_rtodertificateback.length <= 0) {


        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload RTO Certificate Back Copy",
            ));

      }

      else if (str_insurancefirst == null || str_insurancefirst.length <= 0) {


        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload INSURANCE First",
            ));
      }

      else if (str_insurancesecond == null || str_insurancesecond.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload INSURANCE Second",
            ));
      }

      else if (str_insurancethird == null || str_insurancethird.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload INSURANCE Third",
            ));
      }

      else if (str_aadharfront == null || str_aadharfront.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload AADHAR Front",
            ));
      }

      else if (str_aadharback == null || str_aadharback.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload AADHAR Back",
            ));
      }

      else if (str_policiverificationcopy == null ||
          str_policiverificationcopy.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload POLICE Verification Copy",
            ));

      }

      else if (str_vehiclephotofrontcopy == null ||
          str_vehiclephotofrontcopy.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload VEHICLE Photo Front Copy",
            ));
      }

      else
      if (str_vehiclephotoback == null || str_vehiclephotoback.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload VEHICLE Photo BACK Copy",
            ));
      }

      else if (str_rccopyfront == null || str_rccopyfront.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload RC Copy Front",
            ));
      }

      else if (str_rccopyback == null || str_rccopyback.length <= 0) {

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:"Upload RC Copy Back",
            ));
      }
      else {
        /*  String mobile = sharedprefrences.getString("MOBILE");
        String Token = "Bearer " + sharedprefrences.getString("TOKEN");
*/

        /*    CommonModels models = await _uploaddriverdocumentapi.search(
            '',
            '',
            str_dlfrontcopy,
            str_dlbackcopy,
            str_pancardcopy,
            str_rtocertificatecopyfront,
            str_rtodertificateback,
            str_insurancefirst,
            str_insurancesecond,
            str_insurancethird,
            str_aadharfront,
            str_aadharback,
            str_policiverificationcopy,
            str_vehiclephotofrontcopy,
            str_vehiclephotoback,
            str_rccopyfront,
            str_rccopyback,
            vehiclenumber,selectedvehicletypeid);
        String status = models.status;*/

        try {

          SharedPreferences sharedPreferences = await SharedPreferences
              .getInstance();
          String driverid=sharedPreferences.getString("DRIVERID");
          if (driverid == null||driverid.isEmpty||driverid=="") {


            progressDialog.show();


            for (int i = 0; i < vehicledatalist.length; i++) {
              if (selectedvehiceltype == vehicledatalist[i].type) {
                selectedvehicletypeid = vehicledatalist[i].id;
                break;
              }
            }

            /// NOW HERE WE REGISTER USER AND HIS COMPLETE DATA
            await Firestore.instance.collection("driver").add({
              'aadhar_back': str_aadharback,
              'aadhar_front': str_aadharfront,
              'aadhar_number': str_aadharfront,
              'bank_ac_name': '',
              'bank_ac_number': '',
              'bank_ifsc': '',
              'bank_name': '',
              'dl_back': str_dlbackcopy,
              'dl_front': str_dlfrontcopy,
              'driver_lat': '00.0000',
              'driver_lng': '00.000',
              'driver_status': 'pending',
              'driving_license_number': str_dlfrontcopy,
              'insurance_first': str_insurancefirst,
              'insurance_second': str_insurancesecond,
              'insurance_third': str_insurancethird,
              'pan_file': str_pancardcopy,
              'pan_number': str_pancardcopy,
              'police_verification_file': str_policiverificationcopy,
              'police_verification_status': "pending",
              'rc_back': str_rccopyback,
              'rc_front': str_rccopyfront,
              'rto_back': str_rtodertificateback,
              'rto_front': str_rtocertificatecopyfront,
              'user_id': sharedPreferences.getString("USERID"),
              'vehicle_back': str_vehiclephotoback,
              'vehicle_front': str_vehiclephotofrontcopy,
              'vehicle_number': vehiclenumber,
              'vehicle_type': selectedvehiceltype,
              'vehicle_type_id': selectedvehicletypeid,
              'registration_payment_status': 'pending',
              'driver_registration_amount': "",
              'driver_name': sharedPreferences.getString("USERNAME"),
              'new_bookingrequest_id': '',
              'reviews': '0.0',
              'vehicle_detail': 'About Vehicle',
              'driver_mobile': sharedPreferences.getString('MOBILE'),
              'driver_image': sharedPreferences.getString('IMAGE')
            }).then((documentReference) {
              print(documentReference.documentID);
              Firestore.instance.collection('wallet').add(
                  {'amount': '0.00', 'total_earning': '0.00',
                    'amount_type': '',
                    'balance': '0.00','total_withdrawal':"0.00",
                    'booking_id': '', 'mytranscation': [],
                    'driver_id': documentReference.documentID.toString(),
                    'amount_type': '',}).then((data) {
                Firestore.instance.collection('users')
                    .document(sharedPreferences.getString('USERID')).updateData({
                  'role': 'driver',
                  'driver_id': documentReference.documentID.toString(),
                  'driver_wallet_id': data.documentID.toString(),
                }).then((data) async {
                  // sharedPreferences.setString('ROLE', 'driver');
                  sharedPreferences.setString(
                      "DRIVERID", documentReference.documentID.toString());
                  progressDialog.dismiss();
                  Redircetforpaymenttodriverregisterfees();
                });
              });


              /// SAVE VALUES TO SHAREDPREFRENCES


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
            progressDialog.dismiss();
            Redircetforpaymenttodriverregisterfees();


          }}
        catch(e){
          progressDialog.hide();

          showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message: "Sorry there seems to be network server error please try again later",),
          );
        }



        /* if (status == '200') {
          Redircetforpaymenttodriverregisterfees();
        }
        else {
          Redircetforpaymenttodriverregisterfees();

          showDialog(barrierDismissible: false,
              context: context,
              builder: (_) => GeneralMessageDialogBox(Message:models.message,
              ));
        }*/
      }
    }catch(e){
      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message:"Sorry There Seems to be a network ServerError. Please Try again Later.",
          ));
    }

  }

  Future<void> Redircetforpaymenttodriverregisterfees() async {
    progressDialog.dismiss();
    sharedprefrences = await SharedPreferences.getInstance();
    var _razorpay = Razorpay();
    var _razorpays = Razorpay();
    var options = {
      'key': Constants.PAYMENTGATEWAYKEY,
      //'key': 'rzp_live_qdUReWKfy2SE4Y',
      'amount': 80000, //in thuserImage(File _image) asynce smallest currency sub-unit.
      'name': 'NBER',
      'description': 'Driver registration fee',
      'prefill': {
        'contact': sharedprefrences.getString('MOBILE'),
        'email': sharedprefrences.getString('USEREMAIL')
      }
    };
    try {
      _razorpays.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      _razorpay.open(options);
    }
    catch(e){
      print(e);
    }
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    try {
      Toast.show(
          "Payment SuccessFully Done. Please Login again to continue.", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      Firestore.instance.collection('driver')
          .document(sharedprefrences.getString('DRIVERID')).updateData({
        'driver_registration_amount': '800',
        'registration_payment_status': 'Complete'
      }).then((data) async {
        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) =>
                GeneralMessageDialogBox(
                  Message: "Payment SuccessFully Done. Please Login again to continue.",
                ));
        sharedprefrences.setBool("LOGIN", false);
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (ctxt) => new Login()));
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

  _setvaluetolist(Map<String,dynamic > data, String documentID) {
    try {
      progressDialog.hide();

      String gender=sharedprefrences.getString("GENDER");
      if(gender=="Male"||gender=="male"){
        if(data['type']=="scooty"){
          //// IF TYPE IS SCOOTY THEN DONT ADD SCOOTY VEHICLE TO MALE DRIVER
        }
        else{
          VehicleTypeData datas = new VehicleTypeData();
          //datas.id = data['vehicle_type_id'].toString();
          datas.id = documentID.toString();
          datas.type=data['type'].toString();
          // datas.type=data['type'].toString();

          vehicledatalist.add(datas);


          _locations.add(data['type'].toString());
          //vehicle_type_id.add(data['vehicle_type_id'].toString());
          setState(() {
            showdata = true;
          });
        }
      }
      else{
        VehicleTypeData datas = new VehicleTypeData();
        //datas.id = data['vehicle_type_id'].toString();
        datas.id = documentID.toString();
        datas.type=data['type'].toString();
        // datas.type=data['type'].toString();

        vehicledatalist.add(datas);


        _locations.add(data['type'].toString());
        //vehicle_type_id.add(data['vehicle_type_id'].toString());
        setState(() {
          showdata = true;
        });
      }

      /*if (vehicletypemodel.notificationdata.length > 0) {


      for (int i = 0; i < vehicletypemodel.notificationdata.length; i++) {
        String jj = vehicletypemodel.notificationdata[i].type;

        _locations.add(jj);
      }
      int jj = _locations.length;
      setState(() {
        showdata=!showdata;
      });

    }
    else{
      progressDialog.hide();
      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message:"Sorry There is No any Vehicle Model availalbe for you can book your Vehicle.",
          ));
    }
*/
    }catch(e){
      print(e);
    }
  }

  Future<void> _uploadimageinstancetofirebase(File image, String str_dlfrontcopyss) async {
    try {
      String imageulrfilename;
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      var date = new DateTime.now().millisecondsSinceEpoch;

      StorageReference ref =
      FirebaseStorage.instance.ref().child(
          sharedPreferences.getString("USERID") + "_driverdocument_").child(
          sharedPreferences.getString("USERID") + "_" + date.toString() +
              str_dlfrontcopyss + ".jpg");
      StorageUploadTask uploadTask = ref.putFile(image);
      final StorageTaskSnapshot downloadUrl =
      (await uploadTask.onComplete);
      imageulrfilename = (await downloadUrl.ref.getDownloadURL());
      if (dlfrontcopy == true) {
        dlfrontcopy = false;
        setState(() {
          str_dlfrontcopy = imageulrfilename;
        });

        print(str_dlfrontcopy);
      }
      if (dlbackcopy == true) {
        dlbackcopy = false;
        setState(() {
          str_dlbackcopy = imageulrfilename;
        });

      }
      if (pancardcopy == true) {
        pancardcopy = false;
        setState(() {
          str_pancardcopy = imageulrfilename;
        });

      }

      if (rtocertificatecopyfront == true) {
        rtocertificatecopyfront = false;
        setState(() {
          str_rtocertificatecopyfront = imageulrfilename;
        });

      }

      if (rtodertificateback == true) {
        rtodertificateback = false;
        setState(() {
          str_rtodertificateback = imageulrfilename;
        });

      }

      if (insurancefirst == true) {
        insurancefirst = false;
        setState(() {
          str_insurancefirst = imageulrfilename;
        });

      }

      if (insurancesecond == true) {
        insurancesecond = false;
        setState(() {
          str_insurancesecond = imageulrfilename;
        });

      }

      if (insurancethird == true) {
        insurancethird = false;
        setState(() {
          str_insurancethird = imageulrfilename;
        });

      }

      if (aadharfront == true) {
        aadharfront = false;
        setState(() {
          str_aadharfront = imageulrfilename;
        });

      }

      if (aadharback == true) {
        aadharback = false;
        setState(() {
          str_aadharback = imageulrfilename;
        });

      }

      if (policiverificationcopy == true) {
        policiverificationcopy = false;
        setState(() {
          str_policiverificationcopy = imageulrfilename;
        });

      }

      if (vehiclephotofrontcopy == true) {
        vehiclephotofrontcopy = false;
        setState(() {
          str_vehiclephotofrontcopy = imageulrfilename;
        });

      }

      if (vehiclephotoback == true) {
        vehiclephotoback = false;
        setState(() {
          str_vehiclephotoback = imageulrfilename;
        });

      }

      if (rccopyfront == true) {
        rccopyfront = false;
        setState(() {
          str_rccopyfront = imageulrfilename;
        });

      }

      if (rccopyback == true) {
        rccopyback = false;
        setState(() {
          str_rccopyback = imageulrfilename;
        });

      }
    }
    catch(e){
      print(e);
    }

  }
}