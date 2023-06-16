import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/models/bus_model.dart';

class AddTripController extends MainScreenController {
  late TextEditingController driverNumberController;
  late TextEditingController tripNumberController;
  late TextEditingController busNumberController;
  late TextEditingController priceController;
  String selectedStart = "";
  String selectedDestination = "";
  String timePickedHint = "";
  String datePickedHint = "";
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool timeDateChosen = false;

  DateTime dateTime = DateTime.now();
  String dateHours = "";
  String dateMinutes = "";
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

  Future<void> createTrip({
    required String driverNumber,
    required String tripNumber,
    required String busNumber,
    required DateTime goTime,
    required String source,
    required String destination,
    required String price,
    required String busType,
    required String companyName,
    required String seatsNumber,
  }) async {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a document reference with the user's phone number as the document ID
    final DocumentReference<Map<String, dynamic>> tripDocRef =
        firestore.collection('trips').doc("$companyName-$tripNumber");

    try {
      // Check if the user document already exists
      final DocumentSnapshot<Map<String, dynamic>> tripDocSnapshot =
          await tripDocRef.get();

      if (!tripDocSnapshot.exists) {
        // Create the user document if it doesn't already exist
        await tripDocRef.set({
          'driverNumber': driverNumber,
          'companyName': companyName,
          'id': tripDocRef.id,
          'tripNumber': tripNumber,
          'busNumber': busNumber,
          'goTime': goTime.toIso8601String(),
          'source': source,
          'destination': destination,
          'price': price,
          'started': false,
          'finished': false,
          'bookedSeats': [],
          'passengers': [],
          'busType': busType,
          'seatsNumber': seatsNumber,
          'locationData':
              "LocationData<lat: ${busCurrentLocation.latitude}, long: ${busCurrentLocation.longitude}>",
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

  handleAddTripButton() async {
    String driverNumber = driverNumberController.text.trim();
    String tripNumber = tripNumberController.text.trim();
    String busNumber = selectedBus;
    DateTime goTime = dateTime;
    String source = selectedStart;
    String destination = selectedDestination;
    String price = priceController.text.trim();
    String busType = selectedBusType;
    String seatsNumber = await getSeatsNumber(busNumber);
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('busses')
              .doc(busNumber)
              .get();

      if (!snapshot.exists) {}

      final data = snapshot.data();
      busType = data?['busType'];
      createTrip(
          driverNumber: driverNumber,
          tripNumber: tripNumber,
          busNumber: busNumber,
          goTime: goTime,
          source: source,
          destination: destination,
          price: price,
          busType: busType,
          seatsNumber: seatsNumber,
          companyName:
              myServices.sharedPref.getString("companyName").toString());
    } catch (e) {
      print('Error getting bus type: $e');
    }
  }

  String selectedBusType = "";
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
