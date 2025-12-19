import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donation_case_controller.dart';

class AddCaseView extends GetView<DonationCaseController> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  // Image picker logic omitted for brevity, text field for URL or path
  final TextEditingController imageController = TextEditingController(); 

  AddCaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Case')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Case Title', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Target Amount', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'Image URL (optional)', border: OutlineInputBorder()),
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
                      Get.snackbar('Error', 'Invalid Inputs');
                      return;
                    }
                    await controller.addCase(title, desc, amount, imageController.text.isEmpty ? null : imageController.text);
                    Get.back();
                  }, 
                  child: Text('Save Case')
                )
            ),
          ],
        ),
      ),
    );
  }
}
