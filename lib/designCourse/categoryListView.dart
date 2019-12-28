import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nber_flutter/MyBookedRidesApi.dart';
import 'package:nber_flutter/MyRideModels.dart';
import 'package:nber_flutter/designCourse/designCourseAppTheme.dart';
import 'package:nber_flutter/designCourse/models/category.dart';
import 'package:nber_flutter/designCourse/popularCourseListView.dart';
import 'package:nber_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../GenralMessageDialogBox.dart';

class CategoryListView extends StatefulWidget {
  final Function callBack;

  const CategoryListView({Key key, this.callBack}) : super(key: key);
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  MyBookRidesApi _bookrideapi;
  List<RideData> ridelist;
  ProgressDialog progressdialog;
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _bookrideapi=new MyBookRidesApi();
    ridelist=new List();
    progressdialog=new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressdialog.style(
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
  callapidataforbookingdetail();
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(

        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: ridelist.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var count = ridelist.length > 10
                      ? 10
                      : ridelist.length;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return CategoryView(
                    category: ridelist[index],
                    animation: animation,
                    animationController: animationController,
                    callback: () {
                      widget.callBack();
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> callapidataforbookingdetail() async {
  try {
    sharedPreferences = await SharedPreferences.getInstance();
    progressdialog.show();
    String userid = sharedPreferences.getString("USERID");

   var snapshotdata=  Firestore.instance.collection("users").document(userid).get().then((userdata){
    try {
      List<dynamic> userbookinglist = userdata.data['mybookinglist'];
      List<RideData> ridedata=new List();
        for(int i=0;i<userbookinglist.length;i++)
        {
          try {
            String bookingid = userbookinglist[i].toString();
            Firestore.instance.collection('bookingrequest')
                .document(bookingid)
                .get()
                .then(
                    (bookingdata) {
              RideData rdata = RideData.documentSnapShot(bookingdata);
              ridedata.add(rdata);
              var length=ridedata.length;
              ridelist.add(rdata);
              progressdialog.hide();
              

                    });
          }
          catch(e){
            progressdialog.hide();

            print(e);
          }
          
          
        }
        
      
      
      
      //var jj = userbookinglist.length;
      
      
      



      //// NOW GET EVERY BOOKINGDATA

    }
    catch(e){
      progressdialog.hide();

      print(e);
    }
   });





    /*String TOKEN = "Bearer " + sharedPreferences.getString("TOKEN");
    MyRideModels results = await _bookrideapi.search(userid, TOKEN);

    String names = results.status;


    if (names == "200")
    {
      if(results.bookingdata.length>0)
      {
        ridelist = results.bookingdata;
        progressdialog.hide();
      }
      else
        {
          progressdialog.hide();
          showDialog(barrierDismissible: false,
              context: context,
              builder: (_) => GeneralMessageDialogBox(Message: "Sorry No Data Available",
              ));
        // Toast.show("Sorry No Data Available",context,duration:Toast.LENGTH_SHORT,gravity:Toast.CENTER);

      }

    }
    else {
      progressdialog.hide();
       showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message: results.message,
          ));
    }*/
  }catch(e){
    progressdialog.hide();

    showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => GeneralMessageDialogBox(Message: "Sorry there seems to be a network server Error , please try again later.",
        ));
  }
  }
}
Future<bool> getData() async {
  await Future.delayed(const Duration(milliseconds: 3000));
  return true;
}
class CategoryView extends StatelessWidget {
  final VoidCallback callback;
  final RideData category;
  final AnimationController animationController;
  final Animation animation;

  const CategoryView(
      {Key key,
        this.category,
        this.animationController,
        this.animation,
        this.callback})
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
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback();
              },
              child: SizedBox(
                width: 280,
                height: 500,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: new BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 48 + 24.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                         Align(alignment:Alignment.topLeft, child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 16),
                                            child: Text(
                                              "Start${category.mobile} \n Stop ${category.mobile} ",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                letterSpacing: 0.27,
                                                color: DesignCourseAppTheme
                                                    .darkerText,
                                              ),
                                            ),
                                          )),

                                         Align(alignment: Alignment.topLeft,child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16, bottom: 8,top: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  " Booking Start: ${category.from_address}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                                Text(
                                                  " Booking Stop: ${category.to_address}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                                Text(
                                                  " Vehicle No: ${category.from_address}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                                Text(
                                                  " Driver Name: ${category.driver_name}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .grey,
                                                  ),
                                                ),

                                              ],
                                            ),
                                          )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16, right: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            8.0)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        4.0),
                                                    child: Icon(
                                                      Icons.add,
                                                      color:
                                                      DesignCourseAppTheme
                                                          .nearlyWhite,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            8.0)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        4.0),
                                                    child: Icon(
                                                      Icons.add,
                                                      color:
                                                      DesignCourseAppTheme
                                                          .nearlyWhite,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            8.0)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        4.0),
                                                    child: Icon(
                                                      Icons.add,
                                                      color:
                                                      DesignCourseAppTheme
                                                          .nearlyWhite,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 24, left: 16),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(
                                  aspectRatio: 0.6,
                                  child: Image.asset('assets/design_course/interFace1.png')),
                            )
                          ],
                        ),
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
}