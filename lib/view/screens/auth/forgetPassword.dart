import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:traveler/controllers/auth/forgot_password_controller.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/view/widgets/reusable_button.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ForgotPasswordController controller = Get.put(ForgotPasswordController());
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
            child: Form(
              key: controller.formState,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "ارسال رسالة تهيئة كلمة المرور",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ReusableFormField(
                          checkValidate: (val) {
                            return validator(controller.emailController.text,
                                11, 100, "email");
                          },
                          hint: "أدخل بريدك الالكتروني الخاص بحسابك",
                          icon: const Icon(Icons.email_outlined),
                          controller: controller.emailController,
                          isPassword: false,
                        ),
                        const SizedBox(height: 10),
                        ReusableFormField(
                          checkValidate: (val) {
                            return validator(controller.phoneController.text,
                                10, 10, "phone");
                          },
                          hint: "أدخل رقمك",
                          icon: const Icon(IconlyBroken.call),
                          controller: controller.phoneController,
                          isPassword: false,
                          keyType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        ReUsableButton(
                          text: "ارسال",
                          onPressed: () {
                            if (controller.formState.currentState!.validate()) {
                              controller.getPassword(context);
                            }
                          },
                          height: 10,
                          radius: 10,
                        ),
                      ],
                    ),
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
