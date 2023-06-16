import 'package:flutter/material.dart';
import 'package:traveler/view/widgets/seat_card.dart';

import '../../models/trip_model.dart';

class VipBus extends StatelessWidget {
  const VipBus({
    super.key,
    required this.seatsNo,
    required this.multi3,
    required this.notAMulti3,
    required this.tripModel,
    required this.bookedSeats,
  });

  final int seatsNo;
  final List<int> multi3;
  final List<int> notAMulti3;
  final TripModel tripModel;
  final List<dynamic> bookedSeats;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 100),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        children: List.generate(notAMulti3.length, (index) {
                          return SeatCard(
                            index: notAMulti3[index],
                            tripModel: tripModel,
                            bookedSeats: bookedSeats,
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 1,
                      child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 2 / 3,
                        children: List.generate(multi3.length, (index) {
                          return SeatCard(
                            index: multi3[index],
                            tripModel: tripModel,
                            bookedSeats: bookedSeats,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
