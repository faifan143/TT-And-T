import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:traveler/controllers/company_controllers/edit_trip_controller.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/view/widgets/reusable_button.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';

class EditTripScreen extends StatelessWidget {
  const EditTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EditTripController());
    return GetBuilder<EditTripController>(builder: (controller) {
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
                              "تعديل رحلات",
                              style: arabicTheme.textTheme.headline1,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Form(
                          key: controller.editFormState,
                          child: Column(
                            children: [
                              ReusableFormField(
                                isPassword: false,
                                icon: Icon(Icons.numbers),
                                checkValidate: (value) {
                                  return validator(
                                      controller.tripNumberController.text
                                          .trim(),
                                      1,
                                      9999999,
                                      "number");
                                },
                                controller: controller.tripNumberController,
                                keyType: TextInputType.number,
                                hint: "أدخل رقم الرحلة المراد تعديلها",
                              ),
                              SizedBox(height: 10),
                              ReUsableButton(
                                height: 15,
                                colour: Colors.deepPurple,
                                onPressed: () {
                                  if (controller.editFormState.currentState!
                                      .validate()) {
                                    controller.handleSearchTripButton();
                                  }
                                },
                                text: "ابحث عن الرحلة",
                                radius: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        ReusableFormField(
                          isPassword: false,
                          icon: Icon(IconlyBroken.call),
                          checkValidate: (value) {
                            return validator(
                                controller.driverNumberController.text.trim(),
                                10,
                                10,
                                "phone");
                          },
                          controller: controller.driverNumberController,
                          keyType: TextInputType.number,
                          hint: "عدل رقم سائق المركبة",
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField2(
                          value: controller.selectedBus == ""
                              ? null
                              : controller.selectedBus,
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
                        SizedBox(height: 10),
                        ReusableFormField(
                          isPassword: false,
                          icon: Icon(Icons.attach_money_outlined),
                          checkValidate: (value) {
                            return validator(
                                controller.priceController.text.trim(),
                                3,
                                20,
                                "number");
                          },
                          controller: controller.priceController,
                          keyType: TextInputType.number,
                          hint: "عدل سعر تذكرة الرحلة",
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            final date = await controller.pickDate(context);
                            if (date == null) {
                              return;
                            } else {
                              controller.dateTime = date;
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
                                  icon: Icon(IconlyBroken.calendar)),
                              hintText: controller.showDateTime == false
                                  ? "عدل موعد الانطلاق"
                                  : "${controller.dateTime.year}-${controller.dateTime.month}-${controller.dateTime.day}",
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            final time = await controller.pickTime(context);
                            if (time == null) {
                              return;
                            } else {
                              controller.dateTime = DateTime(
                                controller.dateTime.year,
                                controller.dateTime.month,
                                controller.dateTime.day,
                                time.hour,
                                time.minute,
                              );
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
                                  icon: Icon(IconlyBroken.times_quare)),
                              hintText: controller.showDateTime == false
                                  ? "عدل موعد الانطلاق"
                                  : "${controller.dateTime.hour}:${controller.dateTime.minute}",
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ReUsableButton(
                          height: 15,
                          onPressed: () {
                            if (controller.formState.currentState!.validate()) {
                              controller.handleEditTripButton();
                            }
                          },
                          text: "تعديل الرحلة",
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
