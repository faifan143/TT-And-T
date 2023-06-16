import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveler/core/services/sharedPreferences.dart';
import 'package:traveler/models/user_model.dart';
import 'package:traveler/view/screens/company_screens/booking_screen.dart';
import 'package:traveler/view/screens/company_screens/busses_screen.dart';
import 'package:traveler/view/screens/company_screens/my_booking_user_screen.dart';
import 'package:traveler/view/screens/company_screens/trip_screen.dart';

import '../view/screens/company_screens/complaint_screen.dart';

MyServices myService = Get.find();

class MainScreenController extends GetxController {
  late UserModel userModel;
  MyServices myServices = Get.find();

  int currentPage = 0;
  bool isUser = true;
  List<Widget> screens = [
    const TripScreen(),
    if (myService.sharedPref.getString("userMode").toString() == "company")
      const BookingScreen(),
    if (myService.sharedPref.getString("userMode").toString() == "user")
      const UserBookingScreen(),
    if (myService.sharedPref.getString("userMode").toString() == "company")
      const BussesScreen(),
    const ComplaintScreen(),
  ];
  changePage(int index) {
    currentPage = index;
    update();
  }

  List<String> syrianProvinces = [
    'Aleppo',
    'Damascus',
    'Deir ez-Zor',
    'Hama',
    'Homs',
    'Idlib',
    'Latakia',
    'Quneitra',
    'Raqqa',
    'As-Suwayda',
    'Tartus',
    'Daraa'
  ];

  Future<void> getUser({required String phone}) async {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a document reference with the user's phone number as the document ID
    final DocumentReference<Map<String, dynamic>> userDocRef =
        firestore.collection('users').doc(phone);

    try {
      // Check if the user document exists
      final DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
          await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Return the user data if the document exists
        userModel = UserModel.fromJson(userDocSnapshot.data()!);
      } else {
        print('User not found');
      }
    } catch (e) {
      // Handle any errors that occur during the operation
      print('Error getting user: $e');
    }
  }

  Future<List> getBookedSeats(String tripId) async {
    try {
      List<dynamic> bookedSeats;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('trips')
          .where('id', isEqualTo: tripId)
          .get();
      bookedSeats = querySnapshot.docs.first.data()['bookedSeats'];
      return bookedSeats;
    } catch (e) {
      // Handle the error here.
      print('Error getting booked seats: $e');
      return [];
    }
  }

  Future<String> getSeatsNumber(String busNumber) async {
    try {
      return await FirebaseFirestore.instance
          .collection('busses')
          .doc(busNumber)
          .get()
          .then((value) => value.data()!['seatsNumber']);
    } catch (e) {
      // Handle the error here.
      print('Error getting booked seats: $e');
      return "-1";
    }
  }

  Future<int> getBookedSeatsNumber(String tripId) async {
    try {
      List result;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('trips')
          .where('id', isEqualTo: tripId)
          .get();
      result = querySnapshot.docs.first.data()['bookedSeats'];
      return result.length;
    } catch (e) {
      // Handle the error here.
      print('Error getting booked seats: $e');
      return -1;
    }
  }

  bool startTrack = false;
  LatLng busCurrentLocation = LatLng(36.16571412472137, 37.1262037238395);
  Completer<GoogleMapController> busGmapsController = Completer();
  Future<void> getBusCurrentLocation(String locationData) async {
    final latLng = locationData.replaceAll(RegExp('[^0-9\.,-]'), '').split(',');
    final lat = double.parse(latLng[0]);
    final long = double.parse(latLng[1]);
    print("lat");
    print(lat);
    print("long");
    print(long);
    busCurrentLocation = LatLng(lat, long);

    GoogleMapController googleMapController = await busGmapsController.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: busCurrentLocation,
          zoom: 13.5,
        ),
      ),
    );
    update();
  }

  Future<void> getBusLocationAfterDelay(String locationData) async {
    await Future.delayed(const Duration(seconds: 5));
    getBusCurrentLocation(locationData);
  }

  getNotification() async {
    String companyName =
        myServices.sharedPref.getString("companyName").toString();
    await FirebaseMessaging.instance.subscribeToTopic(companyName);
    FirebaseMessaging.onMessage.listen((event) {});
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    myServices.sharedPref.setString("logged", "1");
    getUser(phone: myServices.sharedPref.get("userNumber").toString());
    getNotification();
    checkAndUpdateStartedField();
  }

  void checkAndUpdateStartedField() async {
    final CollectionReference tripsCollection =
        FirebaseFirestore.instance.collection('trips');

    final now = DateTime.now();

    QuerySnapshot querySnapshot =
        await tripsCollection.where('goTime', isLessThan: now.toString()).get();

    if (querySnapshot.docs.isNotEmpty) {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DateTime goTime = DateTime.parse(data['goTime']);

        if (goTime.isBefore(now)) {
          batch.update(document.reference, {'started': true});
        }
      });

      await batch.commit();
    }
  }
}
