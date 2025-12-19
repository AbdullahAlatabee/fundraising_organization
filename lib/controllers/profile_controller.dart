import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../data/database/database_helper.dart';
import '../data/models/user_model.dart';
import 'auth_controller.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  var isEditing = false.obs;
  var imagePath = Rxn<String>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Delay to ensure AuthController is ready
    Future.delayed(Duration.zero, () {
      _loadUserData();
    });
  }

  void _loadUserData() {
    try {
      final authController = Get.find<AuthController>();
      final user = authController.currentUser.value;
      if (user != null) {
        nameController.text = user.name;
        emailController.text = user.email;
        imagePath.value = user.imagePath;
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      _loadUserData(); // Reset if cancelled
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path;
    }
  }

  Future<void> saveProfile() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('error'.tr, 'name_required'.tr);
      return;
    }
    
    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser.value;
      
      if (currentUser != null) {
        final updatedUser = User(
          id: currentUser.id,
          name: nameController.text.trim(),
          email: currentUser.email,
          password: currentUser.password,
          role: currentUser.role,
          createdAt: currentUser.createdAt,
          imagePath: imagePath.value,
        );
        
        await _dbHelper.updateUser(updatedUser);
        authController.currentUser.value = updatedUser;
        isEditing.value = false;
        Get.snackbar('success'.tr, 'profile_updated'.tr);
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'update_failed'.tr);
      print('Error saving profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
