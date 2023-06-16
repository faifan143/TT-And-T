import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:traveler/controllers/company_controllers/add_trip_controller.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/providences_brain.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/view/widgets/reusable_button.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';

class AddTripScreen extends StatelessWidget {
  const AddTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddTripController());
    return GetBuilder<AddTripController>(builder: (controller) {
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  child: Form(
                    key: controller.formState,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "اضافة رحلات",
                              style: arabicTheme.textTheme.headline1,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ReusableFormField(
                          isPassword: false,
                          icon: const Icon(IconlyBroken.call),
                          checkValidate: (value) {
                            return validator(
                                controller.driverNumberController.text.trim(),
                                10,
                                10,
                                "phone");
                          },
                          controller: controller.driverNumberController,
                          keyType: TextInputType.number,
                          hint: "أدخل رقم سائق المركبة",
                        ),
                        const SizedBox(height: 10),
                        ReusableFormField(
                          isPassword: false,
                          icon: const Icon(Icons.numbers),
                          checkValidate: (value) {
                            return validator(
                                controller.tripNumberController.text.trim(),
                                1,
                                9999999,
                                "text");
                          },
                          controller: controller.tripNumberController,
                          keyType: TextInputType.number,
                          hint: "أدخل رقم الرحلة",
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField2(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          isExpanded: true,
                          hint: const Text(
                            "رقم المركبة",
                            style: TextStyle(fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: controller.availableBuses
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return "الرجاء ادخال رقم المركبة";
                            }
                          },
                          onChanged: (value) async {
                            //Do something when changing the item if you want.
                            controller.selectedBus = value!;
                          },
                          onSaved: (value) async {
                            controller.selectedBus = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        ReusableFormField(
                          isPassword: false,
                          icon: const Icon(Icons.attach_money_outlined),
                          checkValidate: (value) {
                            return validator(
                                controller.priceController.text.trim(),
                                3,
                                20,
                                "text");
                          },
                          controller: controller.priceController,
                          keyType: TextInputType.number,
                          hint: "أدخل سعر تذكرة الرحلة",
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField2(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          isExpanded: true,
                          hint: const Text(
                            "مدينة الانطلاق",
                            style: TextStyle(fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: controller.syrianProvinces
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      convertToArabic(item),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return "الرجاء ادخال مدينة الانطلاق";
                            }
                          },
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                            controller.selectedStart = value!;
                            print(controller.selectedStart);
                          },
                          onSaved: (value) {
                            controller.selectedStart = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField2(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          isExpanded: true,
                          hint: const Text(
                            "الوجهة",
                            style: TextStyle(fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: controller.syrianProvinces
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      convertToArabic(item),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return "الرجاء ادخال الوجهة";
                            }
                          },
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                            controller.selectedDestination = value!;
                            print(controller.selectedDestination);
                          },
                          onSaved: (value) {
                            controller.selectedDestination = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            final date = await controller.pickDate(context);
                            controller.timeDateChosen = true;
                            if (date == null) {
                              controller.timeDateChosen = false;
                            } else {
                              controller.dateTime = date;
                              controller.datePickedHint =
                                  "${date.year}-${date.month}-${date.day}";
                              controller.refresh();
                            }
                          },
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(IconlyBroken.calendar)),
                              hintText: controller.datePickedHint.isEmpty
                                  ? "أختر موعد الانطلاق"
                                  : controller.datePickedHint,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            final time = await controller.pickTime(context);
                            controller.timeDateChosen = true;

                            if (time == null) {
                              controller.timeDateChosen = false;

                              return;
                            } else {
                              controller.dateTime = DateTime(
                                controller.dateTime.year,
                                controller.dateTime.month,
                                controller.dateTime.day,
                                time.hour,
                                time.minute,
                              );
                              controller.timePickedHint =
                                  "${time.hour}:${time.minute}";
                              controller.refresh();
                            }
                          },
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(IconlyBroken.times_quare)),
                              hintText: controller.timePickedHint.isEmpty
                                  ? "أختر موعد الانطلاق"
                                  : controller.timePickedHint,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ReUsableButton(
                          height: 15,
                          onPressed: () {
                            if (controller.formState.currentState!.validate()) {
                              if (controller.timeDateChosen) {
                                controller.handleAddTripButton();
                              }
                            }
                          },
                          text: "اضافة الرحلة",
                          radius: 10,
                        ),
                        const SizedBox(height: 40),
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
