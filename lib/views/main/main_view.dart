import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/main_controller.dart';
import '../home/home_view.dart'; // Using as Cases Tab? 
import '../donors/donors_view.dart';
import '../profile/profile_view.dart';
import '../dashboard/dashboard_view.dart'; // Need to create this

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          DashboardView(),
          HomeView(), // Acts as Cases List
          DonorsView(),
          ProfileView(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTabIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'home'.tr), // Dashboard
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: 'cases'.tr),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'donors'.tr),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'.tr),
        ],
      )),
    );
  }
}
