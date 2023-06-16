import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/core/classes/account_type.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/functions/accoun_type_brain.dart';
import 'package:traveler/core/functions/show_snackbar.dart';
import 'package:traveler/core/services/sharedPreferences.dart';

class LoginController extends GetxController {
  bool loading = false;
  bool isPassword = true;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  AccountType selectedAccountType = AccountType.unknown;

  changePassState() {
    isPassword = !isPassword;
    update();
  }

  changeLoadingState() {
    loading = !loading;
    update();
  }

  Future<void> getAccountType() async {
    String phone = phoneNumberController.text.trim();
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Query the users collection to get the document with the matching email
      final QuerySnapshot<Map<String, dynamic>> usersQuerySnapshot =
          await firestore
              .collection('users')
              .where('phone', isEqualTo: phone)
              .get();
      final QuerySnapshot<Map<String, dynamic>> companiesQuerySnapshot =
          await firestore
              .collection('companies')
              .where('admin-phone', isEqualTo: phone)
              .get();

      // Check if a document with the matching email exists
      if (usersQuerySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
            usersQuerySnapshot.docs.first;
        // Return the password if the user document exists
        selectedAccountType = stringToAccountType(userDocSnapshot.get('type'));
      } else if (companiesQuerySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
            companiesQuerySnapshot.docs.first;
        // Return the password if the user document exists
        selectedAccountType = stringToAccountType(userDocSnapshot.get('type'));
      } else {
        // Return null if no document with the matching email exists
        return;
      }
    } catch (e) {
      // Handle any errors that occur during the operation
      print('Error getting password: $e');
      return;
    }
  }

  MyServices myServices = Get.find();
  Future<void> loginUser(
      String phone, String password, BuildContext context) async {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a document reference with the user's phone number as the document ID
    final DocumentReference<Map<String, dynamic>> userDocRef =
        firestore.collection('users').doc(phone);

    try {
      changeLoadingState();
      // Check if the user document exists
      final DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
          await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Check if the password matches
        if (userDocSnapshot.get('password') == password) {
          print('Login successful');
          myServices.sharedPref.setString("userNumber", phone);
          myServices.sharedPref.setString("userMode", "user");
          print(myServices.sharedPref.getString("userMode").toString() +
              myServices.sharedPref.getString("userNumber").toString());
          Get.offAllNamed(AppRoutes.mainScreen);
        } else {
          print('Incorrect password');
          showSnackBar(
            context: context,
            contentType: ContentType.failure,
            body: "كلمة المرور خاطئة",
            title: "خطأ !",
          );
        }
      } else {
        print('User not found');
        showSnackBar(
          context: context,
          contentType: ContentType.failure,
          body: "حساب المسافر هذا غير موجود",
          title: "خطأ !",
        );
      }
    } catch (e) {
      changeLoadingState();
      // Handle any errors that occur during the operation
      print('Error logging in: $e');
    }
  }

  Future<void> loginCompany(
      String phone, String password, BuildContext context) async {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a document reference with the user's phone number as the document ID
    final DocumentReference<Map<String, dynamic>> userDocRef =
        firestore.collection('companies').doc(phone);

    try {
      // Check if the user document exists
      final DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
          await userDocRef.get();

      if (userDocSnapshot.exists) {
        changeLoadingState();
        // Check if the password matches
        if (userDocSnapshot.get('admin-password') == password) {
          print('Login successful');
          myServices.sharedPref.setString("userNumber", phone);
          myServices.sharedPref.setString("userMode", "company");
          myServices.sharedPref.setString(
              "companyName", await userDocSnapshot.get('company-name'));
          print(myServices.sharedPref.getString("userMode").toString() +
              myServices.sharedPref.getString("userNumber").toString() +
              myServices.sharedPref.getString("companyName").toString());
          Get.offAllNamed(AppRoutes.mainScreen);
        } else {
          showSnackBar(
            context: context,
            contentType: ContentType.failure,
            body: "كلمة المرور خاطئة",
            title: "خطأ !",
          );
          print('Incorrect password');
        }
      } else {
        print('User not found');
        showSnackBar(
          context: context,
          contentType: ContentType.failure,
          body: "حساب الشركة هذا غير موجود",
          title: "خطأ !",
        );
      }
    } catch (e) {
      changeLoadingState();
      // Handle any errors that occur during the operation
      print('Error logging in: $e');
    }
  }

  void handleLoginButtonPressed(BuildContext context) async {
    changeLoadingState();
    await getAccountType();
    String phoneNumber = phoneNumberController.text.trim();
    String password = passwordController.text.trim();
    if (selectedAccountType == AccountType.company) {
      loginCompany(phoneNumber, password, context);
    } else {
      loginUser(phoneNumber, password, context);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
  }
}
