import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> forimage;
  List<String> fortext;
  bool mainview=false;
  String vehiclenumber,vehicletype;
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
forimage=new List();
fortext=new List();
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
    
    callfirebasestoretogetvehicledata();
    
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
        //appBar: getAppBarUI(),

        body: Stack(
          children: <Widget>[
            //getAppBarUI(),
           
            getBaseUI(),






          ],
        ),
      ),
    );
  }





  getBaseUI() {

      return Scaffold(
       appBar: getAppBarUI(),
        body:   mainview==true?SingleChildScrollView(scrollDirection: Axis.vertical,
            child:new Container(color: MyColors.white, margin: const EdgeInsets.only(top:00,left: 10,bottom: 00,right: 10),
          child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.only(
              top:
                  0,
              bottom: 0,
            ),),



         Container(margin:const EdgeInsets.only(top: 10,left: 5,right: 5), child:Text("Vehicle Number : "+vehiclenumber,textAlign: TextAlign.center,style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),)

            ,Container(margin:const EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 10), child:Text("Vehicle Type : "+vehicletype,textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),)
            ,Container(margin:const EdgeInsets.only(top: 20,left: 5,right: 5,bottom: 10), child:Text("Document detial ",textAlign: TextAlign.center,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),)




      ,Container(
      height: 1500,

      child:GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2, physics: const NeverScrollableScrollPhysics(),
        // Generate 100 widgets that display their index in the List.
        children: List.generate(forimage.length, (index) {
          return buildSingleSubcategory(imgLocation: forimage[index],imgCaption: fortext[index],index: index);
        }),
      ),




      )],)

            )):SizedBox(),

      );

  }

  Widget buildSingleSubcategory({imgLocation, String imgCaption, int index}) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Container(
        width: 150,
        height: 100 ,
        child: Column(
          children: <Widget>[
            Expanded(
              child:
                  imgLocation!=null?
                  Image.network(
                    imgLocation,
                    fit: BoxFit.cover,
width: 150,
                  ):Image.asset('images/yellow_logo.png',fit: BoxFit.cover,
                      width: 150,),

              flex: 4,
            ),
            Expanded(
                flex: 1,
                child: Container(padding:const EdgeInsets.only(left: 1,right: 1) ,alignment: Alignment.center, color:MyColors.yellow,child:

                new
                Container(margin:const EdgeInsets.only(left: 1) ,alignment: Alignment.center, child:
                   Text(
                     imgCaption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,style: TextStyle(color: MyColors.white),textAlign: TextAlign.center,
                      ),

                  ),


                ))],
        ),
      ),
    );
  }

  Future<void> callfirebasestoretogetvehicledata() async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    Firestore.instance.collection('driver').document(sharedPreferences.getString('DRIVERID')).get().
    then((driverdata){
      setState((){
        vehiclenumber=driverdata.data['vehicle_number'];
        vehicletype=driverdata.data['vehicle_type'];
      });


      forimage.add(driverdata.data['aadhar_back']);
      forimage.add(driverdata.data['aadhar_front']);
      //forimage.add(driverdata.data['aadhar_number']);
      forimage.add(driverdata.data['dl_back']);
      forimage.add(driverdata.data['dl_front']);

      forimage.add(driverdata.data['insurance_first']);
      forimage.add(driverdata.data['insurance_second']);
      forimage.add(driverdata.data['insurance_third']);
      forimage.add(driverdata.data['pan_file']);

      forimage.add(driverdata.data['police_verification_file']);
      forimage.add(driverdata.data['rc_back']);
      forimage.add(driverdata.data['rc_front']);
      forimage.add(driverdata.data['rto_back']);
      forimage.add(driverdata.data['rto_front']);
      forimage.add(driverdata.data['vehicle_back']);
      forimage.add(driverdata.data['vehicle_front']);


      fortext.add('Aadhar Back');
      fortext.add('Aadhar Front');
      //fortext.add(driverdata.data['aadhar_number']);
      fortext.add('DL Back');
      fortext.add('DL Front');

      fortext.add('Insurance First Page');
      fortext.add('Insurance Second Page');
      fortext.add('Insurance Third Page');
      fortext.add('Pancard');

      fortext.add('Police Verification File');
      fortext.add('RC Back');
      fortext.add('RC Front');
      fortext.add('RTO Back');
      fortext.add('RTO Front');
      fortext.add('Vehicle Back');
      fortext.add('Vehicle Front');
      setState(() {
        mainview=true;
      });

    });
    
    
  }
  Widget getAppBarUI() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(72.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: MyColors
                    .white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FintnessAppTheme.grey
                          .withOpacity(0.4 * 0.0),
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
                        top: 16 ,
                        bottom: 12),
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
                                fontSize: 22,
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
          ],
        ));
  }
}
