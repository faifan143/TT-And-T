import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/classes/bus_type.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/functions/bus_type_brain.dart';

class BussesController extends MainScreenController {
  List<BusType> busTypes = [BusType.normal, BusType.mini, BusType.vip];
  BusType selectedBusType = BusType.normal;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> deleteFormKey = GlobalKey<FormState>();
  late TextEditingController busNumberController;
  late TextEditingController seatsNumberController;
  late TextEditingController deleteBusNumberController;

  Future<void> createBus({
    required String busType,
    required String seatsNumber,
    required String busNumber,
  }) async {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a document reference with the user's phone number as the document ID
    final DocumentReference<Map<String, dynamic>> busDocRef =
        firestore.collection('busses').doc(busNumber);

    try {
      // Check if the user document already exists
      final DocumentSnapshot<Map<String, dynamic>> busDocSnapshot =
          await busDocRef.get();

      if (!busDocSnapshot.exists) {
        // Create the user document if it doesn't already exist
        await busDocRef.set({
          'busType': busType,
          'seatsNumber': seatsNumber,
          'busNumber': busNumber,
          'busy': false,
          'passengers': '0'
        });
        print('trips created successfully');
        Get.offAllNamed(AppRoutes.mainScreen);
      } else {
        print('trip already exists');
      }
    } catch (e) {
      // Handle any errors that occur during the operation
      print('Error creating trip: $e');
    }
  }

  handleAddBusButton() {
    String seatsNumber = seatsNumberController.text.trim();
    String busNumber = busNumberController.text.trim();
    String busType = enumToString(selectedBusType);
    createBus(
      busType: busType,
      seatsNumber: seatsNumber,
      busNumber: busNumber,
    );
  }

  Future<void> deleteBus(String busNumber) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Get the document reference for the trip with the given tripNumber
      final QuerySnapshot<Map<String, dynamic>> busQuerySnapshot =
          await firestore
              .collection('busses')
              .where('busNumber', isEqualTo: busNumber)
              .get();

      if (busQuerySnapshot.size == 1) {
        final DocumentSnapshot<Map<String, dynamic>> busDocSnapshot =
            busQuerySnapshot.docs.first;
        await busDocSnapshot.reference.delete();
        print('bus $busNumber deleted successfully');
        Get.offAllNamed(AppRoutes.mainScreen);
      } else if (busQuerySnapshot.size > 1) {
        print('Multiple busses found with bus number $busNumber');
      } else {
        print('No bus found with bus number $busNumber');
      }
    } catch (e) {
      print('Error deleting bus: $e');
    }
  }

  handleDeleteTripButton() {
    String busNumber = deleteBusNumberController.text.trim();
    deleteBus(busNumber);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    busNumberController = TextEditingController();
    seatsNumberController = TextEditingController();
    deleteBusNumberController = TextEditingController();
  }
}
