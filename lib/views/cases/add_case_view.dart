import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donation_case_controller.dart';
import 'dart:io';

class AddCaseView extends GetView<DonationCaseController> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController imageController = TextEditingController(); // For URL

  AddCaseView({Key? key}) : super(key: key) {
    controller.clearForm(); // Reset form state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add_case'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() {
                 final path = controller.pickedImagePath.value;
                 return Container(
                   height: 150,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     color: Colors.grey[200],
                     borderRadius: BorderRadius.circular(12),
                     border: Border.all(color: Colors.grey),
                     image: path != null 
                        ? DecorationImage(
                            image: FileImage(File(path)),
                            fit: BoxFit.cover
                          )
                        : null
                   ),
                   child: path == null 
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                            Text('pick_image'.tr, style: TextStyle(color: Colors.grey[600]))
                          ],
                        )
                      : null,
                 );
              }),
            ),
            SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'case_title'.tr, border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'description'.tr, border: OutlineInputBorder()),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'target_amount'.tr, border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'image_url'.tr, border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            Obx(() => controller.isLoading.value 
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    final title = titleController.text;
                    final desc = descController.text;
                    final amount = double.tryParse(amountController.text);
                    if (title.isEmpty || desc.isEmpty || amount == null) {
                      Get.snackbar('Error', 'invalid_inputs'.tr);
                      return;
                    }
                    // Pass image URL from text field if picker is empty, or both? 
                    // Priority to picker? Or Text field? 
                    // I will pass text field value as 'imagePath' argument. Controller will fallback to 'pickedImagePath.value' if argument is null.
                    String? finalPath = imageController.text.isNotEmpty ? imageController.text : null;
                    
                    await controller.addCase(title, desc, amount, finalPath);
                    Get.back();
                  }, 
                  child: Text('save_case'.tr)
                )
            ),
          ],
        ),
      ),
    );
  }
}
