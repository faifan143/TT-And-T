import 'package:flutter/material.dart';
import 'package:traveler/models/trip_model.dart';
import 'package:traveler/view/widgets/seat_card.dart';

class MiniBus extends StatelessWidget {
  const MiniBus({
    super.key,
    required this.seatsNo,
    required this.tripModel,
    required this.bookedSeats,
  });

  final int seatsNo;
  final TripModel tripModel;
  final List<dynamic> bookedSeats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 100),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        children: List.generate(seatsNo, (index) {
          index++;
          return SeatCard(
            index: index,
            tripModel: tripModel,
            bookedSeats: bookedSeats,
          );
        }),
      ),
    );
  }
}
