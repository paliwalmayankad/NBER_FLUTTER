
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nber_flutter/DashBoardFile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';
import 'CustomAlertDialogBoxextends.dart';
import 'DashBoardFile_Second.dart';
import 'GenralMessageDialogBox.dart';
import 'LoginApi.dart';
import 'LoginModel.dart';
import 'package:toast/toast.dart';
import 'MyColors.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'UserRegisterFile.dart';
import 'Utils/Constants.dart';
class VerificationFile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  VerificationState();
  }
}
class VerificationState extends State<VerificationFile> {
  TextEditingController mobilenumbercontroller;
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  LoginApi _guestUserApi;
  ProgressDialog progressDialog;
SharedPreferences sharedPreferences;
  var databaseReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobilenumbercontroller = new TextEditingController();
    databaseReference = Firestore.instance;
    _guestUserApi = new LoginApi();

    progressDialog = new ProgressDialog(
        context, type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: false);
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
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(child: Stack(
          children: <Widget>[

            new Column(
              children: <Widget>[

                Container(
                    margin: const EdgeInsets.only(
                        top: 40, left: 10, bottom: 10, right: 10),

                    child: Align(alignment: Alignment.topLeft,
                        child: InkWell(
                          child: Image.asset(
                            'images/back arrow.png', height: 20, width: 20,),
                          onTap: () {
                            // Toast.show('Back',context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                          },


                        )))

                ,


                new Container(margin: const EdgeInsets.only(left: 10),
                    child: Align(alignment: Alignment.topLeft,
                      child: Text("Enter phone number for verification",
                        style: TextStyle(color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),),
                    )

                ),
                new Container(
                  margin: const EdgeInsets.only(left: 10, top: 15),

                  child: Align(alignment: Alignment.topLeft,
                    child: Text(
                      "This number will be used to contact you and communicate all ride related details.",
                      style: TextStyle(color: Colors.black87, fontSize: 9),),

                  ),


                ),
                //////  THIS CONTAINER FOR NUMBER
                Padding(padding: EdgeInsets.only(top: 20.0)),
                ////// FOR PASSWORD

                new Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: new BoxDecoration(color: MyColors.white,
                      border: Border(bottom: BorderSide(color: Colors.black,
                        width: 1.0,)),),


                    child: new Row(children: <Widget>[
                      Expanded(flex: 1,
                        child: Image.asset(
                          'images/india flag_logo.png', width: 20,
                          height: 20,),),

                      Expanded(flex: 1, child:
                      Text('+91', textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(flex: 10,
                        child: TextFormField(controller: mobilenumbercontroller,
                            inputFormatters: [LengthLimitingTextInputFormatter(
                                10),
                            ],
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.phone,
                            obscureText: false,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            decoration: new InputDecoration(fillColor: Colors
                                .white,
                                filled: true,
                                border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(
                                        20.00),
                                    borderSide: new BorderSide(
                                        color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20.00)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.0),),
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 0, right: 10, bottom: 0),
                                hintText: "Enter Mobile"
                            )),
                      ),
                      Expanded(flex: 1,
                        child: Image.asset(
                          'images/close.png', width: 15, height: 15,),),

                    ]))


              ],

            )
            , Align(alignment: Alignment.bottomCenter,
              child: new Container(


                margin: const EdgeInsets.only(left: 55, right: 55, top: 15),
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
                      _callvalidation();
                      //callapiforlogin_sec();
                      // _callvalidation();
                      //////
                      /* Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(builder: (ctxt) => new DashBoardFile()),
                      );*/
                      /*Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(builder: (ctxt) => new UserRegisterFile()),
                      );*/


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


          ],


        )
        ));
  }


  void _callvalidation() async {
    String mobilenumber = mobilenumbercontroller.text.toString();
    if (mobilenumber.length == 0 || mobilenumber.isEmpty ||
        mobilenumber == " " || mobilenumber == null) {
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) =>
            GeneralMessageDialogBox(Message: "Enter Mobile Number",),
      );
    }
    else if (mobilenumber.length < 10) {
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) =>
            GeneralMessageDialogBox(Message: "Enter Correct Mobile Number",),
      );
    }
    else {
      var connectivityResult = await Connectivity().checkConnectivity();
      phoneNo = "+91" + mobilenumber;
      if (connectivityResult == ConnectivityResult.mobile) {
        callapiforlogin_sec();
      }

      else if (connectivityResult == ConnectivityResult.wifi) {
        callapiforlogin_sec();
      }
      else {
        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(
            Message: "Network Not Available. PLease check your Network Connectivity.",),
        );
      }
    }
  }

////// THIS METHOD FOR CHECK MOBILE NO ATHENTICATION AND REDIRECT TO HOME NO
  Future<void> _CallFireBaseandCHeckUserAuthenticatiobn() async
  {
    /*final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {

      });
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
          smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential.toString());
            bool verify=false;
            //////////// _callapiforlogin();









          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
            Toast.show('${exceptio.message}', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
          });
    } catch (e) {
      handleError(e);
    }*/

    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context,phoneNo).then((value) {
        print("Signed in");
      });
    };


    final PhoneVerificationCompleted verificationCompleted = (
        AuthCredential credential) {
      print("verified");
      _callapiforlogin();
    };

    final PhoneVerificationFailed verfifailed = (AuthException exception) {
      print("${exception.message}");
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieval,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verificationCompleted,
        verificationFailed: verfifailed
    );
  }

/*  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,

        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            backgroundColor: MyColors.white,
            title: new Container(
              decoration: BoxDecoration(color: MyColors.white),
              child: Text('Enter Verification Code'),),
            content: Container(
              height: 100,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      _callapiforlogin();
                      //Toast.show('Login successfully', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                    }
                    else {
                      signIn(context);
                    }
                  });
                },
              )
            ],
          );
        });
  }*/






  _callapiforlogin() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      callapiforlogin_sec();
    }
    else if (connectivityResult == ConnectivityResult.wifi) {
      callapiforlogin_sec();
    }
    else {
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(
          Message: "Network Not Available. PLease check your Network Connectivity.",),
      );
    }
  }

  Future<void> callapiforlogin_sec() async {
    // ignore: new_with_undefined_constructor_default
    //LoginModel results = new LoginModel();
    try {
      progressDialog.show();
      String name = mobilenumbercontroller.text.toString();
      _checkaboutuserisalredyloginornotfromfirebase(phoneNo);


      /*LoginModel results = await _guestUserApi.search(name);


      if (results.status == '200') {
        if (results.data != null && results.data.length > 0) {
          SharedPreferences sharedPreferences = await SharedPreferences
              .getInstance();
          sharedPreferences.setBool("LOGIN", true);
          sharedPreferences.setString("USERNAME", results.data[0].name);
          sharedPreferences.setString("TOKEN", results.token);
          sharedPreferences.setString("USERID", results.data[0].id);
          sharedPreferences.setString("IMAGE", results.data[0].img);
          sharedPreferences.setString("ROLE", results.data[0].role);
          sharedPreferences.setString("MOBILE", results.data[0].mobile);
          sharedPreferences.setString("GENDER", results.data[0].gender);

          sharedPreferences.commit();


          //  Navigator.pushReplacement(context, new MaterialPageRoute(builder:  (ctxt) => new HomeFile()));
          Toast.show('Wel Come ' + results.data[0].name, context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM);
          progressDialog.hide();
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (ctxt) => new DashBoardFile_Second()),
          );
        }
        else {
          progressDialog.hide();
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (ctxt) => new UserRegisterFile()),
          );
        }
      }
      else {
        progressDialog.hide();

        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message: results.message,),
        );
      }*/
    }
    catch (e) {
      progressDialog.hide();
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(
          Message: "Sorry there seems to be a network Server Error. please try again leter ",),
      );
    }
  }

  Future<void> _checkaboutuserisalredyloginornotfromfirebase(
      String name) async {
    try {
      /////
     /* Firestore.instance
          .collection('users').where('mobile', isEqualTo: name)
          .snapshots()
          .listen((data) =>

          data.documents.forEach((doc) => print(doc["name"])));*/
      var querySnapshot = await Firestore.instance
          .collection('users').where('mobile', isEqualTo: name).getDocuments();
      progressDialog.hide();
      if (querySnapshot.documents.length>0) {
        SharedPreferences sharedPreferences = await SharedPreferences
            .getInstance();

        sharedPreferences.setString(
            "USERNAME", querySnapshot.documents[0].data['name'].toString());
        sharedPreferences.setString("DRIVERWALLETID", querySnapshot.documents[0].data['driver_wallet_id'].toString());
        sharedPreferences.setString(
            "TOKEN", querySnapshot.documents[0].data['token_id'].toString());
        sharedPreferences.setString(
            "USERID", querySnapshot.documents[0].documentID.toString());
        sharedPreferences.setString(
            "IMAGE", querySnapshot.documents[0].data['image'].toString());
        sharedPreferences.setString(
            "ROLE", querySnapshot.documents[0].data['role'].toString());
        sharedPreferences.setString(
            "MOBILE", querySnapshot.documents[0].data['mobile'].toString());
        sharedPreferences.setString(
            "GENDER", querySnapshot.documents[0].data['gender'].toString());
        sharedPreferences.setString("DRIVERID",
            querySnapshot.documents[0].data['driver_id'].toString());
        sharedPreferences.setString("USEREMAIL",
            querySnapshot.documents[0].data['email'].toString());
        sharedPreferences.commit();
        progressDialog.hide();
        if (sharedPreferences.getString('ROLE') == 'user') {
          sharedPreferences.setBool("LOGIN", true);
          Toast.show(
              'Wel Come ' + querySnapshot.documents[0].data['name'].toString(),
              context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM);

          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (ctxt) => new DashBoardFile_Second()),
          );
        }
        else
        {
          _checkfordriverpaymentorapprovestatus();




        }
      }
      else {
        OTPVERIFICATIONFORNUBERANDREGISTER(name);
      }
      /*databaseReference
          .collection("users").document().get
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) => print('${f.data}}'));
      });*/
      /////
    }
    catch (e) {
      progressDialog.hide();
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(
          Message: "Sorry there seems to be a network Server Error. please try again leter ",),
      );
    }
  }

  Future<void> OTPVERIFICATIONFORNUBERANDREGISTER(String name) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context,phoneNo).then((value) {
        print("Signed in");
      });
    };


    final PhoneVerificationCompleted verificationCompleted = (
        AuthCredential credential) {
      print("verified");
      _callapiforuserregister(context, phoneNo, "");
    };

    final PhoneVerificationFailed verfifailed = (AuthException exception) {
      print("jjj${exception.message}");
      if (exception.code == 'invalidCredential') {
        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) =>
              CustomAlertDialogBoxextends(
                Message: "Please enter correct mobile number to continue login process",),
        );
      }
      else if(exception.code=="quotaExceeded"){
        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) =>
              CustomAlertDialogBoxextends(
                Message: "Sorry currently not able to access your phone number. please try again later.",),
        );
      }
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        codeAutoRetrievalTimeout: autoRetrieval,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verificationCompleted,
        verificationFailed: verfifailed
    );
  }

  Future<bool> smsOTPDialog(BuildContext context, String mobileno) {
    return showDialog(
        context: context,

        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            backgroundColor: MyColors.white,
            title: new Container(
              decoration: BoxDecoration(color: MyColors.white),
              child: Text('Enter Verification Code'),),
            content: Container(
              height: 100,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    signIn(context, mobileno);
                    /*  if (user != null) {
                      signIn();
                    }*/
                    /* setState(() {
                        Navigator.of(context).pop();
                        *//* Route route = MaterialPageRoute(
                                          builder: (context) => LoginScreen());*//*
                        //Navigator.pushReplacement(context, route);
                      });
                      _callapiforuserregister(context, mobileno,user.uid);
                      //Toast.show('Login successfully', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                    }
                    else {
                      signIn(context, mobileno);
                    }*/
                  });
                },
              )
            ],
          );
        });
  }

  signIn(BuildContext context, String mobileno) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      await _auth.signInWithCredential(credential).then((user) {
        Navigator.of(context).pop();
        _callapiforuserregister(context, mobileno,user.user.uid);
        print('signed in with phone number successful: user -> $user');
      });
      /*final FirebaseUser user = (await _auth.signInWithCredential(credential)) as FirebaseUser;
      //if(user.uid==_auth.verifyPhoneNumber(phoneNumber: null, timeout: null, verificationCompleted: null, verificationFailed: null, codeSent: null, codeAutoRetrievalTimeout: null))
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      _callapiforlogin();*/
    }
    catch (e)
    {
      handleError(e,mobileno);
    }
  }

  handleError(PlatformException error,String mobileno) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
          Navigator.of(context).pop();
        });
        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) =>
              CustomAlertDialogBoxextends(Message: "Provided code is incorrect. please provide correct code.",),
        );
        errorMessage='';

        /*smsOTPDialog(context, "+91"+mobileno).then((value) {

        });*/
        break;
      case 'ERROR_SESSION_EXPIRED':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
          Navigator.of(context).pop();
        });
        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) =>
              CustomAlertDialogBoxextends(Message: "Session Has Expired Please try again.",),
        );
        //errorMessage='';

        /*smsOTPDialog(context, "+91"+mobileno).then((value) {

        });*/
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  void _callapiforuserregister(BuildContext context, String mobileno, String uid) {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (ctxt) => new UserRegisterFile(mobile:mobileno)),
    );
    //Toast.show('REGISTRATION PROCESS CALLED', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
  }

  Future<void> _checkfordriverpaymentorapprovestatus() async{
      sharedPreferences=await SharedPreferences.getInstance();
    var querySnapshotfordriver = await Firestore.instance
        .collection('driver').document(sharedPreferences.getString("DRIVERID")).get();

    String payment_status=querySnapshotfordriver.data['registration_payment_status'];
    String driver_status=querySnapshotfordriver.data['driver_status'];
    if(payment_status=='pending')
    {
_callpaymentmethodfordriverregister();
    }
    else if(driver_status=='pending'){
      //progressDialog.dismiss();
_createdialogforverficationpending();
    }
    else{
      try{
      //progressDialog.dismiss();
      sharedPreferences.setBool("LOGIN", true);
      Toast.show(
          'Wel Come ' +sharedPreferences.getString("USERNAME"),
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);

      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (ctxt) => new DashBoardFile_Second()),
      );
    }
    catch(e){
    print(e);
    }
    }

  }

  void _callpaymentmethodfordriverregister( ) {

    var _razorpay = Razorpay();
    var _razorpays = Razorpay();
    var options = {
      'key': Constants.PAYMENTGATEWAYKEY,
      //'key': 'rzp_live_qdUReWKfy2SE4Y',
      'amount': 80000, //in thuserImage(File _image) asynce smallest currency sub-unit.
      'name': 'NBER',
      'description': 'Driver registration fee',
      'prefill': {
        'contact': sharedPreferences.getString('MOBILE'),
        'email': ''
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
          .document(sharedPreferences.getString('DRIVERID')).updateData({
        'driver_registration_amount': '800',
        'registration_payment_status': 'Complete'
      }).then((data) async {
        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) =>
                GeneralMessageDialogBox(
                  Message: "Payment for driver is successfully done. now we verify your document and complete your process. kindly contact our customer to further process",
                ));

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

  void _createdialogforverficationpending() {
    try {
      String message = 'Hello , ' + sharedPreferences.getString("USERNAME") +
          " your request for driver is under process. we are working  on your uploaded document we will get back you soon . thanks for registered with us";
      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) =>
              GeneralMessageDialogBox(
                Message: message,
              ));
    }catch(e){
      print(e);
    }
  }
}