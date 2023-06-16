import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:traveler/controllers/company_controllers/booking_controller.dart';
import 'package:traveler/core/constants/AppColors.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/models/trip_model.dart';

class SeatCard extends GetView<BookingController> {
  const SeatCard({
    Key? key,
    required this.bookedSeats,
    required this.tripModel,
    required this.index,
  }) : super(key: key);

  final int index;
  final TripModel tripModel;
  final List<dynamic> bookedSeats;
  @override
  Widget build(BuildContext context) {
    Get.put(BookingController());
    return InkWell(
      onTap: () {
        if (!bookedSeats.contains(index)) {
          Alert(
            context: context,
            type: AlertType.warning,
            title: "حجز",
            desc: "هل تريد حجز هذا المقعد ؟",
            buttons: [
              DialogButton(
                onPressed: () => Navigator.pop(context),
                gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.redAccent]),
                child: const Text(
                  "لا",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              DialogButton(
                onPressed: () {
                  controller.seatNo = index;
                  controller.doBooking(tripModel: tripModel);
                  Get.offAllNamed(AppRoutes.mainScreen);
                },
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(0, 179, 134, 1.0),
                  Colors.greenAccent,
                ]),
                child: const Text(
                  "نعم",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ).show();
        }
      },
      child: Container(
        height: 50,
        width: 50,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [
            // Colors.deepPurple,
            AppColors.gradientDarkColor,
            AppColors.buttonColor,
          ]),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 0),
                spreadRadius: 2,
                blurRadius: 2,
                color: Colors.black38),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(bookedSeats.contains(index)
                ? "assets/images/seat-red.png"
                : "assets/images/seat-green.png"),
            Text(
              "$index",
              style: arabicTheme.textTheme.bodyText1!.copyWith(
                  height: 2,
                  decorationThickness: 2,
                  decorationColor: Colors.red,
                  decoration: bookedSeats.contains(index)
                      ? TextDecoration.lineThrough
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}
