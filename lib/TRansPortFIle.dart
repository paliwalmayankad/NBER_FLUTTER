import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DashBoardFile_Second.dart';
import 'TransPortFIle_Second.dart';
import 'appTheme.dart';
import 'customDrawer/drawerUserController.dart';
import 'customDrawer/homeDrawer.dart';
import 'designCourse/courseInfoScreen.dart';
import 'designCourse/homeDesignCourse.dart';
import 'fitnessApp/fintnessAppTheme.dart';
import 'fitnessApp/fitnessAppHomeScreen.dart';
import 'fitnessApp/traning/trainingScreen.dart';
import 'homeScreen.dart';
import 'inviteFriendScreen.dart';
import 'model/homelist.dart';

class TransPortFile extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DTransPortFileState();
  }
}
class DTransPortFileState extends State<TransPortFile> with TickerProviderStateMixin{
  Widget screenView;
  bool multiple = true;
  DrawerIndex drawerIndex;
  List<HomeList> homeList = HomeList.homeList;
  AnimationController animationController;
  AnimationController sliderAnimationController;
  @override
  void initState() {
    // TODO: implement initState
    //drawerIndex = DrawerIndex.HOME;
    screenView = TransPortFile_Second();
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    super.initState();
  }
  /* Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 0));
    return true;
  }*/

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(

        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            animationController: (AnimationController animationController) {
              sliderAnimationController = animationController;
            },
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
         // screenView = CourseInfoScreen();
        });

      } else if (drawerIndex == DrawerIndex.yourtrip) {
        setState(() {
          screenView = DesignCourseHomeScreen();
        });
      } else if (drawerIndex == DrawerIndex.notifivation) {
        setState(() {
          animationController =
              AnimationController(duration: Duration(milliseconds: 600), vsync: this);
           screenView =  TrainingScreen(animationController: animationController);



        });
      } else if (drawerIndex == DrawerIndex.share) {
        setState(() {
           screenView = InviteFriend();
        });
      }else if (drawerIndex == DrawerIndex.setting) {
        setState(() {
          // screenView = InviteFriend();
        });
      }
      else if (drawerIndex == DrawerIndex.Driverwithnber) {
        setState(() {
          // screenView = InviteFriend();
        });
      }
      else if (drawerIndex == DrawerIndex.wallet) {
        setState(() {
           screenView = FitnessAppHomeScreen();
        });
      }
      else if (drawerIndex == DrawerIndex.about) {
        setState(() {
          // screenView = InviteFriend();
        });
      }
      else if (drawerIndex == DrawerIndex.support) {
        setState(() {
          // screenView = InviteFriend();
        });
      }
      else if (drawerIndex == DrawerIndex.signout) {
        setState(() {
          // screenView = InviteFriend();
        });
      }else {
        //do in your way......
      }
    }
  }
  Widget appBar() {
    return SizedBox(
      // height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /*Padding(
            padding: EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),*/

        ],
      ),
    );
  }
  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );
}


