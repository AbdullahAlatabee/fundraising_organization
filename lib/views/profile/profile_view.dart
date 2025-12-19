import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import 'dart:io';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
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
                        ? Text(
                            authController.currentUser.value?.name[0].toUpperCase() ?? 'U', 
                            style: TextStyle(fontSize: 40, color: Colors.grey[800])
                          ) 
                        : null,
                  );
                }),
                Obx(() {
                  if (controller.isEditing.value) {
                    return Positioned(
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
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
          SizedBox(height: 30),
          
          // Name Field
          Obx(() => TextField(
            controller: controller.nameController,
            enabled: controller.isEditing.value,
            decoration: InputDecoration(
              labelText: 'name'.tr, 
              prefixIcon: Icon(Icons.person)
            ),
          )),
          SizedBox(height: 16),
          
          // Email Field (read-only)
          TextField(
            controller: controller.emailController,
            enabled: false,
            decoration: InputDecoration(
              labelText: 'email'.tr, 
              prefixIcon: Icon(Icons.email)
            ),
          ),
          SizedBox(height: 16),
          
          // Role Field (read-only)
          TextFormField(
            initialValue: authController.currentUser.value?.role.toUpperCase(),
            enabled: false,
            decoration: InputDecoration(
              labelText: 'role'.tr, 
              prefixIcon: Icon(Icons.security)
            ),
          ),
          SizedBox(height: 30),
          
          // Action Buttons
          Obx(() {
            if (controller.isEditing.value) {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: controller.saveProfile,
                child: Text('save'.tr),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50)
                ),
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
          
          // Settings Button
          Obx(() {
            if (!controller.isEditing.value) {
              return TextButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.SETTINGS), 
                icon: Icon(Icons.settings), 
                label: Text('settings'.tr)
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
