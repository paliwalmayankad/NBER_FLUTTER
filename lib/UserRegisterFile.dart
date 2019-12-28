


import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nber_flutter/DashBoardFile.dart';
import 'package:nber_flutter/DashBoardFile_Second.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CustomAlertDialogBoxextends.dart';
import 'GenralMessageDialogBox.dart';
import 'ImagePickerHandler.dart';
import 'RegisterApi.dart';
import 'RegisterModel.dart';
import 'Utils/Constants.dart';
import 'Utils/UtilsFile.dart';
import 'appTheme.dart';
import 'package:nber_flutter/appTheme.dart';
import 'MyColors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';





class UserRegisterFile extends StatefulWidget{
  final mobile;
  UserRegisterFile({Key key, this.mobile}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserRegisterFileState();
  }
}
class UserRegisterFileState extends State<UserRegisterFile> with TickerProviderStateMixin,ImagePickerListener {
  int _radioValue1;
  String _picked = "Two";

  RegisterApi _registerapi;
  int selectedRadio=1;
  int _groupValue = -1;
  Future<File> imageFile;
  ProgressDialog progressDialog;
  PermissionStatus _status;
  String Gender="Male";

  TextEditingController _firstname,_lastname,_useremail,_usermobile,_useraddress,_usercity,_userstate,_usercountry,_userpincode,_useremergencycontactname,_useremergencymobile,_useremergencyemail;
  File _image;
  String image_file="";
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Notification> notifications = [];
  SharedPreferences sharedprefrences;
String firebasetoken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((token){
      print("tokenfirebase "+token);
      firebasetoken=token;
    });
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
    // PermissionHandler().checkPermissionStatus(PermissionGroup.camera,PermissionGroup.storage);
    _controller = new AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 500),
    );


    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();

    _registerapi=new RegisterApi();
    _firstname=new TextEditingController();
    _lastname= new TextEditingController();
    _useremail= new TextEditingController();
    _usermobile= new TextEditingController();
    _usermobile.text=widget.mobile.toString();
    _useraddress= new TextEditingController();
    _usercity= new TextEditingController();
    _userstate= new TextEditingController();
    _usercountry= new TextEditingController();
    _userpincode= new TextEditingController();
    _useremergencycontactname= new TextEditingController();
    _useremergencymobile= new TextEditingController();
    _useremergencyemail= new TextEditingController();;

  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      if(val==1){
        Gender="Male";
      }
      else{
        Gender="Female";
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: AppTheme.white,
        body:



        SingleChildScrollView(scrollDirection: Axis.vertical,
            child:new Container( margin: const EdgeInsets.only(top:30,left: 10,bottom: 10,right: 10),


                child: new Column(children: <Widget>[

                  appBar(),

                  ////
                  Align(alignment: Alignment.topCenter,
                      child:  GestureDetector(
                        onTap: () => {imagePicker.showDialog(context),},
                        child: new Center(
                          child: _image == null
                              ? new Stack(
                            children: <Widget>[

                              new Center(
                                child: new CircleAvatar(
                                  radius: 80.0,
                                  backgroundColor: const Color(0xFF778899),
                                ),
                              ),
                              new Center(
                                //child: new Image.asset("images/yellow_logo.png"),
                              ),

                            ],
                          )
                              : new Container(
                              height: 120.0,
                              width: 120.0,
                              decoration: new BoxDecoration(
                                color: const Color(0xff7c94b6),

                                border:
                                Border.all(color: Colors.black, width: 1.0),
                                borderRadius:
                                new BorderRadius.all(const Radius.circular(80.0)),
                              ),
                              child:ClipRRect(
                                borderRadius: new BorderRadius.circular(80.0),
                                child: Image.file(_image,fit: BoxFit.cover,),)),
                        ),

                        /*Container(width: 100.0,alignment: Alignment.center,
                      height: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: new Image.asset('yellow_logo.png'),
                        ),

                        color: Colors.redAccent,
                      )
                  )*/
                      )
                  )
///// FIRST NAME



                  , Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(alignment: Alignment.topLeft,
                      child: Text('First Name',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_firstname,textAlign: TextAlign.start,  keyboardType: TextInputType.text,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter First Name"
                          )),
                          ),

                        ]))


                  ],),
                  //// LAST NAME
                  Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top:10),alignment: Alignment.topLeft,
                      child: Text('Last Name',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_lastname,textAlign: TextAlign.start,  keyboardType: TextInputType.text,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Last Name"
                          )),
                          ),

                        ]))


                  ],)





                  //// GENDER
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('Select Gender',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[
                          Radio(
                            value: 1,
                            groupValue: selectedRadio,
                            activeColor: Colors.black,

                            onChanged: (val) {
                              print("Radio $val");
                              setSelectedRadio(val);
                            },
                          ),Text('Male',style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,),),

                          Radio(
                            value: 2,

                            groupValue: selectedRadio,

                            activeColor: Colors.black,
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectedRadio(val);
                            },
                          ),Text('Female',style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,),),

                        ]))


                  ],)
                  ////// EMAIL
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(alignment: Alignment.topLeft,margin: const EdgeInsets.only(top: 10),
                      child: Text('Email',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_useremail,textAlign: TextAlign.start,  keyboardType: TextInputType.emailAddress,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Your Email"
                          )),
                          ),

                        ]))


                  ],)
                  ////// MOBILE
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('Mobile',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,
                            child: TextFormField(controller:_usermobile,
                              textAlign: TextAlign.start,
                              enabled: false,
                              keyboardType: TextInputType.phone,
                              obscureText: false,
                              style: TextStyle(color: Colors.black,fontSize: 14),

                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Mobile',
                              ),
                            ),
                          ),

                        ]))


                  ],)
                  ///// ADDRESS
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('Address',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_useraddress,textAlign: TextAlign.start,  keyboardType: TextInputType.text,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Address"
                          )),
                          ),

                        ]))


                  ],)
                  ///// CITY
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('City',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_usercity,textAlign: TextAlign.start,  keyboardType: TextInputType.text,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter City"
                          )),
                          ),

                        ]))


                  ],)
                  ////// STATE
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('State',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_userstate,textAlign: TextAlign.start,  keyboardType: TextInputType.text,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter State"
                          )),
                          ),

                        ]))


                  ],)
                  ///// COUNTRY
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('Country',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_usercountry,textAlign: TextAlign.start,  keyboardType: TextInputType.text,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Country"
                          )),
                          ),

                        ]))


                  ],)
                  ///// PINCODE
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('Pincode',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_userpincode,textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Pincide"
                          )),
                          ),

                        ]))


                  ],)
                  //// EMERGENCYCONTACT NAME
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('Emergency Contact Name',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_useremergencycontactname,

                              textAlign: TextAlign.start,  keyboardType: TextInputType.text,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Emergency Contact Name"
                          )),
                          ),

                        ]))


                  ],)
                  //// EMERGENCY CONTACT NO
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('Emergency Cotanct No',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_useremergencymobile,
                              inputFormatters: [LengthLimitingTextInputFormatter(
                                  10),
                              ],
                              textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Emergency Contact Number"
                          )),
                          ),

                        ]))


                  ],)
                  ///// EMERGENCY EMAILID
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('Emergency Email',style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),


                      ),),),
                    Container(   margin: const EdgeInsets.only(left: 0,right: 10),alignment: Alignment.center,padding: const EdgeInsets.only(top:5,bottom: 4),
                        decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.black,
                          width: 1.0,)),),



                        child:new  Row(children: <Widget>[

                          Expanded(flex: 10,child: TextFormField(controller:_useremergencyemail,textAlign: TextAlign.start,  keyboardType: TextInputType.emailAddress,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Emergency Email"
                          )),
                          ),

                        ]))


                  ],),
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
                            _callvalidation();
                            //////




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
                  //// MACID
                  //// TOKENNID
                  //// LAT
                  /// LONG
                  ///


                ])

            )));
  }
  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
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

  void _callvalidation() async
  {
    String firstname=_firstname.text.toString();
    String lastname=_lastname.text.toString();
    String useremail=_useremail.text.toString();
    String usermobile=_usermobile.text.toString();
    String useraddress=_useraddress.text.toString();
    String usercity=_usercity.text.toString();
    String userstate=_userstate.text.toString();
    String usercountry=_usercountry.text.toString();
    String userpincode=_userpincode.text.toString();
    String useremergencycontactname=_useremergencycontactname.text.toString();
    String useremergencymobile=_useremergencymobile.text.toString();
    String useremergencyemail=_useremergencyemail.text.toString();

/////

/////





    if(_image==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Slect User Image Profle",),
      );
    }

    else if(firstname.length==0||firstname.isEmpty||firstname==" "||firstname.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Firstname",),
      );
    }
    else if(lastname.length==0||lastname.isEmpty||lastname==" "||lastname.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Lastname",),
      );
    }
    else if(useremail.length==0||useremail.isEmpty||useremail==" "||useremail.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Email",),
      );
    }
    else if(isEmail(useremail)==false){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter correct email",),
      );
    }
    else if(usermobile.length==0||usermobile.isEmpty||usermobile==" "||usermobile.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Mobile",),
      );
    }
    else if(usermobile.length<10){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Correct Mobile",),
      );
    }
    else if(useraddress.length==0||useraddress.isEmpty||useraddress==" "||useraddress.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Address",),
      );
    }
    else if(usercity.length==0||usercity.isEmpty||usercity==" "||usercity.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter City",),
      );
    }
    else if(userstate.length==0||userstate.isEmpty||userstate==" "||userstate.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Etner State",),
      );
    }
    else if(usercountry.length==0||usercountry.isEmpty||usercountry==" "||usercountry.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Country",),
      );
    }
    else if(userpincode.length==0||userpincode.isEmpty||userpincode==" "||userpincode.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Pincode",),
      );
    }
    else if(useremergencycontactname.length==0||useremergencycontactname.isEmpty||useremergencycontactname==" "||useremergencycontactname.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Emergency Person Name",),
      );
    }
    else if(useremergencymobile.length==0||useremergencymobile.isEmpty||useremergencymobile==" "||useremergencymobile.toString()==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Emergency Contact No",),
      );
    }
    else if (useremergencymobile.length < 10) {
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) =>
            GeneralMessageDialogBox(Message: "Enter correct emergency contact number",),
      );
    }
    else if(useremergencyemail.length==0||useremergencyemail.isEmpty||useremergencyemail==" "||useremergencyemail==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please Enter Emergency Email",),
      );

    }
    else if(isEmail(useremergencyemail)==false){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Please enter correct emergency email",),
      );

    }
    else
    {

      if (true == await UtilsFile.checkNetworkStatus(context)) {
        _callfinalapi(  firstname,
            lastname,
            useremail,
            usermobile,
            useraddress,
            usercity,
            userstate,
            usercountry,
            userpincode,
            useremergencycontactname,
            useremergencymobile,
            useremergencyemail
        );
      }
      else {
        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) =>
              CustomAlertDialogBoxextends(
                Message: Constants.networknotavailalbe,),
        );
      }




    }





  }

  Future<void> _callfinalapi( String  firstname,
      String lastname,
      String  useremail,
      String  usermobile,
      String  useraddress,
      String usercity,
      String  userstate,
      String  usercountry,
      String  userpincode,
      String  useremergencycontactname,
      String  useremergencymobile,
      String  useremergencyemail
      )  async{
    // progressDialog.show();
    // String name= mobilenumbercontroller.text.toString();
    try {
      progressDialog.show();
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      StorageReference ref =
      FirebaseStorage.instance.ref().child(_usermobile.text.toString()).child(_usermobile.text.toString()+"_profileimage.jpg");
      StorageUploadTask uploadTask = ref.putFile(_image);
      final StorageTaskSnapshot downloadUrl =
      (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());

     /* final String url = (await uploadTask.ref.getDownloadURL());
      return await (await uploadTask.onComplete).ref.getDownloadURL();*/

     /// NOW HERE WE REGISTER USER AND HIS COMPLETE DATA
      await Firestore.instance.collection("users").add({
        'address': useraddress,
        'city': usercity,
        'country': usercountry,
        'email': useremail,
        'emergency_contact_email': useremergencyemail,
        'emergency_contact_name': useremergencycontactname,
        'emergency_contact_number': useremergencymobile,
        'gender': Gender,
        'image': url,
        'lat': '00.0000',
        'lng': '00.000',
        'mac_id': '',
        'mobile': usermobile,
        'name': firstname+" "+lastname,
        'pincode': userpincode,
        'role': 'user',
        'state': userstate,
        'status': 'free',
        'token_id': firebasetoken,
        'driver_id':"",
        'driver_wallet_id':'',
        'mybookinglist':'','first_name':firstname,"last_name":lastname



      }).then((documentReference) {
        print(documentReference.documentID);
       /// SAVE VALUES TO SHAREDPREFRENCES

        sharedPreferences.setBool("LOGIN", true);
        sharedPreferences.setString("USERNAME", firstname+" "+lastname);
        //sharedPreferences.setString("TOKEN", results.data.token);
        sharedPreferences.setString("USERID", documentReference.documentID.toString());
        sharedPreferences.setString("IMAGE", url);
        sharedPreferences.setString("ROLE", 'user');
        sharedPreferences.setString("MOBILE", usermobile);

        sharedPreferences.commit();
        progressDialog.hide();
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new DashBoardFile_Second()),
        );


      }).catchError((e) {
        progressDialog.hide();

        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message: "Sorry there seems to be network server error please try again later",),
        );
      });









    }
    catch(e){
      progressDialog.hide();

      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Sorry there seems to be network server error please try again later",),
      );
    }
  }

  @override
  userImage(File _image) async {
    setState(() {
      this._image = _image;
      //this.imageFile = _image as Future<File>;
      /*   final _imageFile = ImageProcess.decodeImage(_image.readAsBytesSync(),);
        var base64Image = base64Encode(ImageProcess.encodePng(_imageFile));
      image_file=base64Image;*/
      /*List<int> imageBytes = _image.readAsBytesSync();
     // var base64Image = base64Encode(imageBytes);
      String base64Encode(List<int> bytes) => base64.encode(_image.readAsBytesSync());

      print(base64Encode);*/

      var params = {
        "image_file": base64Encode(_image.readAsBytesSync()),
      };
      print("http.upload >> " +params.toString());;







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
            '',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }


  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

}