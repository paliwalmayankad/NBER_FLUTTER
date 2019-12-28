import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ImagePickerHandler.dart';
import 'MyColors.dart';
import 'appTheme.dart';

import 'package:nber_flutter/UserInfoModel.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';

class ShowMyVechile extends StatefulWidget{
  final AnimationController animationController;

  const ShowMyVechile({Key key, this.animationController}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
  // TODO: implement createState
  return Showmyvehiclestate();
  }
  }
  class Showmyvehiclestate extends State<ShowMyVechile> with TickerProviderStateMixin,ImagePickerListener{
    AnimationController _controller;
    ImagePickerHandler imagePicker;
    File _image;
    Future<File> imageFile;
    @override
    void initState() {
      imagePicker=new ImagePickerHandler(this,_controller);
      imagePicker.init();
      // TODO: implement initState
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Scaffold(
        backgroundColor: AppTheme.white,
        body:



        SingleChildScrollView(scrollDirection: Axis.vertical,
            child:new Container( margin: const EdgeInsets.only(top:30,left: 10,bottom: 10,right: 10),


                child: new Column(children: <Widget>[

                  appBar(),

                  ////
                  Align(alignment: Alignment.topCenter,
                      child:  GestureDetector(
                        onTap: () => {
                          imagePicker.showDialog(context),},
                        child: new Center(
                          child: _image == null
                              ? new Stack(
                            children: <Widget>[

                              new Center(
                                child: new CircleAvatar(
                                  radius: 80.0,
                                  backgroundColor: const Color(0xFF778899),
                                ),
                              ),
                              new Center(
                                //child: new Image.asset("images/yellow_logo.png"),
                              ),

                            ],
                          )
                              : new Container(
                              height: 160.0,
                              width: 160.0,
                              decoration: new BoxDecoration(
                                color: const Color(0xff7c94b6),
                                image: new DecorationImage(

                                  fit: BoxFit.cover,
                                ),
                                border:
                                Border.all(color: Colors.red, width: 5.0),
                                borderRadius:
                                new BorderRadius.all(const Radius.circular(80.0)),
                              ),
                              child:showimage()),
                        ),

                        /*Container(width: 100.0,alignment: Alignment.center,
                      height: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: new Image.asset('yellow_logo.png'),
                        ),

                        color: Colors.redAccent,
                      )
                  )*/
                      )
                  )
///// FIRST NAME





            ]))
    ));
  }


  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "My Vehicle",
                  style: new TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, right: 8),
            child: Container(

            ),
          ),
        ],
      ),
    );
  }

  @override
  userImage(File _image) {
    // TODO: implement userImage
    return null;
  }
    Widget showimage() {
      return FutureBuilder<File>(
        future: imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Image.file(
              snapshot.data,
              width: 300,
              height: 300,
            );
          } else if (snapshot.error != null) {
            return const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            );
          } else {
            return const Text(
              'No Image Selected',
              textAlign: TextAlign.center,
            );
          }
        },
      );
    }
}