import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:traveler/controllers/auth/signup_controller.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/view/widgets/reusable_button.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/gradientBackground.jpg', // replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          GetBuilder<SignupController>(builder: (controller) {
            return ModalProgressHUD(
              inAsyncCall: controller.loading,
              child: Form(
                key: controller.companyFormState,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            title: Text("استكمال بيانات عن الشركة",
                                textDirection: TextDirection.rtl,
                                style: arabicTheme.textTheme.headline1),
                            subtitle: Text(
                                "أنت على بعد خطوة من البدء في الاستغادة من خدماتنا ...",
                                textDirection: TextDirection.rtl,
                                style: arabicTheme.textTheme.headline2),
                          ),
                          const SizedBox(height: 50),
                          ReusableFormField(
                            checkValidate: (value) {
                              return validator(
                                  controller.companyNameController.text,
                                  3,
                                  50,
                                  "text");
                            },
                            isPassword: false,
                            label: "اسم الشركة",
                            controller: controller.companyNameController,
                            hint: "أدخل اسم الشركة بالانجليزية",
                            keyType: TextInputType.text,
                            icon: const Icon(Icons.work_outline),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                              "أختر المحافظة",
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
                                        controller.convertToArabic(item),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return "الرجاء ادخال نوع الحساب";
                              }
                            },
                            onChanged: (value) {
                              //Do something when changing the item if you want.
                              controller.selectedProvidence = value!;
                              print(controller.selectedProvidence);
                            },
                            onSaved: (value) {
                              controller.selectedProvidence = value!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ReusableFormField(
                            checkValidate: (value) {
                              return validator(
                                  controller.companyAdminController.text,
                                  3,
                                  20,
                                  "text");
                            },
                            isPassword: false,
                            label: "اسم المسؤول",
                            controller: controller.companyAdminController,
                            hint: "أدخل اسم المسؤول",
                            keyType: TextInputType.text,
                            icon: const Icon(Icons.person_outline),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ReusableFormField(
                            checkValidate: (value) {
                              return validator(
                                  controller.companyNumberController.text,
                                  7,
                                  7,
                                  "telephone");
                            },
                            isPassword: false,
                            label: "رقم التواصل مع الشركة",
                            controller: controller.companyNumberController,
                            hint: "أدخل رقم التواصل مع الشركة ( أرضي )",
                            keyType: TextInputType.number,
                            icon: const Icon(IconlyBroken.send),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ReUsableButton(
                            text: "انشاء حساب الشركة",
                            height: 10,
                            radius: 10,
                            onPressed: () async {
                              if (controller.companyFormState.currentState!
                                  .validate()) {
                                controller
                                    .handleCompanySignUpButtonPressed(context);
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
