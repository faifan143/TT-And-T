import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/core/functions/show_snackbar.dart';
import 'package:traveler/view/screens/auth/login_screen.dart';

class ForgotPasswordController extends GetxController {
  // Initialize necessary variables and objects
  late TextEditingController emailController;
  late TextEditingController phoneController;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? myPassword;

  Future<void> getPassword(BuildContext context) async {
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Query the users collection to get the document with the matching email
      final QuerySnapshot<Map<String, dynamic>> userQuerySnapshot =
          await firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .where('phone', isEqualTo: phone)
              .get();

      final QuerySnapshot<Map<String, dynamic>> companyQuerySnapshot =
          await firestore
              .collection('companies')
              .where('admin-email', isEqualTo: email)
              .where('admin-phone', isEqualTo: phone)
              .get();

      // Check if a document with the matching email exists
      if (companyQuerySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot<Map<String, dynamic>> companyDocSnapshot =
            companyQuerySnapshot.docs.first;

        // Return the password if the user document exists
        myPassword = companyDocSnapshot.get('admin-password');
        myPassword!;
        showSnackBar(
            context: context,
            contentType: ContentType.warning,
            title: "اعادة كلمة المرور",
            body: "$myPasswordكلمة المرور هي ");
        // Get.offAllNamed(AppRoutes.login);
      } else if (userQuerySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
            userQuerySnapshot.docs.first;

        // Return the password if the user document exists
        myPassword = userDocSnapshot.get('password');
        showSnackBar(
            context: context,
            contentType: ContentType.warning,
            title: "اعادة كلمة المرور",
            body: "$myPasswordكلمة المرور هي ");
        Get.offAll(LoginScreen(gottenPassword: myPassword!));
      } else {
        // Return null if no document with the matching email exists
        showSnackBar(
            context: context,
            contentType: ContentType.failure,
            title: "اعادة كلمة المرور",
            body: "المعلومات المدخلة غير مطابقة لبياناتنا");
      }
      Get.offAll(LoginScreen(gottenPassword: myPassword!));
    } catch (e) {
      // Handle any errors that occur during the operation
      print('Error getting password: $e');
      return;
    }
  }

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }
}
