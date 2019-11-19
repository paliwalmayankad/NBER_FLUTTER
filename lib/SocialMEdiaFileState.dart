import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fitnessApp/fintnessAppTheme.dart';

class SocialMEdiaFileState extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;


  const SocialMEdiaFileState({Key key, this.animationController, this.animation})
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
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 10, bottom: 10),
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
                        color: FintnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 0, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 10),

                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                                 Container(height: 40,width: 40,child: InkWell(
                                   child:Image.asset('images/facebook.png')

                                 ),),
                              Container(margin:const EdgeInsets.only(left:10,right: 10),height: 40,width: 40,child: InkWell(
                                      child:Image.asset('images/instagram.png')

                                  ),)
,
                              Container(height: 40,width: 40,child: InkWell(
                                      child:Image.asset('images/twitter.png')

                                  ),)



                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4,top: 10),

                          ),
                        ],
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
