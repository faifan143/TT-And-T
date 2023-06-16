import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/models/trip_model.dart';

class BookingController extends MainScreenController {
  late TextEditingController acceptedController;
  late TextEditingController pendingController;

  Future<bool> isPhoneInPassengers(
      {required String phone, required String tripId}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('trips')
              .where('id', isEqualTo: tripId)
              .get();

      final List<dynamic> passengers =
          querySnapshot.docs.first.data()['passengers'];
      return passengers.contains(phone);
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> isBookingExists(
      {required String phone, required String tripId}) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('books')
            .where('phone', isEqualTo: phone)
            .where('tripId', isEqualTo: tripId)
            .get();
    return querySnapshot.docs.isNotEmpty;
  }

  late int seatNo;
  Future<void> doBooking({required TripModel tripModel}) async {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    bool duplicated = await isPhoneInPassengers(
        phone: userModel.phone!, tripId: tripModel.id!);
    bool bookExists =
        await isBookingExists(phone: userModel.phone!, tripId: tripModel.id!);
    try {
      // Create a document reference with a unique ID in the 'books' collection
      final DocumentReference<Map<String, dynamic>> bookDocRef =
          firestore.collection('books').doc();

      final df = DateFormat('yyyy/MM/dd, hh:mm');
      String formattedDate = df.format(DateTime.parse(tripModel.goTime!));
      // Set the document data with the provided email and phone fields

      if (duplicated == false && bookExists == false) {
        await bookDocRef.set({
          'email': userModel.email,
          'phone': userModel.phone,
          'tripNumber': tripModel.tripNumber,
          'busNumber': tripModel.busNumber,
          'price': tripModel.price,
          'goTime': formattedDate,
          'source': tripModel.source,
          'destination': tripModel.destination,
          'accepted': false,
          'tripId': tripModel.id,
          'id': bookDocRef.id,
          'seatNo': seatNo,
          'companyName': tripModel.companyName,
        });
      }
      Get.offAllNamed(AppRoutes.mainScreen);
      print('Booking created successfully');
    } catch (e) {
      // Handle any errors that occur during the operation
      print('Error creating booking: $e');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    acceptedController = TextEditingController();
    pendingController = TextEditingController();
  }
}
