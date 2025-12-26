import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/donation_case_controller.dart';
import 'dart:io';
import '../widgets/map_picker.dart';
import 'package:latlong2/latlong.dart';

class AddCaseView extends GetView<DonationCaseController> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController imageController = TextEditingController(); // For URL

  AddCaseView({Key? key}) : super(key: key) {
    controller.clearForm(); // Reset form state
    if (Get.arguments != null && Get.arguments is Map) {
       final args = Get.arguments as Map;
       titleController.text = args['name'] ?? '';
       descController.text = args['description'] ?? '';
       if (args['imagePath'] != null) {
          controller.pickedImagePath.value = args['imagePath'];
       }
       if (args['latitude'] != null && args['longitude'] != null) {
          controller.setLocation(LatLng(args['latitude'], args['longitude']));
       }
    }
  }

  void _showMapPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: Get.height * 0.8,
        child: MapPicker(
          initialLocation: controller.pickedLocation.value,
          onLocationPicked: (location) {
            controller.setLocation(location);
          },
        ),
      ),
    );
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
            Obx(() {
              final loc = controller.pickedLocation.value;
              return Column(
                children: [
                  if (loc != null)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.blue),
                        title: Text('Location Selected'),
                        subtitle: Text('${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}'),
                        trailing: IconButton(icon: Icon(Icons.edit), onPressed: () => _showMapPicker(context)),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () => _showMapPicker(context),
                    icon: const Icon(Icons.map),
                    label: Text(loc == null ? 'Select Location on Map' : 'Change Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: loc != null ? Colors.green : null,
                      foregroundColor: loc != null ? Colors.white : null,
                    ),
                  ),
                ],
              );
            }),
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
                    
                    await controller.addCase(
                      title, 
                      desc, 
                      amount, 
                      finalPath,
                      lat: controller.pickedLocation.value?.latitude,
                      lng: controller.pickedLocation.value?.longitude,
                      hasLoc: controller.pickedLocation.value != null
                    );
                    
                    // If this was from a request (check Get.arguments), we should update the request status.
                    // But Logic in View is tricky. Ideally Controller handles this if we passed requestId.
                    // Let's pass 'requestId' via arguments and handle it here or in Controller.
                    // Controller logic 'addCase' is generic.
                    // I'll add logic here:
                    if (Get.arguments != null && Get.arguments is Map && Get.arguments['requestId'] != null) {
                       await controller.completeRequest(Get.arguments['requestId']);
                    }
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
