import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'CommonModels.dart';
import'package:firebase_messaging/firebase_messaging.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nber_flutter/FeedbackApi.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'Consts.dart';
import 'DashBoardFile_Second.dart';
import 'GenralMessageDialogBox.dart';
import 'MyColors.dart';

import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'VerificationFile.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Loginfilestate();
  }
}
class Loginfilestate extends State<Login>{
  ///// THIS METHOD IS USE FOR CONTROLLER
  TextEditingController mobilenumbercontroller;
  String phoneNo;
  String smsOTP;
  String verificationId;
  SharedPreferences sharedprefrences;
  String errorMessage = '';
  var initialrationg=1.5;
  List<String> toPrint = ["trying to connect"];
  SocketIOManager manager;
  String loginmessage="Login With Nubmer";
  Map<String, SocketIO> sockets = {};
  Map<String, bool> _isProbablyConnected = {};
  FirebaseAuth _auth = FirebaseAuth.instance;
  Razorpay _razorpay;
  var rating = 0.0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Notification> notifications = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
checksharedprefrences();
    _razorpay = Razorpay();
    _firebaseMessaging.getToken().then((token){
      print("tokenfirebase "+token);
    });
    callfirebasepushnotification();
    mobilenumbercontroller=new TextEditingController();
    //// IMPLIMENT SOCKET.IO
    manager = SocketIOManager();

    _implementsocketio("default");
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedprefrences = sp;


      //Toast.show(sp.getString("USERNAME"), context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
      setState(()
      {
          if(sharedprefrences.getBool("LOGIN")==true)
          {
            loginmessage="Continue With "+sharedprefrences.getString("USERNAME");
          }

      });
    });

   /* _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);*/
  }
  ///// THIS OVWERRIDE METHOD IS FOR UI
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //////
    return Scaffold( body: Center(child: Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(color: MyColors.white),
          ),
          new Container(
            child:Center(
              child: Container(
                child: new Column(  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //////// for LOGO IMAGE
                  Expanded( flex:7,
                      child:Image.asset('images/nber-splash.png',fit: BoxFit.fill,
                      )

                  ),
                  //// EDIT TEXT FOR USERNAME
                  Expanded
                    (flex :3,
                      child:  new Container( alignment: Alignment.center,
                          decoration: new BoxDecoration(color: MyColors.white),margin: EdgeInsets.only(top: 10),
                          child:

                          new Column(      children:<Widget>[
//String ="Explore new ways to travel with NBER";
                             Align(alignment: Alignment.topLeft, child: Text("Explore new ways to"+"\n"+"travel with NBER",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold ),),

                            ),
                            Expanded(


                              child: Center(
                                child: Container(margin: const EdgeInsets.only(left: 55,right:55,top:15) ,alignment: Alignment.center,
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
                                        //callpaymentmethod();
                                        //_checkforbottmsheetuserreview();
                                 if(sharedprefrences.getBool("LOGIN")==true) {
                                          Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(builder: (
                                                ctxt) => new DashBoardFile_Second()),
                                          );
                                        }
                                        else{
                                          Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(builder: (
                                                ctxt) => new VerificationFile()),
                                          );
                                        }
                                       //callapiforpayment();


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
                                                loginmessage,
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
                            ),


                          /*  Expanded(


                                child: Center(
                                  child: Container(margin: const EdgeInsets.only(left: 55,right:55) ,alignment: Alignment.center,
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
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset('images/google.png',height: 20,width: 20,),
                                              Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text(
                                                  'Login With Google',
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
                                ),
                              ),*/
                          Align(alignment: Alignment.topLeft,
                              child: Container(padding: const EdgeInsets.only(bottom: 10),
                                child: Text("By continuing, you agree that you have read and accept our T&Cs and Privacy Policy. ",style: TextStyle(color: Colors.black26,fontSize: 8 ),),




                          ) )] ))

                    //Padding(padding: EdgeInsets.only(top: 80.0)),
                    ////// FOR PASSWORD

                    /*new Container(alignment: Alignment.center,padding: const EdgeInsets.all(10),
                    decoration: new BoxDecoration(color: MyColors.white,border:  Border.all(color: Colors.black),borderRadius: BorderRadius.circular(20)),



                    child:new  Row(children: <Widget>[
                      Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),

                      Expanded(flex: 1, child:
                      Text('+91',textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold) ),
                      ),
                      Expanded(flex: 10,child: TextFormField(controller: mobilenumbercontroller,inputFormatters: [LengthLimitingTextInputFormatter(10),], textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 16), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:10,top:0,right:10,bottom:0),hintText: "Enter Mobile"
                      )),
                      ),
                    ]))*/

                    ////// LOGIN BUTTON


                    // ignore: not_enough_required_arguments






                  )]),



            ),),

          ),
          //Align(alignment: Alignment.bottomRight,child: Image.asset('images/yellow_logo.png',width: 50,height: 50,),)])));
          /*Align(alignment: Alignment.bottomRight,

            child:  new RaisedButton(
              child:  new Image.asset('images/yellow_logo.png',width: 50,height: 50,),
              color: Colors.transparent,
              elevation: 0.0,
              splashColor: MyColors.yellow,
              highlightColor: MyColors.yellow,
              onPressed: (){
                _callvalidation();},
            )

            ,)*/
        ])));
  }

  void _callvalidation() async {
    String mobilenumber=mobilenumbercontroller.text.toString();
    if(mobilenumber.length==0||mobilenumber.isEmpty||mobilenumber==" "||mobilenumber==null) {

      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Enter Mobile Number",),
      );

    }
    else if(mobilenumber.length<10)
    {
        showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Enter Correct Mobile Number",),
      );
    }
    else{
      var connectivityResult = await  Connectivity().checkConnectivity();
      phoneNo="+91"+mobilenumber;
      if (connectivityResult == ConnectivityResult.mobile) {
       // _CallFireBaseandCHeckUserAuthenticatiobn();
      }

      else if (connectivityResult == ConnectivityResult.wifi) {
      //  _CallFireBaseandCHeckUserAuthenticatiobn();
      }
      else
      {

        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message: "Network Not Available. PLease check your Network Connectivity.",),
        );
      }

    }

  }
////// THIS METHOD FOR CHECK MOBILE NO ATHENTICATION AND REDIRECT TO HOME NO
  Future<void> _CallFireBaseandCHeckphoneNoUserAuthenticatiobn() async
  {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
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
            _callapiforlogin();









          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');


            showDialog(barrierDismissible: false,
              context: context,
              builder: (_) => GeneralMessageDialogBox(Message:'${exceptio.message}' ,),
            );

          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog( backgroundColor: MyColors.yellow,
            title:new Container( decoration: BoxDecoration(color: MyColors.yellow), child: Text('Enter Verification Code'),),
            content: Container(
              height: 85,
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
                      Toast.show('Login successfully', context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
                    }
                    else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)) as FirebaseUser;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      _callapiforlogin();
    }
    catch (e)
    {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  void _callapiforlogin() {



  }

  void callapiforpayment() {
    var options = {
      'key': '<YOUR_KEY_ID>',
      'amount': 100, //in the smallest currency sub-unit.
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {
        'contact': '9123456789',
        'email': 'gaurav.kumar@example.com'
      }
    };
   // _razorpay.open(options);

  }

  Future<void> _implementsocketio(String identifier) async {
    setState(() => _isProbablyConnected[identifier] = true);
    SocketIO socket = await manager.createInstance(SocketOptions(
      //Socket IO server URI
        'http://nberindia.com:4007/',

        //Enable or disable platform channel logging
        enableLogging: false,
        transports: [Transports.WEB_SOCKET/*, Transports.POLLING*/] //Enable required transport
    ));
    socket.onConnect((data) {
      pprint("connected...");
      pprint(data);
    //  sendMessageWithACK(identifier);
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
    sockets[identifier].emit("input", [{
      "lat":"24.1234","lon":"70.321654","role":"driver","user_id":"5dbc2a6ac455912d39014621"
    },]);
    sockets[identifier].on("driver" , (data){   //sample event
      print("driver");
      print(data);
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


  void _onReceiveChatMessage(dynamic message) {
    print("Message from UFO: " + message);
  }




/*void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    String jj=response.toString();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    String jj=response.toString();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    String jj=response.toString();
  }*/

  _onSocketInfo() {

  }

  void callpaymentmethod() {
   var _razorpays = Razorpay();
   var options = {
     'key': 'rzp_live_qdUReWKfy2SE4Y',
     'amount': 1000, //in the smallest currency sub-unit.
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
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("PaymentFailureResponse"+response.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("ExternalWalletResponse"+response.toString());
    // Do something when an external wallet is selected
  }

  void callfirebasepushnotification() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        Toast.show(message.containsKey("title").toString(),context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

  }

  void checksharedprefrences() {


  }

  void _checkforbottmsheetuserreview() {
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

_sendfeedback(feedbackcontroller);

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
  }

  Future<void> _sendfeedback  (TextEditingController feedbackcontroller)  async{
    try{
    String feedback=feedbackcontroller.text.toString();
    if(feedback.length<0||feedback.isEmpty||feedback==null){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "PLease Enter Feedback",),
      );
    }
    else{
      SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
      String user_id=sharedPreferences.getString("USERID");
      String TOKEN=sharedPreferences.getString("TOKEN");
      String bookingid=sharedPreferences.getString("BOOKINGID");


      FeedbackApi _feedbackapi= new FeedbackApi();
      CommonModels models=await _feedbackapi.search(bookingid, user_id, "", feedback, initialrationg, "", TOKEN);
      if(models.response=="200"){
        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message: models.message,),
        );
      }
    else{
        showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message:  models.message,),
        );
      }

    }
    }catch(e){
      showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message:  "Sorry There Seems to be a Network/Server Error. Please try again Later",),
      );
    }

  }}