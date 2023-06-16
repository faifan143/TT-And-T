import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppRoutes.dart';

class DeleteTripController extends MainScreenController {
  late TextEditingController tripNumberController;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future<void> deleteTrip(String tripNumber) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Get the document reference for the trip with the given tripNumber
      final QuerySnapshot<Map<String, dynamic>> tripQuerySnapshot =
          await firestore
              .collection('trips')
              .where('tripNumber', isEqualTo: tripNumber)
              .where('companyName',
                  isEqualTo:
                      myServices.sharedPref.getString("companyName").toString())
              .get();

      if (tripQuerySnapshot.size == 1) {
        final DocumentSnapshot<Map<String, dynamic>> tripDocSnapshot =
            tripQuerySnapshot.docs.first;
        await tripDocSnapshot.reference.delete();
        print('Trip $tripNumber deleted successfully');
        Get.offAllNamed(AppRoutes.mainScreen);
      } else if (tripQuerySnapshot.size > 1) {
        print('Multiple trips found with trip number $tripNumber');
      } else {
        print('No trip found with trip number $tripNumber');
      }
    } catch (e) {
      print('Error deleting trip: $e');
    }
  }

  handleDeleteTripButton() {
    String tripNumber = tripNumberController.text.trim();
    deleteTrip(tripNumber);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tripNumberController = TextEditingController();
  }
}
