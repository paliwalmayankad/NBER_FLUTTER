import 'dart:io';

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
  Future<File> imageFile;
  ProgressDialog progressDialog;
  String selectedvehiceltype;
  String selectedvehicletypeid;
  bool  showdata = false;
  VehicleTypeModel vehicletypemodel;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  SharedPreferences sharedprefrences;
  UploadDriverDocumentApi _uploaddriverdocumentapi;
  File _image;
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

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return

              Container(
                  color: FintnessAppTheme.background,
                  child:
                  showdata ? Scaffold(
                      backgroundColor: AppTheme.white,
                      body:


                      SingleChildScrollView(scrollDirection: Axis.vertical,
                          child: new Container(margin: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10, right: 10),


                            child: new Column(children: <Widget>[

                              appBar(),
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
                                        Text(
                                            'Upload Driving Licence Front Copy',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            )),

                                      Align(
                                        alignment: Alignment.center,child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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

                                        Expanded(child: Image.asset(
                                          'images/next.png', height: 25,
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
                  ): SizedBox()
              );


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
    try {
      progressDialog.show();
      sharedprefrences = await SharedPreferences.getInstance();
      String token="Bearer "+sharedprefrences.getString("TOKEN");
       vehicletypemodel = await _callapiforvehicle.search(token);
      String status = vehicletypemodel.status;
      String message = vehicletypemodel.message;

      if (status == "200") {
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
      }
    }catch(e){
      progressDialog.hide();
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



      String base64Image = base64Encode(ImageProcess.encodePng(_imageFile));
      String jj=base64Image;
      print("IMAGEIN BASDE"+jj);
      ////
     if( dlfrontcopy==true){
       dlfrontcopy=false;
       str_dlfrontcopy=base64Image;
     }
      if( dlbackcopy==true){
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
    try {
      String vehiclenumber = vehiclenumbercontroller.text.toString();
     if(selectedvehiceltype==null|| selectedvehiceltype.isEmpty||selectedvehiceltype==""){

      for(int i=0;i<vehicletypemodel.notificationdata.length;i++){
        if(vehicletypemodel.notificationdata[i].type==selectedvehiceltype){
          selectedvehicletypeid=vehicletypemodel.notificationdata[i].id;
          break;
        }
      }

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
        String mobile = sharedprefrences.getString("MOBILE");
        String Token = "Bearer " + sharedprefrences.getString("TOKEN");


        CommonModels models = await _uploaddriverdocumentapi.search(
            mobile,
            Token,
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
        String status = models.status;


        if (status == '200') {
          Redircetforpaymenttodriverregisterfees();
        }
        else {
          Redircetforpaymenttodriverregisterfees();

          showDialog(barrierDismissible: false,
              context: context,
              builder: (_) => GeneralMessageDialogBox(Message:models.message,
              ));
        }
      }
    }catch(e){
      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message:"Sorry There Seems to be a network ServerError. Please Try again Later.",
          ));
    }

  }

  Future<void> Redircetforpaymenttodriverregisterfees() async {
    sharedprefrences = await SharedPreferences.getInstance();
   var _razorpay = Razorpay();
   var _razorpays = Razorpay();
   var options = {
     'key': 'rzp_live_qdUReWKfy2SE4Y',
     'amount': 80000, //in thuserImage(File _image) asynce smallest currency sub-unit.
     'name': 'Acme Corp.',
     'description': 'Fine T-Shirt',
     'prefill': {
       'contact': '9123456789',
       'email': 'gaurav.kumar@example.com'
     }
   };
   _razorpays.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);_razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);_razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
   _razorpay.open(options);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
   // Toast.show("Payment SuccessFully Done. Please Login again to continue.", context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message:"Payment SuccessFully Done. Please Login again to continue.",
        ));
    sharedprefrences.setBool("LOGIN", false);
    Navigator.pushReplacement(context, new MaterialPageRoute(builder:  (ctxt) => new Login()));

  }
  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message:"Payment Fail. PLease Make payment to continue as a driver",
        ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("ExternalWalletResponse"+response.toString());
    // Do something when an external wallet is selected
  }
}