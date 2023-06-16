import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:traveler/controllers/main_screen_controller.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/functions/show_snackbar.dart';

class ComplaintController extends MainScreenController {
  GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> complaintFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  late String selectedSource;
  late String selectedDestination;
  late TextEditingController complaintController;
  late TextEditingController busNumberController;
  late TextEditingController companyNameController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  bool showSearchResult = false;
  bool isPassword = true;
  bool isRePassword = true;
  changePassState() {
    isPassword = !isPassword;
    update();
  }

  changeRePassState() {
    isRePassword = !isRePassword;
    update();
  }

  Future<void> createComplaint() async {
    final complaintsCollection =
        FirebaseFirestore.instance.collection('complaints');
    final complaintDoc = complaintsCollection.doc();

    await complaintDoc.set({
      'companyName': companyNameController.text.trim(),
      'busNumber': busNumberController.text.trim(),
      'complainer': myServices.sharedPref.getString("userNumber").toString(),
      'complaint': complaintController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    complaintController.clear();
    companyNameController.clear();
    busNumberController.clear();
    Get.offAllNamed(AppRoutes.mainScreen);
  }

  Future<void> changePassword(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    final userNumber = myServices.sharedPref.getString("userNumber")!;
    final userDoc = firestore.collection('users').doc(userNumber);
    final companyDoc = firestore.collection('companies').doc(userNumber);
    final userRightOldPassword = (await userDoc.get()).data()?['password'];
    final companyRightOldPassword =
        (await companyDoc.get()).data()?['admin-password'];

    if (companyRightOldPassword == oldPasswordController.text.trim()) {
      await companyDoc
          .update({'admin-password': newPasswordController.text.trim()});
      print("password changed successfully");
      showSnackBar(
        context: context,
        contentType: ContentType.success,
        title: "تم !",
        body: "تم تغيير كلمة المرور",
      );
      Get.offAllNamed(AppRoutes.mainScreen);
    } else if (userRightOldPassword == oldPasswordController.text.trim()) {
      await userDoc.update({'password': newPasswordController.text.trim()});
      showSnackBar(
        context: context,
        contentType: ContentType.success,
        title: "تم !",
        body: "تم تغيير كلمة المرور",
      );
      Get.offAllNamed(AppRoutes.mainScreen);
      print("password changed successfully");
    } else {
      showSnackBar(
        context: context,
        contentType: ContentType.failure,
        title: "خطأ !",
        body: "كلمة المرور خاطئة",
      );
      print("wrong password");
      return;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    companyNameController = TextEditingController();
    complaintController = TextEditingController();
    busNumberController = TextEditingController();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
  }
}
