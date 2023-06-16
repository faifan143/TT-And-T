import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppColors.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/providences_brain.dart';
import 'package:traveler/models/book_model.dart';
import 'package:traveler/models/trip_model.dart';
import 'package:traveler/view/widgets/reusable_button.dart';

class BookCard extends GetView<MainScreenController> {
  const BookCard({
    super.key,
    required this.bookModel,
    required this.tripModel,
  });
  final BookModel bookModel;
  final TripModel tripModel;

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return Container(
      height: !bookModel.accepted! ? 320 : 320,
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                bookModel.tripNumber!,
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
                bookModel.busNumber!,
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
                bookModel.price!,
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
                "${bookModel.seatNo!}",
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": رقم المقعد ",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                bookModel.phone!,
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": الهاتف ",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  bookModel.goTime!,
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
                  "من ${convertToArabic(bookModel.source!)} الى ${convertToArabic(bookModel.destination!)}",
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
          if (!bookModel.accepted! &&
              controller.myServices.sharedPref.getString("userMode") ==
                  "company")
            SizedBox(height: 10),
          if (!bookModel.accepted! &&
              controller.myServices.sharedPref.getString("userMode") ==
                  "company")
            Row(
              children: [
                Flexible(
                  child: ReUsableButton(
                    height: 10,
                    radius: 20,
                    text: "رفض",
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('books')
                          .doc(bookModel.id)
                          .delete();
                    },
                    colour: Colors.redAccent,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: ReUsableButton(
                    height: 10,
                    radius: 20,
                    text: "قبول",
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('books')
                          .doc(bookModel.id)
                          .update({'accepted': true});
                      List<dynamic> passengers = await FirebaseFirestore
                          .instance
                          .collection('trips')
                          .doc(tripModel.id!)
                          .get()
                          .then((value) => value.data()!['passengers']);
                      List<dynamic> bookedSeats = await FirebaseFirestore
                          .instance
                          .collection('trips')
                          .doc(tripModel.id!)
                          .get()
                          .then((value) => value.data()!['bookedSeats']);
                      if (!passengers.contains(controller.myServices.sharedPref
                          .getString("userNumber"))) {
                        passengers.add(bookModel.phone);
                        bookedSeats.add(bookModel.seatNo);
                      }
                      FirebaseFirestore.instance
                          .collection('trips')
                          .doc(tripModel.id!)
                          .update({
                        'passengers': passengers,
                        'bookedSeats': bookedSeats
                      });
                    },
                    colour: Colors.teal,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
