import 'package:nber_flutter/TRansPortFIle.dart';
import 'package:nber_flutter/designCourse/homeDesignCourse.dart';
import 'package:nber_flutter/fitnessApp/fitnessAppHomeScreen.dart';
import 'package:nber_flutter/hotelBooking/hotelHomeScreen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  Widget navigateScreen;
  String imagePath;

  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  static List<HomeList> homeList = [
    HomeList(
      imagePath: "images/vehicle-booking.png",
      navigateScreen: TransPortFile(),
    ),
    HomeList(
      imagePath: "images/food-delivery.png",
      //navigateScreen: FitnessAppHomeScreen(),
    ),
    HomeList(
      imagePath: "images/transport-service.png",
      //navigateScreen: DesignCourseHomeScreen(),
    ),
  ];
}
