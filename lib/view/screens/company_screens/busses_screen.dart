import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/company_controllers/busses_controller.dart';
import 'package:traveler/core/classes/bus_type.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/bus_type_brain.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/view/widgets/reusable_button.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';

class BussesScreen extends StatelessWidget {
  const BussesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BussesController());
    return GetBuilder<BussesController>(builder: (controller) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "ادارة المركبات",
                    style: arabicTheme.textTheme.headline1,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                "اضافة مركبات",
                style: arabicTheme.textTheme.headline1,
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        "أختر نوع المركبة",
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: controller.busTypes
                          .map((BusType item) => DropdownMenuItem<String>(
                                value: enumToString(item),
                                child: Text(
                                  stringToArabic(enumToString(item)),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return "الرجاء ادخال نوع المركبة";
                        }
                      },
                      onChanged: (value) {
                        //Do something when changing the item if you want.
                        controller.selectedBusType = stringToEnum(value!);
                        print(controller.selectedBusType);
                      },
                      onSaved: (value) {
                        controller.selectedBusType = stringToEnum(value!);
                      },
                    ),
                    const SizedBox(height: 10),
                    ReusableFormField(
                      isPassword: false,
                      icon: Icon(Icons.numbers),
                      checkValidate: (value) {
                        return validator(
                            controller.busNumberController.text.trim(),
                            6,
                            6,
                            "number");
                      },
                      controller: controller.busNumberController,
                      keyType: TextInputType.number,
                      hint: "أدخل رقم المركبة",
                    ),
                    const SizedBox(height: 10),
                    ReusableFormField(
                      isPassword: false,
                      icon: Icon(Icons.chair_alt_outlined),
                      checkValidate: (value) {
                        return validator(
                            controller.seatsNumberController.text.trim(),
                            1,
                            50,
                            "number");
                      },
                      controller: controller.seatsNumberController,
                      keyType: TextInputType.number,
                      hint: "أدخل عدد المقاعد",
                    ),
                    const SizedBox(height: 10),
                    ReUsableButton(
                      height: 15,
                      text: "اضافة مركبة",
                      radius: 15,
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.handleAddBusButton();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Text(
                "حذف مركبات",
                style: arabicTheme.textTheme.headline1,
              ),
              Form(
                key: controller.deleteFormKey,
                child: Column(
                  children: [
                    ReusableFormField(
                      isPassword: false,
                      icon: Icon(Icons.numbers),
                      checkValidate: (value) {
                        return validator(
                            controller.deleteBusNumberController.text.trim(),
                            6,
                            6,
                            "number");
                      },
                      controller: controller.deleteBusNumberController,
                      keyType: TextInputType.number,
                      hint: "أدخل رقم المركبة المراد حذفها",
                    ),
                    const SizedBox(height: 10),
                    ReUsableButton(
                      height: 15,
                      text: "حذف المركبة",
                      radius: 15,
                      onPressed: () {
                        if (controller.deleteFormKey.currentState!.validate()) {
                          controller.handleDeleteTripButton();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      );
    });
  }
}
