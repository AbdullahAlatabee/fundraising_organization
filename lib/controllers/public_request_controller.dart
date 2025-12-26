import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../data/database/database_helper.dart';
import '../data/models/donation_request_model.dart';

class PublicRequestController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  var pickedLocation = Rx<LatLng?>(null);
  var pickedImage = Rx<String?>(null);
  var isLoading = false.obs;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = image.path;
    }
  }

  void setLocation(LatLng location) {
    pickedLocation.value = location;
  }

  Future<void> submitRequest() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields', 
        backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final request = DonationRequest(
        name: nameController.text,
        phone: phoneController.text,
        description: descriptionController.text,
        imagePath: pickedImage.value,
        latitude: pickedLocation.value?.latitude,
        longitude: pickedLocation.value?.longitude,
        status: 'pending',
        createdAt: DateTime.now().toIso8601String(),
      );

      await _dbHelper.createRequest(request);

      Get.back(); // Close screen
      Get.snackbar('Success', 'Request submitted successfully', 
        backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit request: $e', 
        backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
