import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:traveler/controllers/company_controllers/booking_controller.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/models/book_model.dart';
import 'package:traveler/models/trip_model.dart';
import 'package:traveler/view/widgets/book_card.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key}) : super(key: key);

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
                    "ادارة الحجوزات",
                    style: arabicTheme.textTheme.headline1,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                "حجوزات معلقة",
                style: arabicTheme.textTheme.headline1,
              ),
              ReusableFormField(
                onChange: (p0) => controller.refresh(),
                isPassword: false,
                icon: const Icon(IconlyBroken.call),
                checkValidate: (value) {
                  return validator(controller.pendingController.text.trim(), 10,
                      13, "phone");
                },
                controller: controller.pendingController,
                keyType: TextInputType.number,
                hint: "أدخل رقم الهاتف",
              ),
              const SizedBox(height: 10),
              if (controller.pendingController.text.isNotEmpty)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('books')
                      .where('accepted', isEqualTo: false)
                      .where('companyName',
                          isEqualTo: controller.myServices.sharedPref
                              .getString("companyName")
                              .toString())
                      .where('phone',
                          isEqualTo: controller.pendingController.text.trim())
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
              if (controller.pendingController.text.isEmpty)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('books')
                      .where('accepted', isEqualTo: false)
                      .where('companyName',
                          isEqualTo: controller.myServices.sharedPref
                              .getString("companyName")
                              .toString())
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
                            height: 330.0,
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
              ReusableFormField(
                isPassword: false,
                icon: const Icon(IconlyBroken.call),
                checkValidate: (value) {
                  return validator(controller.acceptedController.text.trim(),
                      10, 13, "phone");
                },
                controller: controller.acceptedController,
                keyType: TextInputType.number,
                hint: "أدخل رقم الهاتف",
              ),
              const SizedBox(height: 10),
              if (controller.acceptedController.text.isNotEmpty)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('books')
                      .where('accepted', isEqualTo: true)
                      .where('companyName',
                          isEqualTo: controller.myServices.sharedPref
                              .getString("companyName")
                              .toString())
                      .where('phone',
                          isEqualTo: controller.acceptedController.text.trim())
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
                            height: 220.0,
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
                                      child: Container(
                                        margin: EdgeInsets.only(right: 8),
                                        child: BookCard(
                                          bookModel: bookModel,
                                          tripModel: TripModel.fromJson(
                                              jsonDataList[0]),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          );
                  },
                ),
              if (controller.acceptedController.text.isEmpty)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('books')
                      .where('accepted', isEqualTo: true)
                      .where('companyName',
                          isEqualTo: controller.myServices.sharedPref
                              .getString("companyName")
                              .toString())
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
                                      child: Container(
                                        margin: EdgeInsets.only(right: 8),
                                        child: BookCard(
                                          bookModel: bookModel,
                                          tripModel: TripModel.fromJson(
                                              jsonDataList[0]),
                                        ),
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
