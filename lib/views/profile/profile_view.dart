import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import 'dart:io';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We access AuthController for logout, logic in ProfileController for fields
    final authController = Get.find<AuthController>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Avatar
          Center(
            child: Stack(
              children: [
                Obx(() {
                  final path = controller.imagePath.value;
                  ImageProvider? image;
                  if (path != null && path.isNotEmpty) {
                    if (Uri.parse(path).isAbsolute && path.startsWith('http')) {
                      image = NetworkImage(path);
                    } else {
                      image = FileImage(File(path));
                    }
                  }
                  
                  return CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: image,
                    child: image == null 
                        ? Text(authController.currentUser.value?.name[0].toUpperCase() ?? 'U', 
                              style: TextStyle(fontSize: 40, color: Colors.grey[800])) 
                        : null,
                  );
                }),
                Obx(() => controller.isEditing.value 
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Get.theme.primaryColor,
                        radius: 20,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          onPressed: controller.pickImage,
                        ),
                      ),
                    )
                  : SizedBox.shrink()
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          
          // Fields
          Obx(() => TextField(
            controller: controller.nameController,
            enabled: controller.isEditing.value,
            decoration: InputDecoration(labelText: 'name'.tr, prefixIcon: Icon(Icons.person)),
          )),
          SizedBox(height: 16),
          Obx(() => TextField(
            controller: controller.emailController,
            enabled: false, // Email read-only
            decoration: InputDecoration(labelText: 'email'.tr, prefixIcon: Icon(Icons.email)),
          )),
          SizedBox(height: 16),
           TextFormField(
            initialValue: authController.currentUser.value?.role.toUpperCase(),
            enabled: false,
            decoration: InputDecoration(labelText: 'Role', prefixIcon: Icon(Icons.security)),
          ),
          SizedBox(height: 30),
          
          // Actions
          Obx(() {
            if (controller.isEditing.value) {
              return controller.isLoading.value 
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: controller.saveProfile,
                    child: Text('save'.tr),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  );
            } else {
              return ElevatedButton(
                onPressed: () => authController.logout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('logout'.tr),
              );
            }
          }),

          SizedBox(height: 16),
          if(!controller.isEditing.value)
            TextButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.SETTINGS), 
              icon: Icon(Icons.settings), 
              label: Text('settings'.tr)
            )
        ],
      ),
    );
  }
}

