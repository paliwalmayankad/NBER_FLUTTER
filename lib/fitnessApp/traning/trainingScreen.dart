import 'package:nber_flutter/CALLAPI/NotificationApi.dart';
import 'package:nber_flutter/Models/NotificationModels.dart';
import 'package:nber_flutter/fitnessApp/UIview/areaListView.dart';
import 'package:nber_flutter/fitnessApp/UIview/runningView.dart';
import 'package:nber_flutter/fitnessApp/UIview/titleView.dart';
import 'package:nber_flutter/fitnessApp/UIview/workoutView.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../GenralMessageDialogBox.dart';
import '../fintnessAppTheme.dart';


class TrainingScreen extends StatefulWidget {
  final AnimationController animationController;

  const TrainingScreen({Key key, this.animationController}) : super(key: key);


  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  ProgressDialog progressdialog;
  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;
  SharedPreferences sharedPreferences;
  NotificationApi  _notificationapi;
  @override
  void initState() {
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    _notificationapi=new NotificationApi();
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
   callapifornotification();
    addAllListData();

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

  void addAllListData() {
    var count = 5;

   /* listViews.add(
      TitleView(
        titleTxt: 'Your program',
        subTxt: 'Details',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );*/

   /* listViews.add(
      WorkoutView(
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );*/


    /*listViews.add(
      TitleView(
        titleTxt: 'Area of focus',
        subTxt: 'more',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );*/

   /* listViews.add(
      AreaListView(
        mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 5, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );*/
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
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
                            new Container( alignment: Alignment.center,


                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Notification",
                                  textAlign: TextAlign.left,
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
                           /* SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: FintnessAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: FintnessAppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    "15 May",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FintnessAppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: FintnessAppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: FintnessAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),*/
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

  Future<void> callapifornotification()

        async{
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      progressdialog.show();
      // String name= mobilenumbercontroller.text.toString();
      String TOKEN="Bearer "+sharedPreferences.getString("TOKEN");
      String USERID=sharedPreferences.getString("USERID");
      NotificationModels results = await _notificationapi.search(
          USERID,TOKEN);

      String status = results.status;


      if (status == "200") {
        progressdialog.hide();
        var count = results.notificationdata.length;
        if(count>0) {

          /* Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new DashBoardFile()),
        );*/
          for (int i = 0; i < count; i++) {
            listViews.add(
              RunningView(
                animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: widget.animationController,
                    curve:
                    Interval(
                        (1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
                animationController: widget.animationController,
                notificationdata: results.notificationdata[i],
              ),
            );
          }
        }else{
          showDialog(barrierDismissible: false,
              context: context,
              builder: (_) => GeneralMessageDialogBox(Message: "No Data Dound",
              ));

        }
      }
      else {
        progressdialog.hide();
        /*Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new DashBoardFile()),
        );*/
        showDialog(barrierDismissible: false,
            context: context,
            builder: (_) => GeneralMessageDialogBox(Message: results.message,
            ));
         }
    }catch(e){
      progressdialog.hide();
      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message: e.toString(),
          ));
    }
  }
  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    return true;
  }
}
