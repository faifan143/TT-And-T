import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:traveler/controllers/auth/login_controller.dart';
import 'package:traveler/core/constants/AppColors.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/view/widgets/reusable_button.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key, required this.gottenPassword}) : super(key: key);
  String gottenPassword = "";
  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/gradientBackground.jpg', // replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          GetBuilder<LoginController>(builder: (controller) {
            gottenPassword == ""
                ? null
                : controller.passwordController.text = gottenPassword;
            return ModalProgressHUD(
              inAsyncCall: controller.loading,
              child: Form(
                key: controller.formState,
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
                            title: Text("تسجيل دخول",
                                textDirection: TextDirection.rtl,
                                style: arabicTheme.textTheme.headline1),
                            subtitle: Text("سجل دخولك الآن و استفد من خدماتنا",
                                textDirection: TextDirection.rtl,
                                style: arabicTheme.textTheme.headline2),
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
                          ReUsableButton(
                            text: "تسجيل الدخول",
                            height: 10,
                            radius: 10,
                            onPressed: () async {
                              if (controller.formState.currentState!
                                  .validate()) {
                                controller.handleLoginButtonPressed(context);
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(AppRoutes.forgetPass);
                                },
                                child: Text(
                                  "نسيت كلمة المرور ؟",
                                  textAlign: TextAlign.start,
                                  style: arabicTheme.textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(AppRoutes.signup);
                                },
                                child: const Text(
                                  "انشاء حساب",
                                  style: TextStyle(
                                      color: AppColors.gradientLightColor),
                                ),
                              ),
                              const Text(" "),
                              Text(
                                "ليس لديك حساب ؟",
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
