import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nber_flutter/Login.dart';
import 'package:nber_flutter/MyWalletHeaderFile.dart';
import 'package:nber_flutter/ShowMyVehicleFile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BEcomeDriverFile.dart';
import 'DashBoardFile_Second.dart';
import 'DriverWithNberFile.dart';
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
  SharedPreferences sharedPreferences;
  List<HomeList> homeList = HomeList.homeList;
  AnimationController animationController;
  AnimationController sliderAnimationController;
  @override
  void initState() {
    // TODO: implement initState
    //drawerIndex = DrawerIndex.HOME;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      //Toast.show(sp.getString("USERNAME"), context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
      setState(() {});
    });

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
         screenView = TransPortFile_Second();
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
     //     screenView = DriverWithNberFile();
          screenView = BEcomeDriverFile()  ;
        });
      }
      else if(drawerIndex==DrawerIndex.Showmyvehicle){
        setState(() {
          screenView=ShowMyVehicleFile();
        });
      }
      else if (drawerIndex == DrawerIndex.wallet) {
        setState(() {
           screenView = MyWalletHeaderFile();
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
         cratedialogforlogout();
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

  Future<void> cratedialogforlogout() async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert !'),
          content: const Text(
              'Are you sure you want to Logout ?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop("Cancel");
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop("Ok");
                sharedPreferences.setBool("LOGIN", false);
                //sharedPreferences.commit();
                Navigator.pushReplacement(context, new MaterialPageRoute(builder:  (ctxt) => new Login()));
              },
            )
          ],
        );
      },
    );}
  }



