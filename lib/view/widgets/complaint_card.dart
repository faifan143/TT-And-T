import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppColors.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/models/complaint_model.dart';

class ComplaintCard extends GetView<MainScreenController> {
  const ComplaintCard({
    super.key,
    required this.complaintModel,
  });
  final ComplaintModel complaintModel;

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return Container(
      height: 200,
      width: 300,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(0, 0),
          )
        ],
        gradient: LinearGradient(
          colors: [
            Colors.indigo,
            AppColors.gradientDarkColor,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                complaintModel.complainer!,
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": رقم المشتكي",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                complaintModel.companyName!,
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": اسم الشركة",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                complaintModel.busNumber!,
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": رقم المركبة ",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "${complaintModel.complaint!}",
                style: arabicTheme.textTheme.bodyText1,
              ),
              SizedBox(width: 10),
              Text(
                ": الشكوى ",
                style: arabicTheme.textTheme.headline2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
