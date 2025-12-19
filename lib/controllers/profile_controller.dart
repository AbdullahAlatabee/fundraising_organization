import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../data/database/database_helper.dart';
import '../data/models/user_model.dart';
import 'auth_controller.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  var isEditing = false.obs;
  var imagePath = Rxn<String>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _authController.currentUser.value;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      imagePath.value = user.imagePath;
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
      Get.snackbar('Error', 'Name is required');
      return;
    }
    
    isLoading.value = true;
    final currentUser = _authController.currentUser.value;
    if (currentUser != null) {
      final updatedUser = User(
        id: currentUser.id,
        name: nameController.text.trim(),
        email: currentUser.email, // Email usually not editable or complex
        password: currentUser.password,
        role: currentUser.role,
        createdAt: currentUser.createdAt,
        imagePath: imagePath.value,
      );
      
      await _dbHelper.updateUser(updatedUser);
      _authController.currentUser.value = updatedUser; // Update global state
      isEditing.value = false;
      Get.snackbar('Success', 'Profile updated');
    }
    isLoading.value = false;
  }
}
