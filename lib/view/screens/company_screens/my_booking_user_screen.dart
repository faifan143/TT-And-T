import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/company_controllers/booking_controller.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/models/book_model.dart';
import 'package:traveler/models/trip_model.dart';
import 'package:traveler/view/widgets/book_card.dart';

class UserBookingScreen extends StatelessWidget {
  const UserBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BookingController());
    return GetBuilder<BookingController>(builder: (controller) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "حجوزاتي",
                    style: arabicTheme.textTheme.headline1,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                "حجوزات معلقة",
                style: arabicTheme.textTheme.headline1,
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('books')
                    .where('accepted', isEqualTo: false)
                    .where('phone',
                        isEqualTo: controller.myServices.sharedPref
                            .getString("userNumber"))
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
                      children: const [
                        Center(
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
                            "لا يوجد حجوزات معلقة",
                            style: arabicTheme.textTheme.bodyText1,
                          )),
                        )
                      : SizedBox(
                          height: 300.0,
                          width: double.infinity,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              BookModel bookModel = BookModel.fromJson(data);
                              return FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('trips')
                                    .where('tripNumber',
                                        isEqualTo: bookModel.tripNumber)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(
                                      'هناك خطأ ما',
                                      style: arabicTheme.textTheme.bodyText1,
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final List<Object?> dataList = snapshot
                                      .data!.docs
                                      .map((doc) => doc.data())
                                      .toList();

                                  List jsonDataList = dataList
                                      .map((data) =>
                                          jsonDecode(jsonEncode(data)))
                                      .toList();

                                  return SizedBox(
                                    width: 350.0,
                                    child: BookCard(
                                      bookModel: bookModel,
                                      tripModel:
                                          TripModel.fromJson(jsonDataList[0]),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        );
                },
              ),
              const SizedBox(height: 10),
              Text(
                "حجوزات مقبولة",
                style: arabicTheme.textTheme.headline1,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('books')
                    .where('accepted', isEqualTo: true)
                    .where('phone',
                        isEqualTo: controller.myServices.sharedPref
                            .getString("userNumber"))
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
                      children: const [
                        Center(
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
                            "لا يوجد حجوزات معلقة",
                            style: arabicTheme.textTheme.bodyText1,
                          )),
                        )
                      : SizedBox(
                          height: 280.0,
                          width: double.infinity,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              BookModel bookModel = BookModel.fromJson(data);
                              return FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('trips')
                                    .where('tripNumber',
                                        isEqualTo: bookModel.tripNumber)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(
                                      'هناك خطأ ما',
                                      style: arabicTheme.textTheme.bodyText1,
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final List<Object?> dataList = snapshot
                                      .data!.docs
                                      .map((doc) => doc.data())
                                      .toList();

                                  List jsonDataList = dataList
                                      .map((data) =>
                                          jsonDecode(jsonEncode(data)))
                                      .toList();

                                  return SizedBox(
                                    width: 350.0,
                                    child: BookCard(
                                      bookModel: bookModel,
                                      tripModel:
                                          TripModel.fromJson(jsonDataList[0]),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
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
