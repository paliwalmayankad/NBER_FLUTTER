import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nber_flutter/DriverWalletApi.dart';
import 'package:nber_flutter/MyWalletModel.dart';
import 'package:nber_flutter/TransPortFIle_Second.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'DriverWalletModels.dart';
import 'GenralMessageDialogBox.dart';
import 'GridViewForDocumnetFile.dart';
import 'MyColors.dart';
import 'fitnessApp/UIview/bodyMeasurement.dart';
import 'fitnessApp/UIview/mediterranesnDietView.dart';
import 'fitnessApp/UIview/titleView.dart';
import 'fitnessApp/fintnessAppTheme.dart';

class MyWalletMainFile extends StatefulWidget {
  final AnimationController animationController;

  const MyWalletMainFile({Key key, this.animationController}) : super(key: key);
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyWalletMainFile>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  ProgressDialog progressDialog;
  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;
  SharedPreferences sharedprefrences;
  DriverWalletApi driverwalletapi;
bool mainview=false;
  @override
  void initState() {
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    driverwalletapi= new DriverWalletApi();

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
      callapiforgetmywallet();


      //Toast.show(sp.getString("USERNAME"), context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
      setState(() {});
    });


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
    super.initState();
  }

  void addAllListData(DriverWalletModels walletmodels) {
    var count = 9;

    final f = new NumberFormat("######.00");
    listViews.add(
      MediterranesnDietView(
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,earned: (f.format(double.parse(walletmodels.earned))).toString(),whitdrawal:(f.format(double.parse(walletmodels.withdraw))).toString() ,balance: (f.format(double.parse(walletmodels.balance))).toString(),

      ),
    );


    listViews.add(
      TitleView(
        titleTxt: 'Transcation',
        subTxt: '',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    //// ADD OTHER TRANSCATION DETAIL FOR DRIVER LIKE LSIT

   }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: mainview==true?Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ):SizedBox(),
      ),
    );
  }

  Widget getMainListViewUI() {



          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );



  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FintnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FintnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "My Wallet",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FintnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FintnessAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Future<void> callapiforgetmywallet() async {
    try {
       progressDialog.show();
      /*DriverWalletModels walletmodels = await driverwalletapi.search(
          sharedprefrences.getString("USERID"),
          "Bearer " + sharedprefrences.getString("TOKEN"));
      String status = walletmodels.ResponseCode;
      if (status == "200") {
        progressDialog.hide();
        addAllListData(walletmodels);
      }
      else {
        progressDialog.hide();
        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message:walletmodels.Message,
            ));
      }*/

      Firestore.instance.collection("wallet").document(sharedprefrences.getString("DRIVERWALLETID")).get().
      then((walletdata){
        progressDialog.dismiss();
        DriverWalletModels walletmodels= DriverWalletModels.map(walletdata.data);
        // progressDialog.dismiss();
        addAllListData(walletmodels);
        adddatamodels(walletmodels);


      });


    }catch(e)
    {progressDialog.dismiss();
    showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message:"Sorry there seems to be a network server Error. Please try again Later.",
        ));
    }
  }

  void adddatamodels(DriverWalletModels walletmodels) {
    if(walletmodels.dataList.length>0){


      for(int i=0;i<walletmodels.dataList.length;i++) {
        try {
          Firestore.instance.collection("transcation").document(
              walletmodels.dataList[i]).get().then((transcationdata) {
            String paymenttype = "";
            String msg;
            if (transcationdata.data['paymentstatus'] == "cr") {
              paymenttype = "Cr";
              msg = "Amount Credited";
            }
            else {
              paymenttype = "Dr";
              msg = "Amount Debited";
            }
            double payment = double.parse(
                transcationdata.data['amount'].toString());
            setState(() {
              listViews.add(
                BodyMeasurementView(
                  animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: widget.animationController,
                      curve:
                      Interval((1 / 9) * 5, 1.0,
                          curve: Curves.fastOutSlowIn))),
                  animationController: widget.animationController,
                  payment: payment.toStringAsFixed(2).toString(),
                  payment_type: paymenttype,
                  msg: msg,
                  transcationtime: transcationdata.data['timestamp'].toString(),
                ),
              );
            });

            setState(() {
              mainview=true;
            });
          });
        } catch (e) {
          print(e);
        }
      }

    }
    else{
      setState(() {
        mainview=true;
      });
    }

  }
}
