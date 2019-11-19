import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nber_flutter/CommonModels.dart';
import 'package:nber_flutter/MyWalletMainFile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'Consts.dart';
import 'GenralMessageDialogBox.dart';
import 'RequestforAmountWhitdrawalapi.dart';
import 'UpdateBankDetailApi.dart';
import 'fitnessApp/bottomNavigationView/bottomBarView.dart';
import 'fitnessApp/fintnessAppTheme.dart';
import 'fitnessApp/models/tabIconData.dart';
import 'fitnessApp/traning/trainingScreen.dart';
import 'main.dart';
import 'dart:math' as math;

class MyWalletHeaderFile extends StatefulWidget{
  @override
  _MyWalletHeaderFileState createState() => _MyWalletHeaderFileState();
}

class _MyWalletHeaderFileState extends State<MyWalletHeaderFile>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
 static ProgressDialog progressDialog;
  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

  @override
  void initState() {
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
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    tabBody = MyWalletMainFile(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 62,
              child: Padding(
                padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                child: Row(
                  children: <Widget>[
                    Expanded(child:InkWell(
                      onTap: (){
                        _createdialogforaddbankdetail();
                      },
                      child: Image
                          .asset(
                        'images/bank.png',
                        width: 40,
                        height: 40,),
                    )),

                    SizedBox(
                      width: Tween(begin: 0.0, end: 1.0)
                          .animate(CurvedAnimation(
                          parent: animationController,
                          curve: Curves.fastOutSlowIn))
                          .value *
                          64.0,
                    ),
                    Expanded(child:InkWell(
                      onTap: (){
                        _createdialogforwhitdrawalrequest();
                      },
                      child: Image
                          .asset(
                        'images/money-taken.png',
                        width: 40,
                        height: 40,),
                    )),

                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        )

      ],
    );
  }


  void setRemoveAllSelection(TabIconData tabIconData) {
    if (!mounted) return;
    setState(() {
      tabIconsList.forEach((tab) {
        tab.isSelected = false;
        if (tabIconData.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }

  void _createdialogforaddbankdetail() {
    ///// show dialog for add bank detail
    var accountnumbercontroller=new TextEditingController();
    var ifsccodecontroller=new TextEditingController();
    var banknamecontroller=new TextEditingController();
    var banknameholder= new TextEditingController();
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
                        "Add/Update Your Bank Detail",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      /// FOR BANK NAME
                      TextFormField(controller:banknamecontroller,inputFormatters: [LengthLimitingTextInputFormatter(6),],
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          style: TextStyle(color: Colors.black,fontSize: 16,),
                          decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(15.00),borderSide: new BorderSide(color: Colors.black)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15.0),),contentPadding: EdgeInsets.only(left:10,top:5,right:10,bottom:5),hintText: "Enter Bank Name"
                          )),
                      Padding(padding: const EdgeInsets.only(top:10),),
                      /// FOR BANK ACCOUNT NO
                      TextFormField(controller:accountnumbercontroller,inputFormatters: [LengthLimitingTextInputFormatter(6),],
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          style: TextStyle(color: Colors.black,fontSize: 16,),
                          decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(15.00),borderSide: new BorderSide(color: Colors.black)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15.0),),contentPadding: EdgeInsets.only(left:10,top:5,right:10,bottom:5),hintText: "Enter IFSC Code"
                          )),
                      Padding(padding: const EdgeInsets.only(top:10),),
                      /// FOR IFSC
                      TextFormField(controller:ifsccodecontroller,inputFormatters: [LengthLimitingTextInputFormatter(6),],
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          style: TextStyle(color: Colors.black,fontSize: 16,),
                          decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(15.00),borderSide: new BorderSide(color: Colors.black)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15.0),),contentPadding: EdgeInsets.only(left:10,top:5,right:10,bottom:5),hintText: "Enter Account Name"
                          )),
                      Padding(padding: const EdgeInsets.only(top:10),),
                      /// NAME IN BANK
                      TextFormField(controller:banknameholder,inputFormatters: [LengthLimitingTextInputFormatter(6),],
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          style: TextStyle(color: Colors.black,fontSize: 16,),
                          decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(15.00),borderSide: new BorderSide(color: Colors.black)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15.0),),contentPadding: EdgeInsets.only(left:10,top:5,right:10,bottom:5),hintText: "Enter Bank Holder Name"
                          )),




                      /////// BUTTON
                      SizedBox(height: 24.0),
                      Row(children:<Widget>[

                        Expanded(

                          child: FlatButton(
                            onPressed: () {
                              String accountnumber=accountnumbercontroller.text.toString();
                              String bankname=banknamecontroller.text.toString();
                              String ifsccode=ifsccodecontroller.text.toString();
                              String bankholdername=banknameholder.text.toString();
                              if(accountnumber.length==0||accountnumber.isEmpty||accountnumber==" "||accountnumber==null) {
                                 showDialog(barrierDismissible: false,
                                    context: context,
                                    builder: (_) => GeneralMessageDialogBox(Message:"Enter account number",
                                    ));

                              }
                             else if(bankname.length==0||bankname.isEmpty||bankname==" "||bankname==null) {

                                showDialog(barrierDismissible: false,
                                    context: context,
                                    builder: (_) => GeneralMessageDialogBox(Message:"Enter Bank Name",
                                    ));
                              }
                             else if(ifsccode.length==0||ifsccode.isEmpty||ifsccode==" "||ifsccode==null) {

                                showDialog(barrierDismissible: false,
                                    context: context,
                                    builder: (_) => GeneralMessageDialogBox(Message:"Enter IFSC Code",
                                    ));
                              }
                             else if(bankholdername.length==0||bankholdername.isEmpty||bankholdername==" "||bankholdername==null) {

                                showDialog(barrierDismissible: false,
                                    context: context,
                                    builder: (_) => GeneralMessageDialogBox(Message:"Enter Bank Holder Name",
                                    ));
                              }
                              else{
                                Navigator.of(context).pop();
                                progressDialog.show();
                                callapiforupdatebankdetail(accountnumber,bankname,ifsccode,bankholdername);


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
  void  _createdialogforwhitdrawalrequest(){
    var amountcontroller=new TextEditingController();

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
                        "Request For Whitdrawal Amount",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      /// FOR BANK NAME
                      TextFormField(controller:amountcontroller,inputFormatters: [LengthLimitingTextInputFormatter(6),],
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          style: TextStyle(color: Colors.black,fontSize: 16,),
                          decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(15.00),borderSide: new BorderSide(color: Colors.black)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15.0),),contentPadding: EdgeInsets.only(left:10,top:5,right:10,bottom:5),hintText: "Enter Amount"
                          )),
                      Padding(padding: const EdgeInsets.only(top:10),),
                      /// FOR BANK ACCOUNT NO





                      /////// BUTTON
                      SizedBox(height: 24.0),
                      Row(children:<Widget>[

                        Expanded(

                          child: FlatButton(
                            onPressed: () {
                              String accountnumber=amountcontroller.text.toString();
                                if(accountnumber.length==0||accountnumber.isEmpty||accountnumber==" "||accountnumber==null) {

                                showDialog(barrierDismissible: false,
                                    context: context,
                                    builder: (_) => GeneralMessageDialogBox(Message:"Enter Amount",
                                    ));
                              }
                                else{
                                Navigator.of(context).pop();
                                progressDialog.show();
                                callapiforwhitdrawalrequest(accountnumber);



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

  Future<void> callapiforupdatebankdetail(String accountnumber, String bankname, String ifsccode, String bankholdername) async {
   try {
     progressDialog.show();
     SharedPreferences sharedprefrence = await SharedPreferences.getInstance();
     updateBankDetailApi updatebankapi = new updateBankDetailApi();
     CommonModels results = await updatebankapi.search(
         sharedprefrence.getString("USERID"), accountnumber, bankholdername,
         ifsccode, bankname, "Bearer" + sharedprefrence.getString("TOKEN"));

     String names = results.status;


     if (names == "200") {
       progressDialog.hide();

       showDialog(barrierDismissible: false,
           context: context,
           builder: (_) =>
               GeneralMessageDialogBox(Message: results.message,
               ));
     }
     else {
       progressDialog.hide();

       showDialog(barrierDismissible: false,
           context: context,
           builder: (_) =>
               GeneralMessageDialogBox(Message: results.message,
               ));
     }
   }catch(e)
    {
      progressDialog.hide();
      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message:"Sorry There seems to be a Network Server Error. Please try again later.",
          ));
    }

  }

  Future<void> callapiforwhitdrawalrequest( String amount) async {
    try {
      progressDialog.show();
      SharedPreferences sharedprefrence = await SharedPreferences.getInstance();
      RequestforAmountWhitdrawalapi updatebankapi = new RequestforAmountWhitdrawalapi();
      CommonModels results = await updatebankapi.search(
          sharedprefrence.getString("USERID"), amount,
          "Bearer" + sharedprefrence.getString("TOKEN"));

      String names = results.status;


      if (names == "200") {
        progressDialog.hide();
        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:results.message,
            ));
      }
      else {
        progressDialog.hide();

        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:results.message,
            ));
      }
    }catch(e)
    {
      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message:"Sorry There seems to be a Network Server Error. Please try again later.",
          ));
    }
  }


}

class TabIcons extends StatefulWidget {
  final TabIconData tabIconData;
  final Function removeAllSelect;
  const TabIcons({Key key, this.tabIconData, this.removeAllSelect})
      : super(key: key);
  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData.animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 400),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        widget.removeAllSelect();
        widget.tabIconData.animationController.reverse();
      }
    });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                new ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween(begin: 0.88, end: 1.0).animate(CurvedAnimation(
                      parent: widget.tabIconData.animationController,
                      curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn))),
                  child: Image.asset(widget.tabIconData.isSelected
                      ? widget.tabIconData.selctedImagePath
                      : widget.tabIconData.imagePath),
                ),
                Positioned(
                  top: 4,
                  left: 6,
                  right: 0,
                  child: new ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                        parent: widget.tabIconData.animationController,
                        curve:
                        Interval(0.2, 1.0, curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: FintnessAppTheme.nearlyDarkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 6,
                  bottom: 8,
                  child: new ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                        parent: widget.tabIconData.animationController,
                        curve:
                        Interval(0.5, 0.8, curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: FintnessAppTheme.nearlyDarkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 8,
                  bottom: 0,
                  child: new ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                        parent: widget.tabIconData.animationController,
                        curve:
                        Interval(0.5, 0.6, curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: FintnessAppTheme.nearlyDarkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  final double radius;
  TabClipper({this.radius = 38.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    final v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
