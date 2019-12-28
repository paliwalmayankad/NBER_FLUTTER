import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nber_flutter/MyColors.dart';
import 'package:nber_flutter/UserInfoModel.dart';
import 'package:nber_flutter/designCourse/UpdateProfileFile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../UserInfoApi.dart';
import '../appTheme.dart';
import 'designCourseAppTheme.dart';
import 'package:toast/toast.dart';

class CourseInfoScreen extends StatefulWidget {
  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen>
    with TickerProviderStateMixin {
  final infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  var opacity1 = 0.0;
  var opacity2 = 0.0;
  bool loadpage=false;
  SharedPreferences sharedprefrences;
  Userdata userdata;
  var opacity3 = 0.0;
  ProgressDialog progressDialog;
  UserInfoApi _userinfoapi;
  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedprefrences = sp;
      progressDialog=new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
      progressDialog.style(
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
      getuserdatafromapi();

      //Toast.show(sp.getString("USERNAME"), context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
      setState(() {});
    });
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    _userinfoapi= new UserInfoApi();
    //userdata=  Userdata();



    super.initState();
  }

  void setData() async {
    animationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tempHight = (MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0);
    return Container(color:Colors.white,child:
      ListView(

        children: <Widget>[Container(color: Colors.white,child:



      loadpage ? new Container(height: 800,
              color: DesignCourseAppTheme.nearlyWhite,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.1,
                          child: Image.asset('images/nber_banner.jpg'),
                        ),
                      ],
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(height: 500,
                        decoration: BoxDecoration(
                          color: DesignCourseAppTheme.nearlyWhite,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32.0),
                              topRight: Radius.circular(32.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                                offset: Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                            child: Container( height: 1550,
                              constraints: BoxConstraints(
                                  minHeight: infoHeight,
                                  maxHeight:
                                  tempHight > infoHeight ? tempHight : infoHeight),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 32.0, left: 18, right: 16),
                                    child: Text(
                                      "${userdata.name} ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                        letterSpacing: 0.27,
                                        color: DesignCourseAppTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                  /*Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 18, right: 16),
                                    child: Text(
                                      " ${userdata.status}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        letterSpacing: 0.27,
                                        color: DesignCourseAppTheme.darkerText,
                                      ),
                                    ),
                                  ),*/
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 8, top: 16),
                                    child:Column(children: <Widget>[
                                      /// MOBILENO
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          /*  Text(
                                  "\$28.99",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),*/
                                          Container(
                                            child: Row(
                                              children: <Widget>[

                                              Image.asset('images/telephone.png'

                                      ,height: 24,width: 24,
                                    ),
                                                Text(
                                                  "${userdata.mobile}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 16,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      /// ADDRESS
                                      Container(margin: const EdgeInsets.only(top: 10), child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          /*  Text(
                                  "\$28.99",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),*/
                                          Container(
                                            child: Row(
                                              children: <Widget>[

                                                Image.asset('images/address.png'

                                                  ,height: 24,width: 24,
                                                ),
                                                Text(
                                                  "${userdata.address}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 16,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                      /// CITY
                                      Container(margin: const EdgeInsets.only(top: 10), child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          /*  Text(
                                  "\$28.99",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),*/
                                          Container(
                                            child: Row(
                                              children: <Widget>[

                                              Image.asset('images/city.png'

                                        ,height: 24,width: 24,
                                      ),
                                                Text(
                                                  "${userdata.city}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 16,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                        //// STATE
                                      Container(margin: const EdgeInsets.only(top: 10), child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          /*  Text(
                                  "\$28.99",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),*/
                                          Container(
                                            child: Row(
                                              children: <Widget>[

                                                Icon(
                                                  Icons.star,
                                                  color: DesignCourseAppTheme.nearlyBlue,
                                                  size: 24,
                                                ),
                                                Text(
                                                  "${userdata.state}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 16,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                        //// COUNTRY
                                      Container(margin: const EdgeInsets.only(top: 10), child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          /*  Text(
                                  "\$28.99",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),*/
                                          Container(
                                            child: Row(
                                              children: <Widget>[

                                                Image.asset('images/india flag_icon.png'

                                                  ,height: 24,width: 24,
                                                ),
                                                Text(
                                                  "${userdata.country}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 16,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
//// PINCODE
                                      Container(margin: const EdgeInsets.only(top: 10), child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          /*  Text(
                                  "\$28.99",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                ),*/
                                          Container(
                                            child: Row(
                                              children: <Widget>[

                                                Image.asset('images/pincode.png'

                                                  ,height: 24,width: 24,
                                                ),
                                                Text(
                                                  "${userdata.pincode}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 16,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),

                                    ],),
                                  ),
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity: opacity1,
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child:new SingleChildScrollView(scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: <Widget>[
                                          getTimeBoxUI(userdata.emergencyContactName, "Emergency Contact Name"),
                                          getTimeBoxUI(userdata.emergencyContactNumber, "Emergency Contact Number"),
                                          getTimeBoxUI(userdata.emergencyContactEmail, "Emergency Email"),
                                        ],)
                                      ),
                                    ),
                                  ),

                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity: opacity3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, bottom: 16, right: 16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          /*Container(
                                            width: 48,
                                            height: 48,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: DesignCourseAppTheme.nearlyWhite,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16.0),
                                                ),
                                                border: new Border.all(
                                                    color: DesignCourseAppTheme.grey
                                                        .withOpacity(0.2)),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: DesignCourseAppTheme.nearlyBlue,
                                                size: 28,
                                              ),
                                            ),
                                          ),*/
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: DesignCourseAppTheme.nearlyBlue,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16.0),
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: DesignCourseAppTheme
                                                          .nearlyBlue
                                                          .withOpacity(0.5),
                                                      offset: Offset(1.1, 1.1),
                                                      blurRadius: 10.0),
                                                ],
                                              ),
                                              child:InkWell(
                                                onTap: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => UpdateProfileFile(userdata),
                                                    ),
                                                  );
                                                },

                                                child: Center(
                                                child: Text(
                                                  "Update Profile",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    letterSpacing: 0.0,
                                                    color: DesignCourseAppTheme
                                                        .nearlyWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          )],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).padding.bottom,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                      right: 35,
                      child: new ScaleTransition(
                        alignment: Alignment.center,
                        scale: new CurvedAnimation(
                            parent: animationController, curve: Curves.fastOutSlowIn),
                        child: Card(
                          color: DesignCourseAppTheme.nearlyBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          elevation: 10.0,
                          child:  Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.6),
                                    offset: Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(60.0)),
                              child: userdata.image!=null?Image.network(userdata.image,fit: BoxFit.fill,):Image.asset('images/yellow_logo.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: SizedBox(
                        width: AppBar().preferredSize.height,
                        height: AppBar().preferredSize.height,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: new BorderRadius.circular(
                                AppBar().preferredSize.height),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: DesignCourseAppTheme.nearlyBlack,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),



            ) : SizedBox()

        )]));
  }



  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getuserdatafromapi() async {
    try{
      //progressDialog.show();
      /*UserInfoModel infomodels = await _userinfoapi.search(sharedprefrences.getString("USERID"),"Bearer "+sharedprefrences.getString("TOKEN"));
      String status = infomodels.status;
      if (status == "200") {
        userdata = infomodels.data;
        setState(() =>
        loadpage =
        !loadpage);
      }
      else {
        progressDialog.hide();

        Toast.show(infomodels.message,context,duration:Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);

      }*/
         //// getDATA fromFIRESTORE AND SET TO PROFILE
      
      Firestore.instance.collection('users').document(sharedprefrences.getString("USERID")).get()
      .then((data){
         /// UPDATEDATA and show

        userdata=new Userdata.map(data.data);

        /*String jj=data.data["name"].toString();
        userdata.gender=data.data['gender'];
        userdata.email=data.data['email'];
        userdata.role=data.data['role'];
        userdata.status=data.data['status'];
        userdata.mobile=data.data['mobile'];
        userdata.address=data.data['address'];
        userdata.city=data.data['city'];
        userdata.state=data.data['state'];
        userdata.country=data.data['country'];
        userdata.pincode=data.data['pincode'];
        userdata.lat=data.data['lat'];
        userdata.lon=data.data['lng'];
        userdata.mac_id=data.data['mac_id'];
       // userdata.token_id=data.data[''];
        userdata.emergencyContactName=data.data['emergency_contact_name'];
        userdata.emergencyContactNumber=data.data['emergency_contact_number'];
        userdata.emergencyContactEmail=data.data['emergency_contact_email'];*/
        setState(() =>
        loadpage =
        !loadpage);
        progressDialog.hide();
        setData();
      });
      
      

    }catch(Exception,e){
      progressDialog.hide();
      String j=e.toString();
      Toast.show("Sorry there seems to be  a network server error. please try again leter.",context,duration:Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    }
  }
  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds:2000));
    return true;
  }
}
