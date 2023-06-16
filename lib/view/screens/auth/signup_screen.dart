import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:traveler/controllers/auth/signup_controller.dart';
import 'package:traveler/core/classes/account_type.dart';
import 'package:traveler/core/constants/AppColors.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/accoun_type_brain.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/view/screens/auth/login_screen.dart';
import 'package:traveler/view/widgets/reusable_button.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

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
                key: controller.formState,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            title: Text(
                              "انشاء حساب",
                              textDirection: TextDirection.rtl,
                              style: arabicTheme.textTheme.headline1,
                            ),
                            subtitle: Text(
                              "أنشئ حساب الآن و استفد من خدمات الرحلات",
                              textDirection: TextDirection.rtl,
                              style: arabicTheme.textTheme.headline2,
                            ),
                          ),
                          const SizedBox(height: 50),
                          ReusableFormField(
                            checkValidate: (value) {
                              return validator(
                                  controller.phoneNumberController.text,
                                  10,
                                  10,
                                  "phone");
                            },
                            isPassword: false,
                            label: "رقم الهاتف",
                            controller: controller.phoneNumberController,
                            hint: "أدخل رقم الهاتف",
                            keyType: TextInputType.phone,
                            icon: const Icon(Icons.phone_enabled_outlined),
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
                              "أختر نوع الحساب",
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
                            items: controller.accountTypes
                                .map((AccountType item) =>
                                    DropdownMenuItem<String>(
                                      value: accountTypeToString(item),
                                      child: Text(
                                        accountTypeToArabic(item),
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
                              controller.selectedAccountType =
                                  stringToAccountType(value!);
                              print(controller.selectedAccountType);
                            },
                            onSaved: (value) {
                              controller.selectedAccountType =
                                  stringToAccountType(value!);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ReusableFormField(
                            checkValidate: (value) {
                              return validator(controller.emailController.text,
                                  11, 50, "email");
                            },
                            label: "البريد الالكتروني",
                            hint: "أدخل البريد الالكتروني",
                            keyType: TextInputType.emailAddress,
                            isPassword: false,
                            onTap: () {
                              controller.changePassState();
                            },
                            icon: const Icon(Icons.email_outlined),
                            controller: controller.emailController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ReusableFormField(
                            checkValidate: (value) {
                              return validator(
                                  controller.passwordController.text,
                                  5,
                                  30,
                                  "password");
                            },
                            label: "كلمة المرور",
                            hint: "أدخل كلمة المرور",
                            keyType: TextInputType.text,
                            isPassword: controller.isPassword,
                            onTap: () {
                              controller.changePassState();
                            },
                            icon: const Icon(Icons.lock_outline),
                            controller: controller.passwordController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ReusableFormField(
                            checkValidate: (value) {
                              return validator(
                                  controller.rePasswordController.text,
                                  5,
                                  30,
                                  "password");
                            },
                            label: "تأكيد كلمة المرور",
                            hint: "اعادة تأكيد كلمة المرور",
                            keyType: TextInputType.text,
                            isPassword: controller.isRePassword,
                            onTap: () {
                              controller.changeRePassState();
                            },
                            icon: const Icon(Icons.lock_outline),
                            controller: controller.rePasswordController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ReUsableButton(
                            text: "انشاء حساب",
                            height: 10,
                            radius: 10,
                            onPressed: () async {
                              if (controller.formState.currentState!
                                  .validate()) {
                                if (controller.selectedAccountType ==
                                        AccountType.company &&
                                    controller.rePasswordController.text
                                            .trim() ==
                                        controller.passwordController.text
                                            .trim()) {
                                  Get.toNamed(AppRoutes.companyScreen);
                                } else {
                                  if (controller.selectedAccountType !=
                                          AccountType.unknown &&
                                      controller.rePasswordController.text
                                              .trim() ==
                                          controller.passwordController.text
                                              .trim()) {
                                    controller
                                        .handleSignUpButtonPressed(context);
                                  }
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.off(LoginScreen(
                                    gottenPassword: '',
                                  ));
                                },
                                child: const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                      color: AppColors.gradientLightColor),
                                ),
                              ),
                              const Text(" "),
                              Text(
                                "هل لديك حساب مسبقاً ؟",
                                style: arabicTheme.textTheme.bodyText1,
                              ),
                            ],
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
