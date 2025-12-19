import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../routes/app_routes.dart';
import '../widgets/app_drawer.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      drawer: AppDrawer(),
      body: ListView(
        children: [
          Obx(() => SwitchListTile(
            title: Text('dark_mode'.tr),
            value: controller.isDarkMode.value,
            onChanged: (val) => controller.toggleTheme(),
            secondary: Icon(Icons.brightness_6),
          )),
          Divider(),
          ListTile(
            title: Text('language'.tr),
            leading: Icon(Icons.language),
            trailing: DropdownButton<String>(
              value: controller.currentLocale.value.languageCode,
              items: [
                DropdownMenuItem(child: Text('English'), value: 'en'),
                DropdownMenuItem(child: Text('العربية'), value: 'ar'),
              ],
              onChanged: (val) {
                if (val != null) controller.changeLanguage(val);
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Activity Logs (Admin)'),
            leading: Icon(Icons.receipt_long),
            onTap: () => Get.toNamed(AppRoutes.LOGS), 
          ),
        ],
      ),
    );
  }
}
