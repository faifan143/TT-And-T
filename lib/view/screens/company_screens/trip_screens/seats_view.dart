import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/company_controllers/booking_controller.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/intermittent_check.dart';
import 'package:traveler/models/trip_model.dart';
import 'package:traveler/view/widgets/mini_bus.dart';
import 'package:traveler/view/widgets/normal_bus.dart';
import 'package:traveler/view/widgets/vip_bus.dart';

class SeatsView extends StatelessWidget {
  const SeatsView(
      {Key? key,
      required this.tripModel,
      required this.bookedSeats,
      required this.seatsNumber})
      : super(key: key);
  final TripModel tripModel;
  final int seatsNumber;
  final List<dynamic> bookedSeats;
  @override
  Widget build(BuildContext context) {
    List<int> intermittentSequence = [];
    List<int> notAnIntermittentSequence = [];
    List<int> multi3 = [];
    List<int> notAMulti3 = [];
    for (int i = 1; i <= seatsNumber; i++) {
      if (isInIntermittentSequence(i)) {
        intermittentSequence.add(i);
      } else {
        notAnIntermittentSequence.add(i);
      }
    }
    for (int i = 1; i <= seatsNumber; i++) {
      if (i % 3 == 0) {
        multi3.add(i);
      } else {
        notAMulti3.add(i);
      }
    }
    Get.put(BookingController());
    print(bookedSeats);
    return GetBuilder<BookingController>(builder: (controller) {
      return Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/gradientBackground.jpg', // replace with your image path
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
                top: 40,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "مقعد",
                      style: arabicTheme.textTheme.headline1,
                    ),
                    SizedBox(width: 15),
                    Text(
                      "${seatsNumber - bookedSeats.length}",
                      style: arabicTheme.textTheme.headline1,
                    ),
                    SizedBox(width: 15),
                    Text(
                      ": المقاعد المتاحة",
                      style: arabicTheme.textTheme.headline1,
                    ),
                  ],
                )),
            SafeArea(
              child: tripModel.busType == "normal"
                  ? NormalBus(
                      seatsNo: seatsNumber,
                      intermittentSequence: intermittentSequence,
                      notAnIntermittentSequence: notAnIntermittentSequence,
                      tripModel: tripModel,
                      bookedSeats: bookedSeats,
                    )
                  : (tripModel.busType == "vip"
                      ? VipBus(
                          seatsNo: seatsNumber,
                          multi3: multi3,
                          notAMulti3: notAMulti3,
                          tripModel: tripModel,
                          bookedSeats: bookedSeats,
                        )
                      : MiniBus(
                          bookedSeats: bookedSeats,
                          seatsNo: seatsNumber,
                          tripModel: tripModel,
                        )),
            ),
          ],
        ),
      );
    });
  }
}
