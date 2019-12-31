import 'dart:convert';
import 'dart:typed_data';

import 'package:nber_flutter/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:nber_flutter/designCourse/courseInfoScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;
  HomeDrawer(
      {Key key, this.screenIndex, this.iconAnimationController, this.callBackIndex})
      : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  bool isuserisbooker=false;
  String username="";
  String image="";
  String userimage;
  Uint8List _bytesImage;
  bool sahredflagvalue=false;
  int selectedRadio=1;
  int _groupValue = -1;
  SharedPreferences sharedprefrences;
  @override
  void initState() {
    checkforsharedprefs();


    super.initState();
  }

  void setdDrawerListArray() {
    if(isuserisbooker==true){
      drawerList = [
        DrawerList(
          index: DrawerIndex.HOME,
          labelName: 'Home',
          //icon: new Icon(Image.asset('images/home.png',height:10,width:10)),
          isAssetsImage: true,
          imageName: 'images/home.png',

        ),
        DrawerList(
          index: DrawerIndex.yourtrip,
          labelName: 'Your Trips',
          isAssetsImage: true,
          imageName: 'images/trips.png',
        ),
        DrawerList(
          index: DrawerIndex.notifivation,
          labelName: 'Notification',
          isAssetsImage: true,
          imageName: 'images/notifaction.png',
        ),
        DrawerList(
          index: DrawerIndex.setting,
          labelName: 'Setting',
          isAssetsImage: true,
          imageName: 'images/settings.png',
        ),
        DrawerList(
          index: DrawerIndex.Driverwithnber,
          labelName: 'Driver With Nber',
          isAssetsImage: true,
          imageName: 'images/driver.png',
        ),

        DrawerList(
          index: DrawerIndex.share,
          labelName: 'share',
          isAssetsImage: true,
          imageName: 'images/share.png',
        ),
       /* DrawerList(
          index: DrawerIndex.wallet,
          labelName: 'Wallet',
          isAssetsImage: true,
          imageName: 'images/wallet.png',
        ),*/
        DrawerList(
          index: DrawerIndex.about,
          labelName: 'About Us',
          isAssetsImage: true,
          imageName: 'images/about-us.png',
        ),
        DrawerList(
          index: DrawerIndex.support,
          labelName: 'Support',
          isAssetsImage: true,
          imageName: 'images/support.png',
        ),
        DrawerList(
          index: DrawerIndex.signout,
          labelName: 'Sign Out',
          isAssetsImage: true,
          imageName: 'images/sign-out.png',
        ),
      ];
    }
    else{
      drawerList = [
        DrawerList(
          index: DrawerIndex.HOME,
          labelName: 'Home',
          //icon: new Icon(Image.asset('images/home.png',height:10,width:10)),
          isAssetsImage: true,
          imageName: 'images/home.png',

        ),
        DrawerList(
          index: DrawerIndex.yourtrip,
          labelName: 'Your Trips',
          isAssetsImage: true,
          imageName: 'images/trips.png',
        ),
        DrawerList(
          index: DrawerIndex.notifivation,
          labelName: 'Notification',
          isAssetsImage: true,
          imageName: 'images/notifaction.png',
        ),
        DrawerList(
          index: DrawerIndex.setting,
          labelName: 'Setting',
          isAssetsImage: true,
          imageName: 'images/settings.png',
        ),

        DrawerList(
          index: DrawerIndex.Showmyvehicle,
          labelName: 'Show my Vehicle',
          isAssetsImage: true,
          imageName: 'images/vehicle.png',
        ),
        DrawerList(
          index: DrawerIndex.share,
          labelName: 'share',
          isAssetsImage: true,
          imageName: 'images/share.png',
        ),
        DrawerList(
          index: DrawerIndex.wallet,
          labelName: 'Wallet',
          isAssetsImage: true,
          imageName: 'images/wallet.png',
        ),
        DrawerList(
          index: DrawerIndex.about,
          labelName: 'About Us',
          isAssetsImage: true,
          imageName: 'images/about-us.png',
        ),
        DrawerList(
          index: DrawerIndex.support,
          labelName: 'Support',
          isAssetsImage: true,
          imageName: 'images/support.png',
        ),
        DrawerList(
          index: DrawerIndex.signout,
          labelName: 'Sign Out',
          isAssetsImage: true,
          imageName: 'images/sign-out.png',
        ),
      ];
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseInfoScreen(),
                ),
              );
            },
        child:  Container(



            width: double.infinity,
            padding: EdgeInsets.only(top: 40.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return new ScaleTransition(
                        scale: new AlwaysStoppedAnimation(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: new AlwaysStoppedAnimation(Tween(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 100,
                            width: 100,
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
                              child: userimage!=null?Image.network(userimage,fit: BoxFit.fill,):Image.asset('images/yellow_logo.png'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
          SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (context, index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
         /* sahredflagvalue ? Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "Mode OF Payment For Booking",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                ),textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              /// FOR BANK NAME
              Row(children:<Widget>[
                Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  activeColor: Colors.black,

                  onChanged: (val) {
                    print("Radio $val");
                    setSelectedRadio(val);
                  },
                ),Text('COD',style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,),),

                Radio(
                  value: 2,

                  groupValue: selectedRadio,

                  activeColor: Colors.black,
                  onChanged: (val) {
                    print("Radio $val");
                    setSelectedRadio(val);
                  },
                ),Text('Online',style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,),),
              ]),

              Padding(padding: const EdgeInsets.only(top:10),),
              /// FOR BANK ACCOUNT NO





              /////// BUTTON
              SizedBox(height: 24.0),
            *//*  Row(children:<Widget>[

                Expanded(

                  child: FlatButton(
                    onPressed: () {

                      if(paymentmodefinal==null||paymentmodefinal.length<2){
                        Toast.show("Please Select any Paymnet Mode",context,duration:Toast.LENGTH_SHORT,gravity:Toast.BOTTOM);
                      }
                      else {

                      }




                      // To close the dialog
                    },
                    child: Text("Submit",style: TextStyle(
                        fontSize: 16.0,fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ])*//*

            ],
          ) : SizedBox(),*/
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : null),
                        )
                      : new Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  new Text(
                    listData.labelName,
                    style: new TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return new Transform(
                        transform: new Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  void navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      if(selectedRadio==1){
        sharedprefrences.setString("PAYMENTMODE", "COD");
      }
      else{
        sharedprefrences.setString("PAYMENTMODE", "ONLINE");
      }
    });
  }
  Future<Null> checkforsharedprefs() async  {
    sharedprefrences = await SharedPreferences.getInstance();
    username=sharedprefrences.getString("USERNAME");
    userimage=sharedprefrences.getString("IMAGE");
    

   /* String _imgString = sharedprefrences.getString("IMAGE");

    _bytesImage = Base64Decoder().convert(_imgString);
    */
    
    if(sharedprefrences.getString("ROLE")=="driver"){
      isuserisbooker=false;


    }
    else
    {
      setState(() =>
      sahredflagvalue =
      !sahredflagvalue);
      isuserisbooker=true;
      if(sharedprefrences.getString("PAYMENTMODE")!=null) {
        if (sharedprefrences.getString("PAYMENTMODE") == "COD") {
          selectedRadio = 1;
        }
        else {
          selectedRadio = 2;
        }
      }
      else{
        selectedRadio = 1;
        sharedprefrences.setString("PAYMENTMODE", "COD");
      }


    }
    setdDrawerListArray();
  }
}

enum DrawerIndex {


  HOME,
  yourtrip,
  notifivation,
  share,
  setting,
  Driverwithnber,
  Showmyvehicle,
  wallet,
  about,
  support,
  signout,

}

class DrawerList {
  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;

  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

}
