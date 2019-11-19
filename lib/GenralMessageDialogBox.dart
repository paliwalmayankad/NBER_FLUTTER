import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralMessageDialogBox extends StatefulWidget {
  final String Message;
  const GeneralMessageDialogBox({Key key, this.Message}) : super(key: key);
  @override
  State<StatefulWidget> createState() => GeneralMessageDialogBoxState();

}

class GeneralMessageDialogBoxState extends State<GeneralMessageDialogBox>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              height: 180.0,

              decoration: ShapeDecoration(
                  color: Color.fromRGBO(41, 167, 77, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, left: 20.0, right: 20.0),
                        child: Text(
                          widget.Message,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      )),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(00.0),
                            child: ButtonTheme(
                                height: 35.0,
                                minWidth: 110.0,
                                child: RaisedButton(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Colors.white.withAlpha(40),
                                  child: Text(
                                    'Ok',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.of(context).pop();
                                     /* Route route = MaterialPageRoute(
                                          builder: (context) => LoginScreen());*/
                                      //Navigator.pushReplacement(context, route);
                                    });
                                  },
                                )),
                          ),
                          /*Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                              child:  ButtonTheme(
                                  height: 35.0,
                                  minWidth: 110.0,
                                  child: false?RaisedButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0)),
                                    splashColor: Colors.white.withAlpha(40),
                                    child: Text(
                                      'Cancel',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        *//* Route route = MaterialPageRoute(
                                          builder: (context) => LoginScreen());
                                      Navigator.pushReplacement(context, route);
                                   *//* });
                                    },
                                  ):SizedBox.fromSize())
                          ),*/
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
}