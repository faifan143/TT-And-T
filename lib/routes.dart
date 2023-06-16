import 'package:get/get.dart';
import 'package:traveler/core/constants/AppRoutes.dart';
import 'package:traveler/core/middleware/myMiddleware.dart';
import 'package:traveler/view/screens/auth/company_screen.dart';
import 'package:traveler/view/screens/auth/forgetPassword.dart';
import 'package:traveler/view/screens/auth/login_screen.dart';
import 'package:traveler/view/screens/auth/signup_screen.dart';
import 'package:traveler/view/screens/company_screens/trip_screens/add.dart';
import 'package:traveler/view/screens/company_screens/trip_screens/delete.dart';
import 'package:traveler/view/screens/main_screen.dart';

import 'view/screens/company_screens/trip_screens/edit.dart';

// Define a list of GetPages to represent all the app screens and their associated routes
List<GetPage<dynamic>>? pages = [
  // Language selection screen
  GetPage(
    name: "/", // Default route
    page: () => LoginScreen(
      gottenPassword: '',
    ), // Use Language screen as page
    middlewares: [
      MyLoginMiddleware()
    ], // Use the defined middlewares for this screen
  ),
  // Auth screens
  GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(
            gottenPassword: '',
          )),
  GetPage(name: AppRoutes.forgetPass, page: () => ForgetPassword()),
  GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
  // App screens
  GetPage(name: AppRoutes.mainScreen, page: () => const MainScreen()),
  GetPage(name: AppRoutes.companyScreen, page: () => const CompanyScreen()),
  GetPage(name: AppRoutes.addTrip, page: () => const AddTripScreen()),
  GetPage(name: AppRoutes.deleteTrip, page: () => const DeleteTripScreen()),
  GetPage(name: AppRoutes.editTrip, page: () => const EditTripScreen()),
];
