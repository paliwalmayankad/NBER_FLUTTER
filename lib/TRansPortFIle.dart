import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nber_flutter/AboutUsFile.dart';
import 'package:nber_flutter/Login.dart';
import 'package:nber_flutter/MyWalletHeaderFile.dart';
import 'package:nber_flutter/ShowMyVehicleFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'BEcomeDriverFile.dart';
import 'DashBoardFile_Second.dart';
import 'DriverWithNberFile.dart';
import 'SupportFile.dart';
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
  int screenload=0;
  BuildContext cont;
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
    cont=context;
    return    WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          color: AppTheme.nearlyWhite,
          child: SafeArea(

            child: Scaffold(
              backgroundColor: AppTheme.nearlyWhite,
              body: DrawerUserController(
                screenIndex: drawerIndex,
                drawerWidth: MediaQuery.of(context).size.width * 0.65,
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
        ));
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = TransPortFile_Second();
          screenload=0;
        });

      } else if (drawerIndex == DrawerIndex.yourtrip) {
        setState(() {
          screenView = DesignCourseHomeScreen();
          screenload=1;
        });
      } else if (drawerIndex == DrawerIndex.notifivation) {
        setState(() {
          screenload=1;
          animationController =
              AnimationController(duration: Duration(milliseconds: 600), vsync: this);
          screenView =  TrainingScreen(animationController: animationController);



        });
      } else if (drawerIndex == DrawerIndex.share) {
        setState(() {
          screenload=1;
          screenView = InviteFriend();
        });
      }else if (drawerIndex == DrawerIndex.setting) {
        setState(() {
          screenload=1;
          // screenView = InviteFriend();
        });
      }
      else if (drawerIndex == DrawerIndex.Driverwithnber) {
        setState(() {
          screenload=1;
          //     screenView = DriverWithNberFile();
          screenView = BEcomeDriverFile()  ;
        });
      }
      else if(drawerIndex==DrawerIndex.Showmyvehicle){
        setState(() {
          screenload=1;
          screenView=ShowMyVehicleFile();
        });
      }
      else if (drawerIndex == DrawerIndex.wallet) {
        setState(() {
          screenload=1;
          screenView = MyWalletHeaderFile();
        });
      }
      else if (drawerIndex == DrawerIndex.about) {
        setState(() {

          // screenView = InviteFriend();
          // screenView=AboutUsFile();
          UrlLauncher.launch("http://thenber.com/");

        });
      }
      else if (drawerIndex == DrawerIndex.support) {
        setState(() {
          screenload=1;
          animationController =
              AnimationController(duration: Duration(milliseconds: 600), vsync: this);
          screenView = SupportFile(animationController: animationController);

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
    );
  }

  Future<bool> _onWillPop() async{
    bool out;
    if(screenload==0){
    return true;
    }
    else{
      setState(() {
        screenload=0;
        screenView = TransPortFile_Second();
      });
    }
   // return true;
  }
}



