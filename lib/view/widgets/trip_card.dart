import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppColors.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/bus_type_brain.dart';
import 'package:traveler/view/widgets/reusable_button.dart';

class TripCard extends GetView<MainScreenController> {
  TripCard({
    super.key,
    required this.tripNumber,
    required this.driverNumber,
    required this.busNumber,
    required this.price,
    required this.goTime,
    required this.source,
    required this.destination,
    required this.started,
    required this.finished,
    required this.isAvailable,
    required this.busType,
    required this.companyName,
    required this.availableSeats,
    this.doBooking,
    this.doTrack,
  });
  final String tripNumber;
  final String driverNumber;
  final String busNumber;
  final String price;
  final String goTime;
  final String source;
  final String companyName;
  final String destination;
  final String busType;
  final String availableSeats;
  final bool started;
  final bool finished;
  final bool isAvailable;
  VoidCallback? doBooking;
  VoidCallback? doTrack;
  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return Container(
      height: 480,
      width: 380,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(0, 0),
          )
        ],
        gradient: LinearGradient(
          colors: [
            Colors.indigo,
            AppColors.gradientDarkColor,
          ],
        ),
      ),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                tripNumber,
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": رقم الرحلة",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                companyName,
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": الشركة",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                driverNumber,
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": رقم السائق",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                busNumber,
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": رقم المركبة",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                price,
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": التكلفة ",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                stringToArabic(busType),
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": نوع المركبة ",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          if (!started)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  availableSeats!,
                  style: arabicTheme.textTheme.bodyText1,
                ),
                SizedBox(width: 10),
                Text(
                  ": المقاعد المتبقية ",
                  style: arabicTheme.textTheme.headline2,
                ),
              ],
            ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  goTime,
                  style: arabicTheme.textTheme.bodyText1,
                ),
                SizedBox(width: 10),
                Text(
                  ": موعد الانطلاق",
                  style: arabicTheme.textTheme.headline2,
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "من $source الى $destination",
                  style: arabicTheme.textTheme.bodyText1,
                ),
                SizedBox(width: 10),
                Text(
                  ": الهدف و الوجهة ",
                  style: arabicTheme.textTheme.headline2,
                ),
              ],
            ),
          ),
          if (started && !finished) SizedBox(height: 10),
          if (started && !finished)
            ReUsableButton(
              height: 10,
              radius: 20,
              text: "متابعة الرحلة",
              onPressed: doTrack,
            ),
          if (isAvailable &&
              controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "user")
            SizedBox(height: 10),
          if (isAvailable &&
              controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "user")
            ReUsableButton(
              height: 10,
              radius: 20,
              text: "طلب حجز",
              onPressed: doBooking,
            ),
        ],
      ),
    );
  }
}
