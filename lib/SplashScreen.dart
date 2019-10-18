import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyColors.dart';
import 'HomeFile.dart';
import 'Login.dart';
class SplashScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

    return SplashScreenState ();
  }




}

class SplashScreenState extends State<SplashScreen>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(decoration: BoxDecoration(color: MyColors.white,
        ), child: Center(child: Image.asset('images/yellow_logo.png',width: 200,height: 200,),)));


  }
  @override
  void initState() {
    super.initState();


    startTimeout();




  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handletimeout);


  }




  Future<void> handletimeout() async {

    SharedPreferences sharedPreferences= await SharedPreferences.getInstance() ;
    if(sharedPreferences!=null)
      if(sharedPreferences.getBool("LOGIN")==true){
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new HomeFile()),
        );
      }
      else{
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new Login()),
        );
      }




  }
}