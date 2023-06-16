import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/company_controllers/booking_controller.dart';
import 'package:traveler/models/trip_model.dart';
import 'package:traveler/view/widgets/seat_card.dart';

class NormalBus extends GetView<BookingController> {
  const NormalBus({
    super.key,
    required this.tripModel,
    required this.bookedSeats,
    required this.seatsNo,
    required this.intermittentSequence,
    required this.notAnIntermittentSequence,
  });

  final int seatsNo;
  final List<int> intermittentSequence;
  final List<int> notAnIntermittentSequence;
  final TripModel tripModel;
  final List<dynamic> bookedSeats;

  @override
  Widget build(BuildContext context) {
    Get.put(BookingController());
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 100),
      child: Row(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              children: List.generate(intermittentSequence.length, (index) {
                return SeatCard(
                  index: intermittentSequence[index],
                  tripModel: tripModel,
                  bookedSeats: bookedSeats,
                );
              }),
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              children:
                  List.generate(notAnIntermittentSequence.length, (index) {
                return SeatCard(
                  index: notAnIntermittentSequence[index],
                  tripModel: tripModel,
                  bookedSeats: bookedSeats,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
