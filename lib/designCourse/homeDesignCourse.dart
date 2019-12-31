import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nber_flutter/GenralMessageDialogBox.dart';
import 'package:nber_flutter/MyBookedRidesApi.dart';
import 'package:nber_flutter/MyRideModels.dart';
import 'package:nber_flutter/designCourse/categoryListView.dart';
import 'package:nber_flutter/designCourse/courseInfoScreen.dart';
import 'package:nber_flutter/designCourse/popularCourseListView.dart';
import 'package:nber_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../UserbookingDetail.dart';
import 'designCourseAppTheme.dart';

class DesignCourseHomeScreen extends StatefulWidget {
  @override
  _DesignCourseHomeScreenState createState() => _DesignCourseHomeScreenState();
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  CategoryType categoryType = CategoryType.ui;
  bool mainview=false;
  MyBookRidesApi _bookrideapi;
  List<RideData> ridelist;
  ProgressDialog progressdialog;
  SharedPreferences sharedPreferences;
@override
  void initState() {
    // TODO: implement initState

    ridelist=new List();
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
    callapidataforbookingdetail();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            mainview==true?
                      Expanded(
                          child:ListView.builder(shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, right: 16, left: 16),
                        itemCount: ridelist.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {



                          return CategoryView(
                            category: ridelist[index],usertype: sharedPreferences.getString("ROLE"),

                          );
                        },
                      ))
                      /*Flexible(
                        child: getPopularCourseUI(),
                      ),*/
                    :SizedBox(),

            
          ],
        ),
      ),
    );
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          /*child: Text(
            "Category",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),*/
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              getButtonUI(CategoryType.ui, categoryType == CategoryType.ui),
              SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.coding, categoryType == CategoryType.coding),
              SizedBox(
                width: 16,
              ),

            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
       new Container( alignment: Alignment.center, child: CategoryListView(
          callBack: () {
            moveTo();
          },
        )),
      ],
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Popular Course",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
         /* Flexible(
            child: PopularCourseListView(
              callBack: () {
                moveTo();
              },
            ),
          )*/
        ],
      ),
    );
  }

  void moveTo() {
   /* Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseInfoScreen(),
      ),
    );*/
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    var txt = '';
    if (CategoryType.ui == categoryTypeData) {
      txt = 'Completed';
    } else if (CategoryType.coding == categoryTypeData) {
      txt = 'Canceled';
    }
    return Expanded(
      child: Container(
        decoration: new BoxDecoration(
            color: isSelected
                ? DesignCourseAppTheme.nearlyBlue
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            border: new Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding:
                  EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: new BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: new TextFormField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            labelText: 'Search for course',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 18, right: 18,bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
new Container( alignment: Alignment.center,
               child: Text(
                  "Your Trips",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                )),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Future<void> callapiforbookings() async {




  }

  void callapidataforbookingdetail() async {

    try {
      sharedPreferences = await SharedPreferences.getInstance();
      progressdialog.show();
      String userid = sharedPreferences.getString("USERID");

      var snapshotdata=  Firestore.instance.collection("users").document(userid).get().then((userdata){
        try {
          List<dynamic> userbookinglist = userdata.data['mybookinglist'];
          List<RideData> ridedata=new List();
          if(userbookinglist.length>0){


          for(int i=0;i<userbookinglist.length;i++)
          {
            try {
              String bookingid = userbookinglist[i].toString();
              Firestore.instance.collection('bookingrequest')
                  .document(bookingid)
                  .get()
                  .then(
                      (bookingdata) {
                    RideData rdata = RideData.documentSnapShot(bookingdata);
                    ridedata.add(rdata);
                    var length=ridedata.length;
                    if(bookingdata.data['booking_status']=="accepted"||bookingdata.data['booking_status']=="running"||bookingdata.data['booking_status']=="pending"){

                    }
                    else{
                      ridelist.add(rdata);
                    }


                    progressdialog.dismiss();
                    setState(() {
                      mainview=true;
                    });
                    /*if( ridedata.length==userbookinglist.length){

                      setState(() {
                        mainview=true;
                      });
                    }*/



                  });
            }
            catch(e){
              progressdialog.hide();

              print(e);
            }


          }}else{
            progressdialog.hide();
            showDialog(barrierDismissible: false,
                context: context,
                builder: (_) => GeneralMessageDialogBox(Message: "No trip found",
                ));
          }




          //var jj = userbookinglist.length;






          //// NOW GET EVERY BOOKINGDATA

        }
        catch(e){
          progressdialog.hide();

          print(e);
        }
      });





    }catch(e){
      progressdialog.hide();

      showDialog(barrierDismissible: false,
          context: context,
          builder: (_) => GeneralMessageDialogBox(Message: "Sorry there seems to be a network server Error , please try again later.",
          ));
    }
  }


  }


enum CategoryType {
  ui,
  coding,

}
class CategoryView extends StatelessWidget {

  final RideData category;
   final String usertype;

  const CategoryView(
      {Key key,
        this.category,this.usertype
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(

      child:  InkWell(onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserbookingDetail(category)),
        );


      }, child:Stack(
        children: <Widget>[
          Container(margin: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 25,
                ),
                Expanded(flex:1,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius:
                      BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width:  35.0,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Align(alignment:Alignment.topLeft, child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 16),
                                  child: Text(
                                    category.bookingdate,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      letterSpacing: 0.27,
                                      color: DesignCourseAppTheme
                                          .darkerText,
                                    ),
                                  ),
                                )),

                                Align(alignment: Alignment.topLeft,child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 16, bottom: 8,top: 5),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Image
                                            .asset(
                                          'images/start ride.png',
                                          width: 20,
                                          height: 20,),
                                  Expanded(
                                    child:
                                      Text(
                                        category.from_address,
                                        textAlign: TextAlign.left,maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme
                                              .grey,
                                        )),
                                      ),],),
                                  Row(children: <Widget>[
                                    Image
                                        .asset(
                                      'images/end ride.png',
                                      width: 20,
                                      height: 20,),
                                      Expanded(
                                      child:Text(
                                        category.to_address,
                                        textAlign: TextAlign.left,maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme
                                              .grey,
                                        )),
                                      ),],),
                                      /*Text(
                                        " Vehicle No: ${category.from_address}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme
                                              .grey,
                                        ),
                                      ),
                                      Text(
                                        " Driver Name: ${category.driver_name}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme
                                              .grey,
                                        ),
                                      ),*/

                                    ],
                                  ),
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, right: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: DesignCourseAppTheme
                                              .nearlyBlue,
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(
                                                  8.0)),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              4.0),
                                          child: category.booking_status=='complete'? Text(
                                            'Completed',style: TextStyle(color:
                                          DesignCourseAppTheme
                                              .nearlyWhite,),

                                          ):category.booking_status=='cancel_by_driver'?  Text(
                                            'Canceled',style: TextStyle(color:
                                          DesignCourseAppTheme
                                              .nearlyWhite,),

                                          ):category.booking_status=='cancel_by_user'?  Text(
                                            'canceled',style: TextStyle(color:
                                          DesignCourseAppTheme
                                              .nearlyWhite,),

                                          ):SizedBox(),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: DesignCourseAppTheme
                                              .nearlyBlue,
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(
                                                  8.0)),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              4.0),
                                          child:  Text(
                                            category.distance.toStringAsFixed(2)+" km",style: TextStyle(color:
                                          DesignCourseAppTheme
                                              .nearlyWhite,),

                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: DesignCourseAppTheme
                                              .nearlyBlue,
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(
                                                  8.0)),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              4.0),
                                          child: Text(
                                            '₹ '+category.bookingpayment,style: TextStyle(color:
                                          DesignCourseAppTheme
                                              .nearlyWhite,),

                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(height: 100,width: 100,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 14, bottom: 14, left: 0),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius:
                    BorderRadius.all(Radius.circular(16.0)),

                        child: Image.network(category.driver_image,fit: BoxFit.cover,height: 70,width: 60,),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}