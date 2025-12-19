import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'User'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            decoration: BoxDecoration(color: Get.theme.primaryColor),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('home'.tr),
            onTap: () => Get.offNamed(AppRoutes.HOME),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('donors'.tr),
            onTap: () => Get.offNamed(AppRoutes.DONORS),
          ),
          ListTile(
            leading: Icon(Icons.volunteer_activism),
            title: Text('donations'.tr),
            onTap: () => Get.offNamed(AppRoutes.DONATIONS),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('profile'.tr),
            onTap: () => Get.toNamed(AppRoutes.PROFILE),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('settings'.tr),
            onTap: () => Get.toNamed(AppRoutes.SETTINGS),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('logout'.tr, style: TextStyle(color: Colors.red)),
            onTap: () => authController.logout(),
          ),
        ],
      ),
    );
  }
}
