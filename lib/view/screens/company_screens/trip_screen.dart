import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/providences_brain.dart';
import 'package:traveler/models/trip_model.dart';
import 'package:traveler/view/screens/company_screens/trip_screens/map_tracking.dart';
import 'package:traveler/view/screens/company_screens/trip_screens/seats_view.dart';
import 'package:traveler/view/widgets/trip_card.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      controller.checkAndUpdateStartedField();
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (controller.myServices.sharedPref
                          .getString("userMode")
                          .toString() ==
                      "company")
                    IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.addTrip);
                        },
                        icon: const Icon(
                          IconlyBroken.plus,
                          size: 30,
                          color: Colors.white,
                        )),
                  if (controller.myServices.sharedPref
                          .getString("userMode")
                          .toString() ==
                      "company")
                    IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.deleteTrip);
                        },
                        icon: const Icon(
                          IconlyBroken.delete,
                          size: 30,
                          color: Colors.white,
                        )),
                  if (controller.myServices.sharedPref
                          .getString("userMode")
                          .toString() ==
                      "company")
                    IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.editTrip);
                        },
                        icon: const Icon(
                          IconlyBroken.edit_square,
                          size: 30,
                          color: Colors.white,
                        )),
                  const Spacer(),
                  Text(
                    "ادارة الرحلات",
                    style: arabicTheme.textTheme.headline1,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                "الرحلات التالية",
                style: arabicTheme.textTheme.headline1,
              ),
              const SizedBox(height: 10),
              if (controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "user")
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trips')
                      .where('started', isEqualTo: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'هناك خطأ ما',
                        style: arabicTheme.textTheme.bodyText1,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: 250,
                            child: Center(
                              child: Text(
                                "لا يوجد رحلات",
                                style: arabicTheme.textTheme.bodyText1,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 420.0,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    TripModel tripModel =
                                        TripModel.fromJson(data);

                                    final df = DateFormat('yyyy/MM/dd, hh:mm');
                                    String formattedDate = df.format(
                                        DateTime.parse(tripModel.goTime!));
                                    log(formattedDate);

                                    return Row(
                                      children: [
                                        if (snapshot.data!.docs.length <= 1)
                                          const SizedBox(width: 30),
                                        SizedBox(
                                          width: 350.0,
                                          child: TripCard(
                                            tripNumber: tripModel.tripNumber!,
                                            driverNumber:
                                                tripModel.driverNumber!,
                                            busNumber: tripModel.busNumber!,
                                            price: tripModel.price!,
                                            goTime: formattedDate,
                                            source: convertToArabic(
                                                tripModel.source!),
                                            destination: convertToArabic(
                                                tripModel.destination!),
                                            started: tripModel.started!,
                                            isAvailable: true,
                                            doBooking: () async {
                                              Get.to(SeatsView(
                                                tripModel: tripModel,
                                                bookedSeats:
                                                    tripModel.bookedSeats!,
                                                seatsNumber: int.parse(
                                                    tripModel.seatsNumber!),
                                              ));
                                            },
                                            busType: tripModel.busType!,
                                            availableSeats: (int.parse(tripModel
                                                        .seatsNumber!) -
                                                    tripModel
                                                        .bookedSeats!.length)
                                                .toString(),
                                            finished: false,
                                            companyName: tripModel.companyName!,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    );
                                  })
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          );
                  },
                ),
              if (controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "company")
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trips')
                      .where('started', isEqualTo: false)
                      .where('companyName',
                          isEqualTo: controller.myServices.sharedPref
                              .getString("companyName"))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'هناك خطأ ما',
                        style: arabicTheme.textTheme.bodyText1,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: 250,
                            child: Center(
                                child: Text(
                              "لا يوجد رحلات",
                              style: arabicTheme.textTheme.bodyText1,
                            )),
                          )
                        : SizedBox(
                            height: 360.0,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    TripModel tripModel =
                                        TripModel.fromJson(data);

                                    final df = DateFormat('yyyy/MM/dd, hh:mm');
                                    String formattedDate = df.format(
                                        DateTime.parse(tripModel.goTime!));
                                    // Parse the given date-time string
                                    DateTime givenDateTime =
                                        DateTime.parse(tripModel.goTime!);
                                    // Get the current date and time
                                    DateTime currentDateTime = DateTime.now();
                                    // Compare the two date-time objects
                                    if (givenDateTime
                                        .isBefore(currentDateTime)) {
                                      FirebaseFirestore.instance
                                          .collection('trips')
                                          .doc(
                                              "${tripModel.companyName}-${tripModel.tripNumber}")
                                          .update({
                                        "finished": true,
                                        "started": true,
                                      });
                                    }
                                    return Row(
                                      children: [
                                        if (snapshot.data!.docs.length <= 1)
                                          const SizedBox(width: 30),
                                        SizedBox(
                                          width: 350.0,
                                          child: TripCard(
                                            tripNumber: tripModel.tripNumber!,
                                            driverNumber:
                                                tripModel.driverNumber!,
                                            busNumber: tripModel.busNumber!,
                                            price: tripModel.price!,
                                            goTime: formattedDate,
                                            source: convertToArabic(
                                                tripModel.source!),
                                            destination: convertToArabic(
                                                tripModel.destination!),
                                            started: false,
                                            isAvailable: true,
                                            doBooking: () async {
                                              Get.to(SeatsView(
                                                tripModel: tripModel,
                                                bookedSeats:
                                                    tripModel.bookedSeats!,
                                                seatsNumber: int.parse(
                                                    tripModel.seatsNumber!),
                                              ));
                                            },
                                            busType: tripModel.busType!,
                                            availableSeats: (int.parse(tripModel
                                                        .seatsNumber!) -
                                                    tripModel
                                                        .bookedSeats!.length)
                                                .toString(),
                                            finished: false,
                                            companyName: tripModel.companyName!,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    );
                                  })
                                  .toList()
                                  .cast(),
                            ),
                          );
                  },
                ),
              Text(
                "الرحلات الحالية",
                style: arabicTheme.textTheme.headline1,
              ),
              const SizedBox(height: 10),
              if (controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "user")
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trips')
                      .where('started', isEqualTo: true)
                      .where('finished', isEqualTo: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'هناك خطأ ما',
                        style: arabicTheme.textTheme.bodyText1,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: 300,
                            child: Center(
                                child: Text(
                              "لا يوجد رحلات",
                              style: arabicTheme.textTheme.bodyText1,
                            )),
                          )
                        : SizedBox(
                            height: 370.0,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    TripModel tripModel =
                                        TripModel.fromJson(data);

                                    final df = DateFormat('yyyy/MM/dd, hh:mm');
                                    String formattedDate = df.format(
                                        DateTime.parse(tripModel.goTime!));
                                    return Row(
                                      children: [
                                        if (snapshot.data!.docs.length <= 1)
                                          const SizedBox(width: 30),
                                        SizedBox(
                                          width: 350.0,
                                          child: TripCard(
                                            tripNumber: tripModel.tripNumber!,
                                            driverNumber:
                                                tripModel.driverNumber!,
                                            busNumber: tripModel.busNumber!,
                                            price: tripModel.price!,
                                            goTime: formattedDate,
                                            source: convertToArabic(
                                                tripModel.source!),
                                            destination: convertToArabic(
                                                tripModel.destination!),
                                            started: true,
                                            isAvailable: false,
                                            doTrack: () {
                                              controller
                                                  .getBusLocationAfterDelay(
                                                      tripModel.locationData!);

                                              print("\n\n\n");
                                              print("location data is :");
                                              print(tripModel.locationData!);
                                              print("\n\n\n");
                                              Get.to(MapTracking(
                                                locationData:
                                                    tripModel.locationData!,
                                              ));
                                            },
                                            availableSeats: (int.parse(tripModel
                                                        .seatsNumber!) -
                                                    tripModel
                                                        .bookedSeats!.length)
                                                .toString(),
                                            busType: tripModel.busType!,
                                            finished: false,
                                            companyName: tripModel.companyName!,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    );
                                  })
                                  .toList()
                                  .cast(),
                            ),
                          );
                  },
                ),
              if (controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "company")
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trips')
                      .where('started', isEqualTo: true)
                      .where('finished', isEqualTo: false)
                      .where('companyName',
                          isEqualTo: controller.myServices.sharedPref
                              .getString("companyName"))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'هناك خطأ ما',
                        style: arabicTheme.textTheme.bodyText1,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: 300,
                            child: Center(
                                child: Text(
                              "لا يوجد رحلات",
                              style: arabicTheme.textTheme.bodyText1,
                            )),
                          )
                        : SizedBox(
                            height: 370.0,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    TripModel tripModel =
                                        TripModel.fromJson(data);

                                    final df = DateFormat('yyyy/MM/dd, hh:mm');
                                    String formattedDate = df.format(
                                        DateTime.parse(tripModel.goTime!));
                                    return Row(
                                      children: [
                                        if (snapshot.data!.docs.length <= 1)
                                          const SizedBox(width: 30),
                                        SizedBox(
                                          width: 350.0,
                                          child: TripCard(
                                            tripNumber: tripModel.tripNumber!,
                                            driverNumber:
                                                tripModel.driverNumber!,
                                            busNumber: tripModel.busNumber!,
                                            price: tripModel.price!,
                                            goTime: formattedDate,
                                            source: convertToArabic(
                                                tripModel.source!),
                                            destination: convertToArabic(
                                                tripModel.destination!),
                                            started: true,
                                            isAvailable: false,
                                            doTrack: () {
                                              controller
                                                  .getBusLocationAfterDelay(
                                                      tripModel.locationData!);

                                              print("\n\n\n");
                                              print("location data is :");
                                              print(tripModel.locationData!);
                                              print("\n\n\n");
                                              Get.to(MapTracking(
                                                locationData:
                                                    tripModel.locationData!,
                                              ));
                                            },
                                            availableSeats: (int.parse(tripModel
                                                        .seatsNumber!) -
                                                    tripModel
                                                        .bookedSeats!.length)
                                                .toString(),
                                            busType: tripModel.busType!,
                                            finished: false,
                                            companyName: tripModel.companyName!,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    );
                                  })
                                  .toList()
                                  .cast(),
                            ),
                          );
                  },
                ),
              Text(
                "الرحلات السابقة",
                style: arabicTheme.textTheme.headline1,
              ),
              const SizedBox(height: 10),
              if (controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "user")
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trips')
                      .where('started', isEqualTo: true)
                      .where('finished', isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'هناك خطأ ما',
                        style: arabicTheme.textTheme.bodyText1,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: 300,
                            child: Center(
                                child: Text(
                              "لا يوجد رحلات",
                              style: arabicTheme.textTheme.bodyText1,
                            )),
                          )
                        : SizedBox(
                            height: 310.0,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    TripModel tripModel =
                                        TripModel.fromJson(data);

                                    final df = DateFormat('yyyy/MM/dd, hh:mm');
                                    String formattedDate = df.format(
                                        DateTime.parse(tripModel.goTime!));
                                    return Row(
                                      children: [
                                        if (snapshot.data!.docs.length <= 1)
                                          const SizedBox(width: 30),
                                        SizedBox(
                                          width: 350.0,
                                          child: TripCard(
                                            tripNumber: tripModel.tripNumber!,
                                            driverNumber:
                                                tripModel.driverNumber!,
                                            busNumber: tripModel.busNumber!,
                                            price: tripModel.price!,
                                            goTime: formattedDate,
                                            source: convertToArabic(
                                                tripModel.source!),
                                            destination: convertToArabic(
                                                tripModel.destination!),
                                            started: true,
                                            isAvailable: false,
                                            busType: tripModel.busType!,
                                            availableSeats: (int.parse(tripModel
                                                        .seatsNumber!) -
                                                    tripModel
                                                        .bookedSeats!.length)
                                                .toString(),
                                            finished: true,
                                            companyName: tripModel.companyName!,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    );
                                  })
                                  .toList()
                                  .cast(),
                            ),
                          );
                  },
                ),
              if (controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "company")
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trips')
                      .where('started', isEqualTo: true)
                      .where('finished', isEqualTo: true)
                      .where('companyName',
                          isEqualTo: controller.myServices.sharedPref
                              .getString("companyName"))
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'هناك خطأ ما',
                        style: arabicTheme.textTheme.bodyText1,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: 300,
                            child: Center(
                                child: Text(
                              "لا يوجد رحلات",
                              style: arabicTheme.textTheme.bodyText1,
                            )),
                          )
                        : SizedBox(
                            height: 310.0,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    TripModel tripModel =
                                        TripModel.fromJson(data);

                                    final df = DateFormat('yyyy/MM/dd, hh:mm');
                                    String formattedDate = df.format(
                                        DateTime.parse(tripModel.goTime!));
                                    return Row(
                                      children: [
                                        if (snapshot.data!.docs.length <= 1)
                                          const SizedBox(width: 30),
                                        SizedBox(
                                          width: 350.0,
                                          child: TripCard(
                                            tripNumber: tripModel.tripNumber!,
                                            driverNumber:
                                                tripModel.driverNumber!,
                                            busNumber: tripModel.busNumber!,
                                            price: tripModel.price!,
                                            goTime: formattedDate,
                                            source: convertToArabic(
                                                tripModel.source!),
                                            destination: convertToArabic(
                                                tripModel.destination!),
                                            started: true,
                                            isAvailable: false,
                                            busType: tripModel.busType!,
                                            availableSeats: (int.parse(tripModel
                                                        .seatsNumber!) -
                                                    tripModel
                                                        .bookedSeats!.length)
                                                .toString(),
                                            finished: true,
                                            companyName: tripModel.companyName!,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    );
                                  })
                                  .toList()
                                  .cast(),
                            ),
                          );
                  },
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      );
    });
  }
}
