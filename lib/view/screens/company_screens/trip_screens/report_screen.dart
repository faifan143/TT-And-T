import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/models/NotificationModel.dart';
import 'package:traveler/view/screens/company_screens/trip_screens/map_tracking.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key, required this.notificationModel})
      : super(key: key);
  final NotificationModel notificationModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/gradientBackground.jpg', // replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        """معلومات الابلاغ""",
                        style: arabicTheme.textTheme.headline1!
                            .copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        notificationModel.alertTime!,
                        style: arabicTheme.textTheme.bodyText1,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ": وقت الاشعار",
                        style: arabicTheme.textTheme.headline2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            Get.to(MapTracking(
                                locationData: notificationModel.location));
                          },
                          child: const Text("فتح مكان الابلاغ")),
                      const SizedBox(width: 10),
                      Text(
                        ": مكان الابلاغ",
                        style: arabicTheme.textTheme.headline2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        notificationModel.tripNumber!,
                        style: arabicTheme.textTheme.bodyText1,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ": رقم الرحلة",
                        style: arabicTheme.textTheme.headline2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        notificationModel.driverNumber!,
                        style: arabicTheme.textTheme.bodyText1,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ": رقم السائق",
                        style: arabicTheme.textTheme.headline2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        notificationModel.busNumber!,
                        style: arabicTheme.textTheme.bodyText1,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ": رقم المركبة",
                        style: arabicTheme.textTheme.headline2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        notificationModel.reportContent!,
                        style: arabicTheme.textTheme.bodyText1,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ": محتوى الابلاغ",
                        style: arabicTheme.textTheme.headline2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
