
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ImagePickerHandler.dart';
import '../MyColors.dart';
import '../RegisterApi.dart';
import '../RegisterModel.dart';
import '../Updateprofileapi.dart';
import '../UserInfoApi.dart';
import '../UserInfoModel.dart';
import '../appTheme.dart';
import 'package:nber_flutter/UserInfoModel.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';
class UpdateProfileFile extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpdateProfileFileState();
  }
}
class UpdateProfileFileState extends State<UpdateProfileFile> with TickerProviderStateMixin,ImagePickerListener {
  int _radioValue1;
  String _picked = "Two";
  int _groupValue = -1;
  UserInfoApi _userinfoapi;
  Updateprofileapi _registerapi;
  int selectedRadio;
  Future<File> imageFile;
  Userdatas userdata;
  ProgressDialog progressDialog;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  TextEditingController _firstname,_lastname,_useremail,_usermobile,_useraddress,_usercity,_userstate,_usercountry,_userpincode,_useremergencycontactname,_useremergencymobile,_useremergencyemail;
  File _image;
  bool loadpage=false;
SharedPreferences sharedprefrences;


  @override
  void initState() {
    // TODO: implement initState
    _userinfoapi= new UserInfoApi();
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
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedprefrences = sp;
      callapiforgetuserdetail();

      //Toast.show(sp.getString("USERNAME"), context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
      setState(() {});
    });

    super.initState();
    // PermissionHandler().checkPermissionStatus(PermissionGroup.camera,PermissionGroup.storage);
    _controller = new AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 500),
    );
    _registerapi=new Updateprofileapi();

    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();


    _firstname=new TextEditingController();
    _lastname= new TextEditingController();
    _useremail= new TextEditingController();
    _usermobile= new TextEditingController();
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
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(color: Colors.white,
        child:



        loadpage ?  Scaffold(
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
                              height: 160.0,
                              width: 160.0,
                              decoration: new BoxDecoration(
                                color: const Color(0xff7c94b6),
                                image: new DecorationImage(

                                  fit: BoxFit.cover,
                                ),
                                border:
                                Border.all(color: Colors.red, width: 5.0),
                                borderRadius:
                                new BorderRadius.all(const Radius.circular(80.0)),
                              ),
                              child:showimage()),
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

                          Expanded(flex: 10,child: TextFormField(controller:_usermobile,textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Mobile Number"
                          )),
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

                          Expanded(flex: 10,child: TextFormField(controller:_useremergencycontactname,textAlign: TextAlign.start,  keyboardType: TextInputType.text,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
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

                          Expanded(flex: 10,child: TextFormField(controller:_useremergencymobile,textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 14), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:00,top:0,right:10,bottom:0),hintText: "Enter Emergency Contact Number"
                          )),
                          ),

                        ]))


                  ],)
                  ///// EMERGENCY EMAILID
                  ,Column(children: <Widget>[
                    Align(alignment: Alignment.topLeft, child:new Container(margin: const EdgeInsets.only(top: 10),alignment: Alignment.topLeft,
                      child: Text('Emergency EmailID',style: TextStyle(
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

            ))
    ) : SizedBox()


);
    ;
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
    if(_firstname.text.toString()==null){
      Toast.show('Enter Firstname', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_lastname.text.toString()==null){
      Toast.show('Enter Lastname', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_useremail.text.toString()==null){
      Toast.show('Enter Email', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_usermobile.text.toString()==null){
      Toast.show('', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_useraddress.text.toString()==null){
      Toast.show('Etner Address', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_usercity.text.toString()==null){
      Toast.show('Enter City', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_userstate.text.toString()==null){
      Toast.show('Etner Country', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_usercountry.text.toString()==null){
      Toast.show('', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_userpincode.text.toString()==null){
      Toast.show('Enter Pincode', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_useremergencycontactname.text.toString()==null){
      Toast.show('Enter Emergency Name', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_useremergencymobile.text.toString()==null){
      Toast.show('Emter Emergency Contact No', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else if(_useremergencyemail.text.toString()==null){
      Toast.show('Enter Emergency Email', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
    else
    {
      var connectivityResult =  await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile) {
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

      else if (connectivityResult == ConnectivityResult.wifi) {
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
      else
      {
        Toast.show("Network Not Available. ", context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM);
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
    try {
      progressDialog.show();
      // String name= mobilenumbercontroller.text.toString();
      RegisterModel results = await _registerapi.search(
          firstname,
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
          useremergencyemail);

      String names = results.status;


      if (names == "200") {
        progressDialog.hide();
        Toast.show(results.message, context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM);
      }
      else {
        progressDialog.hide();
        Toast.show(results.message, context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM);
      }
    }catch(e){
      progressDialog.hide();
      String j=e.toString();
      Toast.show("Sorry there seems to be  a network server error. please try again leter.",context,duration:Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);

    }
  }

  @override
  userImage(File _image) async {
    setState(() {

      this.imageFile = _image as Future<File>;
      String jj = _image as String;
      Toast.show(
          jj, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);


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

  Future<void> callapiforgetuserdetail() async {
    try{
      progressDialog.show();
      UserInfoModel infomodelss = await _userinfoapi.search(sharedprefrences.getString("USERID"),"Bearer "+sharedprefrences.getString("TOKEN"));
      String status = infomodelss.status;
      if (status == "200") {
        userdata = infomodelss.datas;

    _firstname.text=userdata.name;

         _lastname.text=userdata.name;
         _useremail.text=userdata.email;
         _usermobile.text=userdata.mobile;
         _useraddress.text=userdata.address;
         _usercity.text=userdata.city;
         _userstate.text=userdata.state;
         _usercountry.text=userdata.country;
         _userpincode.text=userdata.pincode;
         _useremergencycontactname.text=userdata.emergencyContactName;
         _useremergencymobile.text=userdata.emergencyContactNumber;
         _useremergencyemail.text=userdata.emergencyContactEmail;;

        ////_firstname.value = new TextEditingController.fromValue(new TextEditingValue(text: userdata.name)).value;
        progressDialog.hide();
        setState(() =>
        loadpage =
        !loadpage);





      }
      else {
        progressDialog.hide();
        Toast.show(infomodelss.message,context,duration:Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);

      }
      progressDialog.hide();
    }catch(Exception,e){
      progressDialog.hide();
      String j=e.toString();
      Toast.show("Sorry there seems to be  a network server error. please try again leter.",context,duration:Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);

    }
  }
  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds:5000));
    return true;
  }
}