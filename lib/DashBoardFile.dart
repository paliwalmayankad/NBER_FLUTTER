import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DashBoardFile_Second.dart';
import 'appTheme.dart';
import 'customDrawer/drawerUserController.dart';
import 'customDrawer/homeDrawer.dart';
import 'homeScreen.dart';
import 'model/homelist.dart';

class DashBoardFile extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DashBoardFileState();
  }
}
class DashBoardFileState extends State<DashBoardFile> {
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
   screenView = DashBoardFile_Second();

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
          screenView = DashBoardFile_Second();
        });
      } /*else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          //screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
         /// screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
         // screenView = InviteFriend();
        });
      } */else {
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
}


