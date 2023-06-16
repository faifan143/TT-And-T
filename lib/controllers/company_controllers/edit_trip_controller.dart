import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/models/bus_model.dart';

class EditTripController extends MainScreenController {
  late TextEditingController driverNumberController;
  late TextEditingController tripNumberController;
  late TextEditingController busNumberController;
  late TextEditingController priceController;
  final formState = GlobalKey<FormState>();
  final editFormState = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  String dateHours = "";
  String dateMinutes = "";
  bool showDateTime = false;
  Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
  Future<TimeOfDay?> pickTime(BuildContext context) {
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
  }

  Future<void> searchTrip(String tripNumber) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Get the document reference for the trip with the given tripNumber
      final QuerySnapshot<Map<String, dynamic>> tripQuerySnapshot =
          await firestore
              .collection('trips')
              .where('tripNumber', isEqualTo: tripNumber)
              .get();

      if (tripQuerySnapshot.size == 1) {
        final DocumentSnapshot<Map<String, dynamic>> tripDocSnapshot =
            tripQuerySnapshot.docs.first;

        driverNumberController.text = tripDocSnapshot.get('driverNumber');
        busNumberController.text = tripDocSnapshot.get('busNumber');
        priceController.text = tripDocSnapshot.get('price');
        driverNumberController.text = tripDocSnapshot.get('driverNumber');
        dateTime = DateTime.parse(tripDocSnapshot.get('goTime'));
        print('Trip $tripNumber found successfully');
        showDateTime = true;
        update();
      } else if (tripQuerySnapshot.size > 1) {
        print('Multiple trips found with trip number $tripNumber');
      } else {
        print('No trip found with trip number $tripNumber');
      }
    } catch (e) {
      print('Error deleting trip: $e');
    }
  }

  handleSearchTripButton() {
    String tripNumber = tripNumberController.text.trim();
    searchTrip(tripNumber);
  }

  Future<void> editTrip({
    required String driverNumber,
    required String tripNumber,
    required String busNumber,
    required DateTime goTime,
    required String price,
  }) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Get the document reference for the trip with the given tripNumber
      final QuerySnapshot<Map<String, dynamic>> tripQuerySnapshot =
          await firestore
              .collection('trips')
              .where('tripNumber', isEqualTo: tripNumber)
              .get();

      if (tripQuerySnapshot.size == 1) {
        final DocumentSnapshot<Map<String, dynamic>> tripDocSnapshot =
            tripQuerySnapshot.docs.first;
        await tripDocSnapshot.reference.update({
          'driverNumber': driverNumber,
          'busNumber': busNumber,
          'price': price,
          'goTime': goTime,
        });
        print('Trip $tripNumber updated successfully');
        Get.offAllNamed(AppRoutes.mainScreen);
      } else if (tripQuerySnapshot.size > 1) {
        print('Multiple trips found with trip number $tripNumber');
      } else {
        print('No trip found with trip number $tripNumber');
      }
    } catch (e) {
      print('Error updating trip: $e');
    }
  }

  handleEditTripButton() {
    String driverNumber = driverNumberController.text.trim();
    String tripNumber = tripNumberController.text.trim();
    String busNumber = selectedBus;
    DateTime goTime = dateTime;
    String price = priceController.text.trim();
    editTrip(
        driverNumber: driverNumber,
        tripNumber: tripNumber,
        busNumber: busNumber,
        goTime: goTime,
        price: price);
  }

  String selectedBus = "";

  List<String> availableBuses = [];
  Future<void> getAvailableBuses() async {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a query for the 'busses' collection with the specified filters
    final Query<Map<String, dynamic>> busQuery =
        firestore.collection('busses').where('busy', isEqualTo: false);

    try {
      // Get all documents from the 'busses' collection that match the query
      final QuerySnapshot<Map<String, dynamic>> busQuerySnapshot =
          await busQuery.get();
      print(busQuerySnapshot.docs.length);
      // Map each document to a BusModel object and add it to a list
      availableBuses = busQuerySnapshot.docs.map((doc) {
        BusModel busModel = BusModel.fromJson(doc.data());
        return busModel.busNumber.toString();
      }).toList();
      update();
      print(availableBuses);
    } catch (e) {
      // Handle any errors that occur during the operation
      print('Error getting all available buses: $e');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    driverNumberController = TextEditingController();
    busNumberController = TextEditingController();
    priceController = TextEditingController();
    tripNumberController = TextEditingController();
    getAvailableBuses();
  }
}
