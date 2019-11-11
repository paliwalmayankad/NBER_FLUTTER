import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GridViewForDocumnetFile.dart';
import 'MyColors.dart';
import 'fitnessApp/UIview/bodyMeasurement.dart';
import 'fitnessApp/UIview/mediterranesnDietView.dart';
import 'fitnessApp/UIview/titleView.dart';
import 'fitnessApp/fintnessAppTheme.dart';

class Show_myvehicle_updateandREload extends StatefulWidget {
final AnimationController animationController;

const Show_myvehicle_updateandREload({Key key, this.animationController}) : super(key: key);
@override
Show_myvehicle_updateandREloadState createState() => Show_myvehicle_updateandREloadState();
}

class Show_myvehicle_updateandREloadState extends State<Show_myvehicle_updateandREload>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  List<dynamic> products;
  List<dynamic> categories;
  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List<String> _locations;
  String productsJson =
      '{"last": [{"product_id":"62","thumb":"sandwich.png","name":"Test Tilte","price":"\$55.00"}, '
      '{"product_id":"61","thumb":"sandwich.png","name":"Test Tilte","price":"\$55.00"}, '
      '{"product_id":"57","thumb":"sandwich.png","name":"Test Tilte","price":"\$55.00"}, '
      '{"product_id":"63","thumb":"sandwich.png","name":"Test Tilte","price":"\$55.00"}, '
      '{"product_id":"64","thumb":"sandwich.png","name":"Test Tilte","price":"\$55.00"}, '
      '{"product_id":"58","thumb":"sandwich.png","name":"Test Tilte","price":"\$55.00"}, '
      '{"product_id":"59","thumb":"sandwich.png","name":"Test Tilte","price":"\$55.00"}]}';

  String categoriesJson = '{"categories":['
      '{"name":"Category 1","image":"icon.png","id":2}, '
      '{"name":"Category 2","image":"icon.png","id":4}, '
      '{"name":"Category 3","image":"icon.png","id":4}, '
      '{"name":"Category 4","image":"icon.png","id":4}, '
      '{"name":"Category 5","image":"icon.png","id":6}]}';

  @override
  void initState() {
    _locations = new List();
    Map<String, dynamic> decoded = json.decode(productsJson);
    products = decoded['last'];

    Map<String, dynamic> decodedCategories = json.decode(categoriesJson);
    categories = decodedCategories['categories'];
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
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
    var count = 9;

    /*listViews.add(
      TitleView(
        titleTxt: 'Mediterranean diet',
        subTxt: 'Details',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );*/
    listViews.add(
      GridViewForDocumentFile(
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    listViews.add(
      GridViewForDocumentFile(
        titleTxt: 'Meals today',
        subTxt: 'Customize',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      GridViewForDocumentFile(
        titleTxt: 'Meals today',
        subTxt: 'Customize',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      GridViewForDocumentFile(
        titleTxt: 'Meals today',
        subTxt: 'Customize',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      GridViewForDocumentFile(
        titleTxt: 'Meals today',
        subTxt: 'Customize',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    /*listViews.add(
      TitleView(
        titleTxt: 'Water',
        subTxt: 'Aqua SmartBottle',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );*/

    /*listViews.add(
      WaterView(
        mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 7, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
    listViews.add(
      GlassView(
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve:
                  Interval((1 / count) * 8, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController),
    );*/
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[

            getBaseUI(),
            //getMainListViewUI(),




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
          return GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(4.0),
            childAspectRatio: 8.0 / 9.0,
            children: listViews

                .toList(),
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
                            left: 100,
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
                                  "My Vehicle",
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

  getBaseUI() {
    return FutureBuilder(
        future: getData(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return SizedBox();
    } else {
      return Scaffold(
        body: Stack(children:[
          new Column(children: <Widget>[
            Padding(padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 12 + MediaQuery.of(context).padding.bottom,
            ),),
           Align(alignment:Alignment.center,child: InkWell(child: new Container(
                width: 120.0,
                height: 120.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://i.imgur.com/BoN9kdC.png")
                    )
                ))),
           ),

            Align(alignment: Alignment.topLeft,
              child: new Container(margin: const EdgeInsets.only(top:10,left:10,right:10) ,alignment: Alignment
                  .topLeft,
                child: Text('Vehicle Number', style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),


                ),),),
            Container(
                margin: const EdgeInsets.only(
                left: 0, right: 10),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                    top: 5, bottom: 4),
                decoration: new BoxDecoration(color: MyColors
                    .white, border: Border(
                    bottom: BorderSide(color: Colors.black,
                      width: 1.0,)),),


                child: new Row(children: <Widget>[

                  Expanded(flex: 10,
                    child: TextFormField(
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        style: TextStyle(color: Colors.black,
                            fontSize: 14),
                        decoration: new InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: new OutlineInputBorder(
                                borderRadius: new BorderRadius
                                    .circular(20.00),
                                borderSide: new BorderSide(
                                    color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white),
                                borderRadius: BorderRadius
                                    .circular(20.00)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white),
                              borderRadius: BorderRadius
                                  .circular(20.0),),
                            contentPadding: EdgeInsets.only(
                                left: 00,
                                top: 0,
                                right: 10,
                                bottom: 0),
                            hintText: "Enter Vehicle Number"
                        )),
                  ),

                ])),
            new SingleChildScrollView(child:SizedBox( height: 1000.0,child:  new GridView.count(
              crossAxisCount: 2,

              padding: EdgeInsets.all(4.0),
              childAspectRatio: 8.0 / 9.0,
              children: listViews

                  .toList(),




            )),
            )],)

        ]),

      );
    }
    });
  }
}
