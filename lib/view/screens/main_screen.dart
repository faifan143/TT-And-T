import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:traveler/controllers/main_screen_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
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
              child: controller.screens[controller.currentPage],
            ),
          ],
        ),
        floatingActionButton: DotNavigationBar(
          currentIndex: controller.currentPage,
          backgroundColor: Colors.black54,
          onTap: (p0) {
            controller.changePage(p0);
          },
          enableFloatingNavBar: true,
          unselectedItemColor: Colors.white,
          items: [
            DotNavigationBarItem(
              icon: const Icon(IconlyBroken.home),
              selectedColor: Colors.pink,
            ),
            DotNavigationBarItem(
              icon: const Icon(IconlyBroken.category),
              selectedColor: Colors.pink,
            ),
            if (controller.myServices.sharedPref
                    .getString("userMode")
                    .toString() ==
                "company")
              DotNavigationBarItem(
                icon: const Icon(IconlyBroken.plus),
                selectedColor: Colors.pink,
              ),
            DotNavigationBarItem(
              icon: const Icon(IconlyBroken.profile),
              selectedColor: Colors.pink,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}
