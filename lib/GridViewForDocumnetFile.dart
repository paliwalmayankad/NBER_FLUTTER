import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Models/VehicletypeModels.dart';
import 'fitnessApp/fintnessAppTheme.dart';
class GridViewForDocumentFile  extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final AnimationController animationController;
  final Animation animation;


const GridViewForDocumentFile(
    {Key key,
      this.titleTxt: "",
      this.subTxt: "",
      this.animationController,
      this.animation})
    : super(key: key);


@override
Widget build(BuildContext context) {
  return Scaffold(body: Center(child: new Row(

    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(
            left: 24, right: 24, top: 0, bottom: 0),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: FintnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FintnessAppTheme.grey.withOpacity(0.4),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.0)),
                      child: SizedBox(
                        height: 74,
                        child: AspectRatio(
                          aspectRatio: 1.7,
                          child: Image.asset(
                              "assets/fitness_app/back.png"),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 95,
                                right: 16,
                                top: 16,
                              ),
                              child: Text(
                               "",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily:
                                  FintnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color:
                                  FintnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 95,
                            bottom: 12,
                            top: 4,
                            right: 16,
                          ),
                          child: Text(
                            "",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: FintnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              letterSpacing: 0.0,
                              color: FintnessAppTheme.grey
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -0,
              left: 20,
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("images/bell.png"),
              ),
            )
          ],
        ),
      ),
    ],
  ),
  ),
  );

}
}
