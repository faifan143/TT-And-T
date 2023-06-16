import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:traveler/controllers/company_controllers/complaint_controller.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/functions/providences_brain.dart';
import 'package:traveler/core/functions/validator.dart';
import 'package:traveler/core/services/sharedPreferences.dart';
import 'package:traveler/models/complaint_model.dart';
import 'package:traveler/models/trip_model.dart';
import 'package:traveler/view/screens/company_screens/trip_screens/seats_view.dart';
import 'package:traveler/view/widgets/complaint_card.dart';
import 'package:traveler/view/widgets/reusable_button.dart';
import 'package:traveler/view/widgets/reusable_form_field.dart';
import 'package:traveler/view/widgets/trip_card.dart';

class ComplaintScreen extends StatelessWidget {
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ComplaintController());
    return GetBuilder<ComplaintController>(builder: (controller) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    """البحث عن رحلات و ادارة الشكاوي""",
                    style:
                        arabicTheme.textTheme.headline1!.copyWith(fontSize: 22),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "البحث",
                style: arabicTheme.textTheme.headline2,
              ),
              Form(
                key: controller.searchFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
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
                        "مدينة الانطلاق",
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
                      items: controller.syrianProvinces
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  convertToArabic(item),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return "الرجاء ادخال الانطلاق";
                        }
                      },
                      onChanged: (value) {
                        //Do something when changing the item if you want.
                        controller.selectedSource = value!;
                        print(controller.selectedSource);
                      },
                      onSaved: (value) {
                        controller.selectedSource = value!;
                      },
                    ),
                    SizedBox(height: 10),
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
                        "الوجهة",
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
                      items: controller.syrianProvinces
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  convertToArabic(item),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return "الرجاء ادخال الوجهة";
                        }
                      },
                      onChanged: (value) {
                        //Do something when changing the item if you want.
                        controller.selectedDestination = value!;
                        print(controller.selectedDestination);
                      },
                      onSaved: (value) {
                        controller.selectedDestination = value!;
                      },
                    ),
                    SizedBox(height: 10),
                    ReUsableButton(
                      height: 15,
                      onPressed: () {
                        if (controller.searchFormKey.currentState!.validate()) {
                          controller.showSearchResult = true;
                          controller.refresh();
                        }
                      },
                      radius: 10,
                      text: "بدء البحث",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (controller.showSearchResult)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trips')
                      .where('started', isEqualTo: false)
                      .where('source', isEqualTo: controller.selectedSource)
                      .where('destination',
                          isEqualTo: controller.selectedDestination)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'هناك خطأ ما',
                        style: arabicTheme.textTheme.bodyText1,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: 250,
                            child: Center(
                                child: Text(
                              "لا يوجد حجوزات معلقة",
                              style: arabicTheme.textTheme.bodyText1,
                            )),
                          )
                        : SizedBox(
                            height: 420.0,
                            width: 380,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                TripModel tripModel = TripModel.fromJson(data);
                                return Row(
                                  children: [
                                    TripCard(
                                      tripNumber: tripModel.tripNumber!,
                                      driverNumber: tripModel.driverNumber!,
                                      busNumber: tripModel.busNumber!,
                                      price: tripModel.price!,
                                      goTime: tripModel.goTime!,
                                      source:
                                          convertToArabic(tripModel.source!),
                                      destination: convertToArabic(
                                          tripModel.destination!),
                                      started: tripModel.started!,
                                      finished: tripModel.finished!,
                                      isAvailable: true,
                                      busType: tripModel.busType!,
                                      companyName: tripModel.companyName!,
                                      availableSeats:
                                          (int.parse(tripModel.seatsNumber!) -
                                                  tripModel.bookedSeats!.length)
                                              .toString(),
                                      doBooking: () {
                                        Get.to(SeatsView(
                                          tripModel: tripModel,
                                          bookedSeats: tripModel.bookedSeats!,
                                          seatsNumber:
                                              int.parse(tripModel.seatsNumber!),
                                        ));
                                      },
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                  },
                ),
              SizedBox(height: 20),
              Text(
                "الشكاوي",
                style: arabicTheme.textTheme.headline2,
              ),
              Form(
                key: controller.complaintFormKey,
                child: Column(children: [
                  SizedBox(height: 10),
                  ReusableFormField(
                    isPassword: false,
                    icon: Icon(Icons.work_outline),
                    checkValidate: (value) {
                      return validator(
                          controller.companyNameController.text.trim(),
                          3,
                          50,
                          "text");
                    },
                    controller: controller.companyNameController,
                    keyType: TextInputType.text,
                    hint: "أدخل اسم الشركة",
                  ),
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  ReusableFormField(
                    isPassword: false,
                    icon: Icon(Icons.edit_note_sharp),
                    checkValidate: (value) {
                      return validator(
                          controller.complaintController.text.trim(),
                          3,
                          100,
                          "text");
                    },
                    controller: controller.complaintController,
                    keyType: TextInputType.text,
                    hint: "أكتب الشكوى",
                  ),
                  SizedBox(height: 10),
                  ReUsableButton(
                    height: 15,
                    onPressed: () {
                      if (controller.complaintFormKey.currentState!
                          .validate()) {
                        controller.createComplaint();
                      }
                    },
                    radius: 10,
                    text: "ارسال الشكوى",
                  ),
                  SizedBox(height: 20),
                ]),
              ),
              if (controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "company")
                Text(
                  "الشكاوي المستقبلة",
                  style: arabicTheme.textTheme.headline2,
                ),
              if (controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "company")
                SizedBox(height: 10),
              if (controller.myServices.sharedPref
                      .getString("userMode")
                      .toString() ==
                  "company")
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('complaints')
                      .where('complainer',
                          isNotEqualTo: controller.myServices.sharedPref
                              .getString("userNumber")
                              .toString())
                      .where('companyName',
                          isEqualTo: controller.myServices.sharedPref
                              .getString("companyName")
                              .toString())
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'هناك خطأ ما',
                        style: arabicTheme.textTheme.bodyText1,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: 250,
                            child: Center(
                                child: Text(
                              "لا يوجد شكاوي",
                              style: arabicTheme.textTheme.bodyText1,
                            )),
                          )
                        : SizedBox(
                            height: 170.0,
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                ComplaintModel complaintModel =
                                    ComplaintModel.fromJson(data);
                                return Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: ComplaintCard(
                                    complaintModel: complaintModel,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                  },
                ),
              SizedBox(height: 15),
              Form(
                  key: controller.passwordFormKey,
                  child: Column(
                    children: [
                      Text(
                        "تغيير كلمة المرور",
                        style: arabicTheme.textTheme.headline2,
                      ),
                      ReusableFormField(
                        isPassword: controller.isPassword,
                        icon: IconButton(
                            onPressed: () => controller.changePassState(),
                            icon: Icon(Icons.remove_red_eye_outlined)),
                        checkValidate: (value) {
                          return validator(value!, 5, 50, "password");
                        },
                        hint: "أدخل كلمة المرور القديمة",
                        controller: controller.oldPasswordController,
                      ),
                      SizedBox(height: 10),
                      ReusableFormField(
                        isPassword: controller.isRePassword,
                        icon: IconButton(
                            onPressed: () => controller.changeRePassState(),
                            icon: Icon(Icons.remove_red_eye_outlined)),
                        checkValidate: (value) =>
                            validator(value!, 5, 50, "password"),
                        controller: controller.newPasswordController,
                        hint: "أدخل كلمة المرور الجديدة",
                      ),
                      SizedBox(height: 10),
                      ReUsableButton(
                        height: 15,
                        text: "تغيير",
                        radius: 10,
                        onPressed: () =>
                            controller.passwordFormKey.currentState!.validate()
                                ? controller.changePassword(context)
                                : null,
                      ),
                    ],
                  )),
              SizedBox(height: 15),
              OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black54),
                  ),
                  onPressed: () {
                    MyServices myServices = Get.find();
                    myServices.sharedPref.setString("logged", "0");
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "تسجيل الخروج",
                      desc: "هل تريد تسجيل الخروج ؟",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "لا",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          gradient: LinearGradient(
                              colors: [Colors.pink, Colors.redAccent]),
                        ),
                        DialogButton(
                          child: Text(
                            "نعم",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Get.offAllNamed(AppRoutes.login),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(0, 179, 134, 1.0),
                            Colors.greenAccent,
                          ]),
                        ),
                      ],
                    ).show();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "تسجيل الخروج",
                        style: arabicTheme.textTheme.bodyText1!
                            .copyWith(color: Colors.red, fontSize: 14),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        IconlyBroken.logout,
                        size: 15,
                        color: Colors.red,
                      ),
                    ],
                  )),
              SizedBox(height: 100),
            ],
          ),
        ),
      );
    });
  }
}
