import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donor_controller.dart';
import '../../data/models/donor_model.dart';

class AddEditDonorView extends GetView<DonorController> {
  final Donor? existingDonor = Get.arguments as Donor?;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  AddEditDonorView({Key? key}) : super(key: key) {
    if (existingDonor != null) {
      nameController.text = existingDonor!.fullName;
      phoneController.text = existingDonor!.phone;
      addressController.text = existingDonor!.address ?? '';
      notesController.text = existingDonor!.notes ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(existingDonor == null ? 'add_donor'.tr : 'edit_donor'.tr)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'full_name'.tr, border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'phone'.tr, border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'address'.tr, border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: 'notes'.tr, border: OutlineInputBorder()),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            Obx(() => controller.isLoading.value 
              ? CircularProgressIndicator()
              : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
                      Get.snackbar('Error', 'required_field'.tr);
                      return;
                    }
                    if (existingDonor == null) {
                       await controller.addDonor(
                         nameController.text, 
                         phoneController.text, 
                         addressController.text, 
                         notesController.text
                       );
                    } else {
                       // Update logic
                       final updatedDonor = Donor(
                         id: existingDonor!.id,
                         fullName: nameController.text,
                         phone: phoneController.text,
                         address: addressController.text,
                         notes: notesController.text,
                         createdBy: existingDonor!.createdBy,
                         createdAt: existingDonor!.createdAt,
                       );
                       await controller.updateDonor(updatedDonor);
                    }
                    Get.back();
                  },
                  child: Text('save'.tr),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
