import 'package:flutter/material.dart';

import 'ShowMyVechile.dart';
import 'fitnessApp/bottomNavigationView/bottomBarView.dart';
import 'fitnessApp/fintnessAppTheme.dart';
import 'fitnessApp/models/tabIconData.dart';
import 'fitnessApp/myDiary/myDiaryScreen.dart';
import 'fitnessApp/traning/trainingScreen.dart';

class ShowMyVehicleFile extends StatefulWidget{
  @override
  _ShowMyVehicleState createState() => _ShowMyVehicleState();
}

class _ShowMyVehicleState extends State<ShowMyVehicleFile>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    tabBody = MyDiaryScreen(animationController: animationController);
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
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (index) {
            if (index == 0 || index == 2) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody =
                      MyDiaryScreen(animationController: animationController);
                });
              });

            } else if (index == 1 ) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody =
                      ShowMyVechile(animationController: animationController);
                });
              });
            }
            else if (index == 2) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);
                });
              });
            }
            else if (index ==  3) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
