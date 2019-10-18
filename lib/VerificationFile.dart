
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nber_flutter/DashBoardFile.dart';
import 'package:toast/toast.dart';

import 'MyColors.dart';
class VerificationFile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  VerificationState();
  }
}
class VerificationState extends State<VerificationFile>
{
  TextEditingController mobilenumbercontroller;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobilenumbercontroller=new TextEditingController();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(child: Stack(
          children: <Widget>[

        new Column(
        children:<Widget>[
            Container(
                margin: const EdgeInsets.only(top:40,left: 10,bottom: 10,right:10),

                child: Align(alignment: Alignment.topLeft,
                    child: InkWell(
                      child: Image.asset('images/yellow_logo.png',height: 20,width: 20,)  ,
                      onTap:() {
                        Toast.show('Back',context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      },



                    ) ))

            ,



              new Container(margin: const EdgeInsets.only(left:10),
                child: Align( alignment: Alignment.topLeft,   child: Text("Enter phone number for verification",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16 ),),
                )

              ),
          new Container(
            margin: const EdgeInsets.only(left:10,top: 15),

              child: Align( alignment: Alignment.topLeft, child:Text("This number will be used to contact you and communicate all ride related details.",style: TextStyle(color: Colors.black87,fontSize: 9 ),),

              ),







          ),
          //////  THIS CONTAINER FOR NUMBER
          Padding(padding: EdgeInsets.only(top: 20.0)),
          ////// FOR PASSWORD

          new Container(   margin: const EdgeInsets.only(left: 10,right: 10),alignment: Alignment.center,padding: const EdgeInsets.all(10),
                    decoration: new BoxDecoration(color: MyColors.white,border: Border(bottom: BorderSide(color: Colors.blue,
                      width: 1.0,)),),



                    child:new  Row(children: <Widget>[
                      Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),

                      Expanded(flex: 1, child:
                      Text('+91',textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold) ),
                      ),
                      Expanded(flex: 10,child: TextFormField(controller: mobilenumbercontroller,inputFormatters: [LengthLimitingTextInputFormatter(10),], textAlign: TextAlign.start,  keyboardType: TextInputType.phone,obscureText: false,style: TextStyle(color: Colors.black,fontSize: 16), decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(20.00),borderSide: new BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(20.00)),enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0),),contentPadding: EdgeInsets.only(left:10,top:0,right:10,bottom:0),hintText: "Enter Mobile"
                      )),
                      ),
                      Expanded(flex: 1,child: Image.asset('images/yellow_logo.png',width: 20,height: 20,),),

                    ]))





        ],

            )
, Align( alignment: Alignment.bottomCenter,
           child: new Container(


              margin: const EdgeInsets.only(left: 55,right:55,top:15) ,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      offset: Offset(4, 4),
                      blurRadius: 8.0),
                ],
              ),

                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      //////
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(builder: (ctxt) => new DashBoardFile()),
                      );


                      /////


                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )


          ],





        )
    ));
  }

}