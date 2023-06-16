import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/core/classes/account_type.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/functions/accoun_type_brain.dart';
import 'package:traveler/core/functions/show_snackbar.dart';
import 'package:traveler/core/services/sharedPreferences.dart';

class SignupController extends GetxController {
  bool loading = false;
  bool isPassword = true;
  bool isRePassword = true;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  GlobalKey<FormState> companyFormState = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController rePasswordController;

  late TextEditingController companyNameController;
  late TextEditingController companyAdminController;
  late TextEditingController companyLocationController;
  late TextEditingController companyNumberController;

  List<AccountType> accountTypes = [AccountType.company, AccountType.traveller];
  AccountType selectedAccountType = AccountType.unknown;
  String selectedProvidence = " ";
  MyServices myServices = Get.find();

  changePassState() {
    isPassword = !isPassword;
    update();
  }

  changeRePassState() {
    isRePassword = !isRePassword;
    update();
  }

  changeLoadingState() {
    loading = !loading;
    update();
  }

  List<String> syrianProvinces = [
    'Aleppo',
    'Damascus',
    'Deir ez-Zor',
    'Hama',
    'Homs',
    'Idlib',
    'Latakia',
    'Quneitra',
    'Raqqa',
    'As-Suwayda',
    'Tartus',
    'Daraa'
  ];
  String convertToArabic(String provinceName) {
    switch (provinceName) {
      case 'Aleppo':
        return 'حلب';
      case 'Damascus':
        return 'دمشق';
      case 'Deir ez-Zor':
        return 'دير الزور';
      case 'Hama':
        return 'حماة';
      case 'Homs':
        return 'حمص';
      case 'Idlib':
        return 'إدلب';
      case 'Latakia':
        return 'اللاذقية';
      case 'Quneitra':
        return 'القنيطرة';
      case 'Raqqa':
        return 'الرقة';
      case 'As-Suwayda':
        return 'السويداء';
      case 'Tartus':
        return 'طرطوس';
      case 'Daraa':
        return 'درعا';
      default:
        return 'Unknown Province';
    }
  }

  Future<void> createUser(
      {required String phone,
      required String password,
      required BuildContext context,
      required String email}) async {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a document reference with the user's phone number as the document ID
    final DocumentReference<Map<String, dynamic>> userDocRef =
        firestore.collection('users').doc(phone);
    final DocumentReference<Map<String, dynamic>> companyDocRef =
        firestore.collection('companies').doc(phone);

    try {
      // Check if the user document already exists
      final DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
          await userDocRef.get();
      final DocumentSnapshot<Map<String, dynamic>> companyDocSnapshot =
          await companyDocRef.get();

      if (!userDocSnapshot.exists && !companyDocSnapshot.exists) {
        // Create the user document if it doesn't already exist
        await userDocRef.set({
          'type': accountTypeToString(selectedAccountType),
          'email': email,
          'phone': phone,
          'password': password
        });
        Get.offAllNamed(AppRoutes.login);
      } else {
        print('User already exists');
        showSnackBar(
            context: context,
            contentType: ContentType.failure,
            title: "خطأ",
            body: 'هذا الحساب موجود مسبقاً');
      }
      changeLoadingState();
    } catch (e) {
      // Handle any errors that occur during the operation
      print('Error creating user: $e');
    }
  }

  void handleSignUpButtonPressed(BuildContext context) {
    changeLoadingState();
    String phoneNumber = phoneNumberController.text.trim();
    String password = passwordController.text.trim();
    String email = emailController.text.trim();
    createUser(
        phone: phoneNumber, password: password, email: email, context: context);
  }

  Future<void> createCompany({
    required String phone,
    required String password,
    required String email,
    required String companyName,
    required BuildContext context,
    required String companyAdmin,
    required String companyLocation,
    required String companyNumber,
  }) async {
    // Access the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a document reference with the user's phone number as the document ID
    final DocumentReference<Map<String, dynamic>> userDocRef =
        firestore.collection('users').doc(phone);
    final DocumentReference<Map<String, dynamic>> companyDocRef =
        firestore.collection('companies').doc(phone);

    try {
      // Check if the user document already exists
      final DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
          await userDocRef.get();
      final DocumentSnapshot<Map<String, dynamic>> companyDocSnapshot =
          await companyDocRef.get();

      if (!userDocSnapshot.exists && !companyDocSnapshot.exists) {
        // Create the user document if it doesn't already exist
        await companyDocRef.set({
          'type': accountTypeToString(selectedAccountType),
          'admin-email': email,
          'admin-phone': phone,
          'admin-password': password,
          'company-name': companyName,
          'company-admin': companyAdmin,
          'company-location': companyLocation,
          'company-number': companyNumber,
        });
        print('Company created successfully');
        Get.offAllNamed(AppRoutes.login);
      } else {
        print('User already exists');
        showSnackBar(
            context: context,
            contentType: ContentType.failure,
            title: "خطأ",
            body: 'هذا الحساب موجود مسبقاً');
      }
      changeLoadingState();
    } catch (e) {
      // Handle any errors that occur during the operation
      print('Error creating user: $e');
    }
  }

  void handleCompanySignUpButtonPressed(BuildContext context) {
    changeLoadingState();
    String phoneNumber = phoneNumberController.text.trim();
    String password = passwordController.text.trim();
    String email = emailController.text.trim();
    String companyName = companyNameController.text.trim();
    String companyAdmin = companyAdminController.text.trim();
    String companyLocation = selectedProvidence;
    String companyNumber = companyNumberController.text.trim();
    createCompany(
      phone: phoneNumber,
      password: password,
      email: email,
      companyName: companyName,
      companyAdmin: companyAdmin,
      companyLocation: companyLocation,
      companyNumber: companyNumber,
      context: context,
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    emailController = TextEditingController();
    companyAdminController = TextEditingController();
    companyLocationController = TextEditingController();
    companyNameController = TextEditingController();
    companyNumberController = TextEditingController();
  }
}
