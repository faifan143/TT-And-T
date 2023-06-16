import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppColors.dart';
import 'package:traveler/core/constants/appTheme.dart';

class MapTracking extends StatelessWidget {
  const MapTracking({
    super.key,
    required this.locationData,
  });
  final String locationData;
  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      print(" \n\n\n\n\n\n\n");
      print("currentLocation : ${controller.busCurrentLocation}");
      print("  \n\n\n\n\n\n\n");
      return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(controller.busCurrentLocation.latitude!,
                    controller.busCurrentLocation.longitude!),
                zoom: 13.5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("Bus Current Location"),
                  position: LatLng(controller.busCurrentLocation.latitude!,
                      controller.busCurrentLocation.longitude!),
                ),
              },
              onMapCreated: (mapController) {
                controller.busGmapsController.complete(mapController);
              },
            ),
            Positioned(
              right: 0,
              left: 0,
              top: 0,
              child: SizedBox(
                height: 100,
                child: OutlinedButton(
                  onPressed: () {
                    controller.getBusCurrentLocation(locationData);
                  },
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(AppColors.buttonColor),
                  ),
                  child: Text(
                    "تحديث يدوي",
                    style: arabicTheme.textTheme.headline2!.copyWith(height: 5),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
