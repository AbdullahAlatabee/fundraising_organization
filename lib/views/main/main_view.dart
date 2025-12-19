import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/main_controller.dart';
import '../home/home_view.dart'; // Using as Cases Tab? 
import '../donors/donors_view.dart';
import '../profile/profile_view.dart';
import '../dashboard/dashboard_view.dart'; // Need to create this
import '../../controllers/profile_controller.dart';
import '../../routes/app_routes.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        centerTitle: true,
        actions: _buildAppBarActions(),
      ),
      body: IndexedStack(
        index: controller.currentIndex.value,
        children: [
          DashboardView(),
          HomeView(), // Acts as Cases List
          DonorsView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTabIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'home'.tr), // Dashboard
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: 'cases'.tr),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'donors'.tr),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'.tr),
        ],
      ),
      floatingActionButton: _buildFAB(),
    ));
  }

  String _getTitle() {
    switch (controller.currentIndex.value) {
      case 0:
        return 'dashboard'.tr;
      case 1:
        return 'cases'.tr;
      case 2:
        return 'donors'.tr;
      case 3:
        return 'profile'.tr;
      default:
        return 'app_name'.tr;
    }
  }

  Widget? _buildFAB() {
    switch (controller.currentIndex.value) {
      case 1: // Cases tab
        return FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.ADD_CASE),
          child: Icon(Icons.add),
        );
      case 2: // Donors tab
        return FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.ADD_EDIT_DONOR),
          child: Icon(Icons.person_add),
        );
      default:
        return null;
    }
  }

  List<Widget>? _buildAppBarActions() {
    if (controller.currentIndex.value == 3) { // Profile tab
      final profileController = Get.find<ProfileController>();
      return [
        Obx(() => IconButton(
          icon: Icon(profileController.isEditing.value ? Icons.close : Icons.edit),
          onPressed: profileController.toggleEdit,
        ))
      ];
    }
    return null;
  }
}
