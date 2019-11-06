import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nber_flutter/TransPortFIle_Second.dart';

import 'Consts.dart';

class CustomDialog extends StatelessWidget {
  final String img_type, total_payable,your_trip,total_fare,insurance_premium,from_address,to_address;


  CustomDialog({
    @required this.img_type,
  @required this.total_payable,
    @required this.your_trip,
    @required this.total_fare,
    @required this.insurance_premium,
    @required this.from_address,
    @required this.to_address,
    @required this.onColorSelect,

  });
  final ConfirmPressed onColorSelect;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        //...top circlular image part,

        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "Total Fare:- "+total_fare,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              /// FROM ADDREASSS
              Text(
                "Pickup:-"+from_address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),

              //// TO ADDRESS
              Text(
                "Drop:-"+to_address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              /// TOTAL PAYBLE
              Text(
                "Toatal Payble:- "+total_payable,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Your Trip:-"+your_trip,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              //// INSURANCE PREMIUM
              SizedBox(height: 16.0),
              Text(
                "Insurance  Premium:-"+insurance_premium,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),






              /////// BUTTON
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    // To close the dialog
                  },
                  child: Text("Confirm Booking "),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: Colors.black26,
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }

}
typedef ConfirmPressed = void Function(Color color);