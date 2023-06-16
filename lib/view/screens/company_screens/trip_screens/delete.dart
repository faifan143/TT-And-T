import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/company_controllers/delete_trip_controller.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/view/widgets/reusable_button.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';

class DeleteTripScreen extends StatelessWidget {
  const DeleteTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DeleteTripController());
    return GetBuilder<DeleteTripController>(builder: (controller) {
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
                child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  child: Form(
                    key: controller.formState,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "حذف رحلات",
                              style: arabicTheme.textTheme.headline1,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ReusableFormField(
                          isPassword: false,
                          icon: Icon(Icons.numbers),
                          checkValidate: (value) {
                            return validator(
                                controller.tripNumberController.text.trim(),
                                1,
                                9999999,
                                "number");
                          },
                          controller: controller.tripNumberController,
                          keyType: TextInputType.number,
                          hint: "أدخل رقم الرحلة",
                        ),
                        SizedBox(height: 10),
                        ReUsableButton(
                          height: 15,
                          onPressed: () {
                            if (controller.formState.currentState!.validate()) {
                              controller.handleDeleteTripButton();
                            }
                          },
                          text: "حذف الرحلة",
                          radius: 10,
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                )
              ],
            )),
          ],
        ),
      );
    });
  }
}
